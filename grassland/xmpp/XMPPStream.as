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
		public function XMPPStream (singlentonEnforcer:SingletonEnforcer) {
			_authed = false;
			_binded = false;
			_rostered = false;
			_sessioned = false;
		}
		
		public static function getInstance():XMPPStream {
			if (XMPPStream._instance == null) {
				XMPPStream._instance = new XMPPStream(new SingletonEnforcer());
			}
			return XMPPStream._instance;
		}
		
		//init the XMPPStream with username and password provided by Env
		public function init(user:JID, pw:String, server:String = XMPPConfig.HOST, port:uint = XMPPConfig.PORT, domain:String = XMPPConfig.DOMAIN, resource:String = XMPPConfig.RESOURCE):void {
			//connect to host		
			_dp = new XMPPDataPaster(server, port, domain, resource);
			
			_user = user.clone();
			connect();
			//and start to authenticate
			_auth = new XMPPAuth(_user.node, pw, _dp);
			
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
			try {
				s = new XML(ee.data);
				if (!_authed) {
				//start auth
				//trace("going to auth");
					_auth.auth(s);
				} else {
				//trace("authed");
					if (_binded) {
						if (!_sessioned) {
							setSession();
						} else {
							if (_rostered) {
								filterPacket(s);
							} else {
								setOnline("");
								getRoster();
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
			dispatchEvent(new XMPPEvent(XMPPEvent.RAW, XML(xmlsanza).toXMLString()));
			
			switch (XML(xmlsanza).name().localName) {
				case "message":
					pasteMsgSanza(XML(xmlsanza));
					break;
					
				case "presence":
					pastePresenceSanza(XML(xmlsanza));
					break;
					
				case "iq":
					//trace("IQ");
					pasteIQSanza(XML(xmlsanza));
					break;
					
				case "error":
					pasteErrorSanza(XML(xmlsanza));
					break;
			}
			
		}
		
		private function pasteMsgSanza(xmlsanza:XML):void {
			if (!XML(xmlsanza).hasOwnProperty('@type')) {
				pasteChatSanza(xmlsanza);
			} else {
				switch (XML(xmlsanza).@type) {
					case 'chat':
						pasteChatSanza(xmlsanza);
						break;
						
					case 'normal' :
						pasteChatSanza(xmlsanza);
						break;
						
					case 'error':
						break;
						
					case 'groupchat':
						break;
						
					case 'headline':
						pasteChatSanza(xmlsanza);
						break;
						
					default :
						pasteChatSanza(xmlsanza);
						break;
				}
			}			
		};
		
		private function pasteChatSanza(xmlsanza:XML):void {
			if (XML(xmlsanza).hasOwnProperty("body") && XML(xmlsanza).child("body").toXMLString() != '') {
				var packet:MessagePacket = new MessagePacket();
				packet.loadXML(XML(xmlsanza));
				var e:MessageEvent = new MessageEvent(packet);
				dispatchEvent(e);
			} else {
				if (XML(xmlsanza).CHAT_NS::composing.toXMLString() != '') {
				//trace(xmlsanza.@from.toString());
					var tte:TypingEvent = new TypingEvent(new JID(XML(xmlsanza).@from.toString()), TypingEvent.TYPING);
					dispatchEvent(tte);
				} else if (XML(xmlsanza).CHAT_NS::paused.toXMLString() != '') {
					var tpe:TypingEvent = new TypingEvent(new JID(XML(xmlsanza).@from.toString()), TypingEvent.PAUSED);
					dispatchEvent(tpe);
				}
			}
		};
		
		private function pastePresenceSanza(xmlsanza:XML):void {
			var packet:PresencePacket = new PresencePacket();
			if (xmlsanza.hasOwnProperty('@type')) {
				packet.type = XML(xmlsanza.@type);
			}
			
			packet.loadXML(XML(xmlsanza));
			var pe:PresenceEvent = new PresenceEvent(packet);
			dispatchEvent(pe);
		};
		
		private function pasteIQSanza(xmlsanza:XML):void {
			var ipacket:IQPacket = new IQPacket();
			ipacket.loadXML(XML(xmlsanza));
			var ie:IQEvent = new IQEvent(ipacket);
			dispatchEvent(ie);
		};
		
		private function pasteErrorSanza(xml:XML):void {
			var errMsg:String = '';
			switch (XML(xml).elements("*")[0].name().localName) {
				case "bad-namespace-prefix" :
					errMsg = "实体发送的名字空间前缀不被支持，或者在一个需要某种前缀的元素中没有发送一个名字空间前缀";
					break;
					
				case "conflict" :
					errMsg = "服务器正在关闭为这个实体激活的流，因为一个和已经存在的流有冲突的新的流已经被初始化";
					break;
					
				case "connection-timeout" :
					errMsg = "实体已经很长时间没有通过这个流发生任何通信流量(可由一个本地服务策略来配置)";
					break;
					
				case "host-gone" :
					errMsg = "初始化实体在流的头信息中提供的'to'属性的值所指定的主机已经不再由这台服务器提供";
					break;
					
				case "host-unknown" :
					errMsg = "由初始化实体在流的头信息中提供的 'to' 属性的值和由服务器提供的主机名不一致";
					break;
					
				case "improper-addressing" :
					errMsg = "一个在两台服务器之间传送的节缺少 'to' 或 'from' 属性(或者这个属性没有值)";
					break;
					
				case "internal-server-error" :
					errMsg = "服务器配置错误或者其他未定义的内部错误,使得服务器无法提供流服务";
					break;
					
				case "invalid-from" :
					errMsg = "在'from'属性中提供的 JID 或 主机名地址，和认证的 JID不匹配 或服务器之间无法通过SASL（或回拨）协商出合法的域名，或客户端和服务器之间无法通过它进行认证和资源绑定";
					break;
					
				case "invalid-id" :
					errMsg = "流 ID 或回拨 ID 是非法的或和以前提供的 ID 不一致";
					break;
					
				case "invalid-namespace" :
					errMsg = "流名字空间错误";
					break;
					
				case "invalid-xml" :
					errMsg = "实体通过流发送了一个非法的XML给执行验证的服务器";
					break;
					
				case "not-authorized" :
					errMsg = "实体试图在流被验证之前发送数据或不被许可执行一个和流协商有关的动作";
					break;
					
				case "policy-violation" :
					errMsg = "实体违反了某些本地服务策略";
					break;
					
				case "remote-connection-failed" :
					errMsg = "服务器无法正确连接到用于验证或授权的远程实体";
					break;
					
				case "resource-constraint" :
					errMsg = "服务器缺乏必要的系统资源为流服务";
					break;
					
				case "restricted-xml" :
					errMsg = "实体试图发送受限的XML特性，比如一个注释，处理指示，DTD，实体参考，或保留的字符";
					break;
					
				case "see-other-host" :
					errMsg = "服务器将不提供服务给初始化实体但是把它重定向到另一台主机";
					break;
					
				case "system-shutdown" :
					errMsg = "服务器正在关机并且所有激活的流正在被关闭";
					break;
					
				case "undefined-condition" :
					errMsg = "错误条件不在本文已定义的错误条件列表之中.";
					break;
					
				case "unsupported-encoding" :
					errMsg = "初始化实体以一个服务器不不支持的编码方式编码了一个流(参照Character Encoding (第十一章第五节)). ";
					break;
					
				case "unsupported-stanza-type" :
					errMsg = "初始化实体发送了一个流的一级子元素但是服务器不支持. ";
					break;
					
				case "unsupported-version" :
					errMsg = "由初始化实体在流的头信息中指定的'version'属性的值所指定的版本不被服务器支持;服务器可以(MAY)在<text/>元素中指定一个它支持的版本号. ";
					break;
					
				case "xml-not-well-formed" :
					errMsg = "初始化实体发送了一个不规范的XML";
					break;
			}
			
			dispatchEvent(new XMPPEvent(XMPPEvent.ERROR, errMsg)); //XMPPEvent.ERROR, errMsg
			
		};
		
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
			packet.to = new JID(_dp.domain);
			packet.ptype = IQPacket.TYPE_SET;
			var xmlns:Object = new Object();
			xmlns.tag = "xmlns";
			xmlns.value = IQPacket.BIND_RESOURCE;
			packet.addXMLChild("", "bind", '', xmlns);
			packet.addXMLChild("bind", "resource", _dp.resource);
			
			sendData(packet.toXMLString());
			_binded = true;
		}
		
		//set session
		private function setSession():void {
			var p:IQPacket = new IQPacket();
			p.ptype = IQPacket.TYPE_SET;
			p.to = new JID(_dp.domain);
			var xn:Object = new Object();
			xn.tag = "xmlns";
			xn.value = "urn:ietf:params:xml:ns:xmpp-session";
			p.addXMLChild("", "session", "", xn);
			sendData(p.toXMLString());
			_sessioned = true;
		}
		
		//get roster
		public function getRoster():void {
			var packet:IQPacket = new IQPacket();
			packet.to = new JID(_dp.domain);
			packet.ptype = IQPacket.TYPE_GET;
			var xmlns:Object = new Object();
			xmlns.tag = "xmlns";
			xmlns.value = IQPacket.QUERY_ROSTER;
			packet.addXMLChild("","query",'',xmlns);
			sendData(packet.toXMLString());
			_rostered = true;
			
			sendData("<presence type='probe' from='" + JID(_user).node + "@" + _dp.domain + "/" + _dp.resource + "' to='" + _dp.domain + "'/>");
		}
		
		public function tellBroatcast():void {
			var packet:IQPacket = new IQPacket();
			packet.to = new JID(_dp.domain);
			packet.ptype = IQPacket.TYPE_GET;
			var xmlns:Object = new Object();
			xmlns.tag = "xmlns";
			xmlns.value = "http://jabber.org/protocol/disco#info";
			packet.addXMLChild("", "query", '', xmlns);
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
			var packet:PresencePacket = new PresencePacket(PresencePacket.TYPE_UNAVAILABLE);
			packet.priority = 10;
			sendData(packet.toXMLString());
			
			disconnect();
		}
		
		public function subscribe(s:JID, name:String = '', group:String = ''):void {
			addRoster(JID(s), JID(s).node, group);
			
			var packet:PresencePacket = new PresencePacket(PresencePacket.TYPE_SUBSCRIBE);
			packet.to = JID(s).clone();
			sendData(packet.toXMLString());
		};
		
		public function unsubscribe(s:JID):void {
			var packet:PresencePacket = new PresencePacket(PresencePacket.TYPE_UNSUBSCRIBE);
			packet.to = JID(s).clone();
			sendData(packet.toXMLString());
			
			deleteRoster(s);
		};
		
		public function handleSubReq(approve:Boolean, s:JID, name:String = '', group:String = ''):void {
			var type:String = PresencePacket.TYPE_SUBSCRIBED;
			if (!approve) {
				type = PresencePacket.TYPE_UNSUBSCRIBED;
			}
			var packet:PresencePacket = new PresencePacket(type);
			packet.to = JID(s).clone();
			sendData(packet.toXMLString());
			
			if (name == '') {
				name = JID(s).node;
			}
			
			if (approve) {
				subscribe(JID(s), name, group);
			}
		};
		
		
		public function sysHandleSubReq(approve:Boolean, s:JID, name:String = '', group:String = ''):void {
			var type:String = PresencePacket.TYPE_SUBSCRIBE;
			if (!approve) {
				type = PresencePacket.TYPE_UNSUBSCRIBE;
			}
			var packet:PresencePacket = new PresencePacket(type);
			packet.to = JID(s).clone();
			sendData(packet.toXMLString());
			
			if (name == '') {
				name = JID(s).node;
			}
		};
		
		
		public function addRoster(jid:JID, name:String = '', group:String = ''):void {
			var packet:IQPacket = new IQPacket();
			packet.ptype = IQPacket.TYPE_SET;
			var xmlns:Object = new Object();
			xmlns.tag = "xmlns";
			xmlns.value = IQPacket.QUERY_ROSTER;
			packet.addXMLChild("", "query", '', xmlns);
			packet.addXMLChild("query", "item", '', {tag:"jid", value:JID(jid).toString()}, {tag:"name", value:(name == '' ? JID(jid).node : name)});
			if (group != '') {
				packet.addXMLChild("query", "group", group)
			}
			
			sendData(packet.toXMLString());
		};
		
		public function updateRoster(jid:JID, name:String = '', group:String = '', subscription:String = 'both'):void {
			var packet:IQPacket = new IQPacket();
			packet.ptype = IQPacket.TYPE_SET;
			var xmlns:Object = new Object();
			xmlns.tag = "xmlns";
			xmlns.value = IQPacket.QUERY_ROSTER;
			packet.addXMLChild("", "query", '', xmlns);
			packet.addXMLChild("query", "item", '', {tag:"jid", value:JID(jid).toString()}, {tag:"name", value:(name == '' ? JID(jid).node : name)}, {tag:"subscription", value:subscription});
			if (group != '') {
				packet.addXMLChild("query", "group", group)
			}
			
			sendData(packet.toXMLString());
		};
		
		public function deleteRoster(jid:JID):void {
			var packet:IQPacket = new IQPacket();
			packet.ptype = IQPacket.TYPE_SET;
			var xmlns:Object = new Object();
			xmlns.tag = "xmlns";
			xmlns.value = IQPacket.QUERY_ROSTER;
			packet.addXMLChild("", "query", '', xmlns);
			packet.addXMLChild("query", "item", '', {tag:"jid", value:JID(jid).toString()}, {tag:"subscription", value:"remove"});
			
			sendData(packet.toXMLString());
		};
		
		public function typingTo(s:JID):void {
			sendData("<message from='" + _user.valueOf() + "' to='" + s.valueOf() + "' type='chat'><composing xmlns='http://jabber.org/protocol/chatstates'/></message>");
		}
	}
}

class SingletonEnforcer {}