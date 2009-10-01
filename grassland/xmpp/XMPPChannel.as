package grassland.xmpp {
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import grassland.xmpp.events.ChannelStateEvent;
	import grassland.xmpp.events.ChannelEvent;
	
	internal class XMPPChannel extends EventDispatcher{
		private var _socket:Socket;
		private var _host:String;
		private var _port:uint;
		private var _timer:Timer;
		private var _rawXML:String;
		private var _pattern:RegExp;
		private var _o:Array;
		private var _expireTagSearch:int = 0;
		
		public function XMPPChannel(host:String,pport:uint):void {
			init(host,pport);
		}
		
		private function init(host:String,pport:uint):void {
			_host = host;
			_port = pport;
			_socket = new Socket();
			_timer = new Timer(120000);
			
			_socket.addEventListener(Event.CONNECT,onConnect);
			_socket.addEventListener(Event.CLOSE,onDisconnect);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA,onRead);
			_socket.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
		}
		
		private function onTimer(e:TimerEvent):void {
			trace("send empty packet");
			sendData("  ");
		}
		
		public function connect():void {
			_socket.connect(_host,_port);
		}
		
		//send data
		public function sendData(s:String):void {
			//trace("SENT>>",s,"\n");
			//_timer.reset();
			_socket.writeUTFBytes(s);
			_socket.flush();
		}
		
		private function onConnect(e:Event):void {
			//trace("channel conected");
			_timer.start();
			dispatchEvent(new ChannelStateEvent(ChannelStateEvent.CONNECT));
		}
		
		private function onDisconnect(e:Event):void {
			dispatchEvent(new ChannelStateEvent(ChannelStateEvent.DISCONNECT));
		}
		
		public function disconnect():void {
			_socket.close();
		}
		
		//when new data is available
		private function onRead(e:ProgressEvent):void {
			_rawXML = _socket.readUTFBytes(_socket.bytesAvailable);
			//trace("[RECEIVED]>>",s,"\n");
			
			//trace("rawXML =",rawXML,"\n");
			//if(_expireTagSearch < 3) {
				_pattern = /\<\?xml/i;
				_o = _pattern.exec(_rawXML);
				if (_o != null) {
					trace("found");
					_rawXML = _rawXML.substring(38);
					_expireTagSearch++;
					//trace(rawXML);
				}
				
				_pattern = /\<stream:stream/i;
				_o = _pattern.exec(_rawXML);
				if (_o != null) {
					//trace(resultObj2[0]);
					_rawXML = _rawXML.concat("</stream:stream>");
					_expireTagSearch++;
					//trace(rawXML);
				}
				
				_pattern = /\<stream:features/;
				_o = _pattern.exec(_rawXML);
				if (_o != null) {
					//trace("found");
					var myPattern:RegExp = new RegExp("<stream:features>");  
					_rawXML = _rawXML.replace(myPattern, '<stream:features xmlns:stream="http://etherx.jabber.org/streams">');  
					_expireTagSearch++;
					//trace(rawXML);
				}
			//}

			_pattern = /\<\/stream:stream\>/;
			_o = _pattern.exec(_rawXML);
			if (_o != null) {
				dispatchEvent(new ChannelStateEvent(ChannelStateEvent.DISCONNECT));
				//trace(rawXML);
			}
			
			_pattern = /(\n|\r)/g;
			_rawXML = _rawXML.replace(_pattern, "&lt;br&gt;");
			
			_pattern = /(^\s+\<)/g;
			_rawXML = _rawXML.replace(_pattern, "");
			
			dispatchData(_rawXML);
		}
		
		/*
		private function onRead(e:ProgressEvent):void {
			//_timer.reset();
			var s:String = _socket.readUTFBytes(_socket.bytesAvailable);
			//trace("[RECEIVED]>>",s,"\n");
			var rawXML:String = s;
			var returnP:RegExp = /(\n|\r)/g;
			
			var testXML:XML;
			var isComplete:Boolean = false;
			//trace("rawXML =",rawXML,"\n");
			
			var pattern1:RegExp = new RegExp("<?xml ");
			var resultObj1:Object = pattern1.exec(rawXML);
			if (resultObj1 != null) {
				trace("found");
				rawXML = rawXML.substring(38);
				_expireTagSearch = true;
				//trace(rawXML);
			}
			
			var pattern2:RegExp = new RegExp("<stream:stream");
			var resultObj2:Object = pattern2.exec(rawXML);
			if (resultObj2 != null) {
				//trace(resultObj2[0]);
				rawXML = rawXML.concat("</stream:stream>");
				_expireTagSearch = true;
				//trace(rawXML);
			}
			
			var pattern4:RegExp = new RegExp("</stream:stream>");
			var resultObj4:Object = pattern4.exec(rawXML);
			if (resultObj4 != null) {
				dispatchEvent(new ChannelStateEvent(ChannelStateEvent.DISCONNECT));
				//trace(rawXML);
			}
		
			var pattern3:RegExp = new RegExp("<stream:features");
			var resultObj3:Object = pattern3.exec(rawXML);
			if (resultObj3 != null) {
				//trace("found");
				var myPattern:RegExp = new RegExp("<stream:features>");  
					rawXML = rawXML.replace(myPattern, '<stream:features xmlns:stream="http://etherx.jabber.org/streams">');  
				_expireTagSearch = true;
				//trace(rawXML);
			}
		
			//_imcompleteData = pasteData(rawXML);
			rawXML = rawXML.replace(returnP,"");
			dispatchData(rawXML);
		}
		*/
		
		private function dispatchData(s:String):void {
			var e:ChannelEvent = new ChannelEvent(s);
			e.data = s;
			dispatchEvent(e);
		}
		
		private function onIOError(e:IOErrorEvent):void {
			trace(e);
			dispatchEvent(new ChannelStateEvent(ChannelStateEvent.DISCONNECT));
		}
		
		private function onSecurityError(e:IOErrorEvent):void {
			trace(e);
		}
		
		public function disConnect():void {
			_socket.close();
		}
	}
}