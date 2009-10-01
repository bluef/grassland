package grassland.xmpp {
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import grassland.core.utils.JID;
	import grassland.xmpp.events.*;
	import grassland.xmpp.utils.*;
	import grassland.xmpp.packets.*;
	import grassland.xmpp.XMPPConfig;
	import grassland.xmpp.XMPPAuth;
	import grassland.xmpp.XMPPDataPaster;
	
	public class XMPPStream extends EventDispatcher{
		public static const DISCONNECT:String = "disconnect";
		public static const CONNECT:String = "connect";
		public static const AUTH_SUCCESS:String = "xmpp_auth_success";
		public static const AUTH_FAILURE:String = "xmpp_auth_failure";
		private static const CHAT_NS:Namespace = new Namespace("http://jabber.org/protocol/chatstates");
		
		private static var _instance:XMPPStream;
		
		public static const AAA:String = "aaa";
		
		private var _user:JID;
		private var _pw:String;
		private var _auth:XMPPAuth;
		private var _dp:XMPPDataPaster;
		private var _id:String;
		
		private var _authed:Boolean;
		private var _binded:Boolean;
		private var _rostered:Boolean;
		private var _sessioned:Boolean;
				
		//singleton mode
		public function XMPPStream (singlentonEnforcer:SingletonEnforcer){
			//connect to host
			_dp = new XMPPDataPaster(XMPPConfig.HOST,XMPPConfig.PORT);
			
			_authed = false;
			_binded = false;
			_rostered = false;
			_sessioned = false;
		}
		
		public static function getInstance():XMPPStream{
			if (XMPPStream._instance == null){
				XMPPStream._instance = new XMPPStream(new SingletonEnforcer());
			}
			return XMPPStream._instance;
		}
		
		//init the XMPPStream with username and password provided by Env
		public function init(user:JID,pw:String):void {
			_user = user.clone();
			connect();
			//and start to authenticate
			_auth = new XMPPAuth(_user.node,pw,_dp);
			
			configureListeners();
		}
		
		//public method to connect to host
		public function connect():void {
			_dp.connect();
		}
		
		
		//disconnect from host after send a end-xmlstream sanza
		public function disconnect():void {
			_dp.disconnect();
		}
		
		//configure event listener of all the sub modules
		private function configureListeners():void {
			
			_dp.addEventListener(DataEvent.DATA, onData);
			_dp.addEventListener(ChannelStateEvent.CONNECT, onChannelState);
			_dp.addEventListener(ChannelStateEvent.DISCONNECT, onChannelState);
			//handle auth result
			_auth.addEventListener(XMPPAuth.AUTH_SUCCESS, onAuthSuc);
			_auth.addEventListener(XMPPAuth.AUTH_FAILURE, onAuthFail);
		}
		
		//start a new stream by sending begin-xmlstream sanza
		private function onChannelState(e:Event):void {
			dispatchEvent(new Event(e.type,true));
		}
		
		private function onData(ee:DataEvent):void {
			var s:XML;
			try{
				s = new XML(ee.data);
				if (!_authed){
				//start auth
				//trace("going to auth");
					_auth.auth(s);
				}else{
				//trace("authed");
					if (_binded) {
						if (!_sessioned){
							setSession();
						} else {
							if (_rostered) {
								filterPacket(s);
							} else {
								setOnline("");
								getRoster();
								_dp.sendData("<presence type='probe' from='bluef@dormforce.net/NUT2' to='dormforce.net'/>");
							}
						}
					} else {
						bindResource();
					}
				}
			} catch(e) {
				trace("[ERROR]>>", e);
				trace("[ERROR-SANZA]>>", ee.data);
			}
			//trace("e.data =",e.data.toXMLString());
			/*if (e.data.elements("*")[0].name().uri === "urn:ietf:params:xml:ns:xmpp-bind"){
				_binded = true;
			}
			if (e.data.elements("*")[0].name().uri === "jabber:iq:roster"){
				_rostered = true;
			}
			*/
			
		}
		
		//set auth state
		private function onAuthSuc(e:Event):void {
			_authed = true;
			dispatchEvent(new Event(AUTH_SUCCESS,true));
		}
		
		private function onAuthFail(e:Event):void {
			_authed = false;
			dispatchEvent(new Event(AUTH_FAILURE,true));
		}
		
		public function goOn():void {
			bindResource();			
		}
		
		public function sendData(sanza:String):void {
			dispatchEvent(new XMPPEvent(XMPPEvent.RAW, sanza));
			
			_dp.sendData(sanza);
		};
		
		//create diffrent sub-class packet by check xmlsanza's localname 
		private function filterPacket(xmlsanza:XML):void {
			//dispatch the raw data of incoming sanza
			dispatchEvent(new XMPPEvent(XMPPEvent.RAW, xmlsanza.toXMLString()));
			
			switch(xmlsanza.name().localName){
				case "message":
					if (xmlsanza.hasOwnProperty("body") && xmlsanza.child("body").toXMLString() != ''){
						var packet:MessagePacket = new MessagePacket();
						packet.loadXML(xmlsanza);
						var e:MessageEvent = new MessageEvent(packet);
						dispatchEvent(e);
					} else if (xmlsanza.CHAT_NS::composing.toXMLString() != ''){
						//trace(xmlsanza.@from.toString());
						var tte:TypingEvent = new TypingEvent(new JID(xmlsanza.@from.toString()),TypingEvent.TYPING);
						dispatchEvent(tte);
					} else if (xmlsanza.CHAT_NS::paused.toXMLString() != ''){
						var tpe:TypingEvent = new TypingEvent(new JID(xmlsanza.@from.toString()),TypingEvent.PAUSED);
						dispatchEvent(tpe);
					}
					break;
					
				case "presence":
					var ppacket:PresencePacket = new PresencePacket();
					ppacket.loadXML(xmlsanza);
					var pe:PresenceEvent = new PresenceEvent(ppacket);
					dispatchEvent(pe);
					break;
					
				case "iq":
					//trace("IQ");
					var ipacket:IQPacket = new IQPacket();
					ipacket.loadXML(xmlsanza);
					var ie:IQEvent = new IQEvent(ipacket);
					dispatchEvent(ie);
					break;
			}
			
		}
		
		//public method for creating a new msg packet
		public function newMessage(pto:JID,pbody:String):void {
			var packet:MessagePacket = new MessagePacket();
			packet.to = pto;
			packet.from = _user;
			packet.body = pbody;
			packet.type = MessagePacket.TYPE_CHAT;
			sendData(packet.toXMLString());
		}
		
		//base method to set current state
		public function newPresence(pshow:String,pstatus:String,ptype:String,pto:JID = null,ppriority:int=8):void {
			var packet:PresencePacket = new PresencePacket();
			packet.to = pto;
			packet.from = _user;
			packet.show = pshow;
			packet.status = pstatus;
			packet.type = ptype;
			packet.priority = ppriority;
			sendData(packet.toXMLString());
		}
		
		//base method to create a new IQ packet
		public function newIQ(ptype:String,paction:String,pto:JID):void {
			var packet:IQPacket = new IQPacket();
			packet.to = pto;
			packet.from = _user;
			packet.ptype = ptype;
			sendData(packet.toXMLString());
		}
		
		//bind the resource after auth
		private function bindResource():void {
			var packet:IQPacket = new IQPacket();
			packet.to = new JID("dormforce.net");
			packet.ptype = IQPacket.TYPE_SET;
			var xmlns:Object = new Object();
			xmlns.tag = "xmlns";
			xmlns.value = IQPacket.BIND_RESOURCE;
			packet.addXMLChild("","bind",'',xmlns);
			packet.addXMLChild("bind","resource","Grassland");
			sendData(packet.toXMLString());
			_binded = true;
		}
		
		//set session
		private function setSession():void {
			var p:IQPacket = new IQPacket();
			p.ptype = IQPacket.TYPE_SET;
			p.to = new JID("dormforce.net");
			var xn:Object = new Object();
			xn.tag = "xmlns";
			xn.value = "urn:ietf:params:xml:ns:xmpp-session";
			p.addXMLChild("","session","",xn);
			sendData(p.toXMLString());
			_sessioned = true;
		}
		
		//get roster
		public function getRoster():void {
			var packet:IQPacket = new IQPacket();
			packet.to = new JID("dormforce.net");
			packet.ptype = IQPacket.TYPE_GET;
			var xmlns:Object = new Object();
			xmlns.tag = "xmlns";
			xmlns.value = IQPacket.QUERY_ROSTER;
			packet.addXMLChild("","query",'',xmlns);
			sendData(packet.toXMLString());
			_rostered = true;
		}
		
		public function tellBroatcast():void {
			var packet:IQPacket = new IQPacket();
			packet.to = new JID("dormforce.net");
			packet.ptype = IQPacket.TYPE_GET;
			var xmlns:Object = new Object();
			xmlns.tag = "xmlns";
			xmlns.value = "http://jabber.org/protocol/disco#info";
			packet.addXMLChild("","query",'',xmlns);
			sendData(packet.toXMLString());
		}
		
		public function setOnline(pstatus:String):void {
			var packet:PresencePacket = new PresencePacket();
			packet.status = pstatus;
			packet.priority = 10;
			sendData(packet.toXMLString());
		}
		
		public function setAway(pstatus:String):void {
			var packet:PresencePacket = new PresencePacket();
			packet.show = PresencePacket.SHOW_AWAY;
			packet.status = pstatus;
			packet.priority = 10;
			sendData(packet.toXMLString());
		}
		
		public function setXa(pstatus:String):void {
			var packet:PresencePacket = new PresencePacket();
			packet.show = PresencePacket.SHOW_XA;
			packet.status = pstatus;
			packet.priority = 10;
			sendData(packet.toXMLString());
		}
		
		public function setBusy(pstatus:String):void {
			var packet:PresencePacket = new PresencePacket();
			packet.show = PresencePacket.SHOW_DND;
			packet.status = pstatus;
			packet.priority = 10;
			sendData(packet.toXMLString());
		}
		
		public function setOffline():void {
			disconnect();
		}
		
		public function typingTo(s:JID):void {
			sendData("<message from='"+_user.valueOf()+"' to='"+s.valueOf()+"' type='chat'><composing xmlns='http://jabber.org/protocol/chatstates'/></message>");
		}
	}
}

class SingletonEnforcer {}