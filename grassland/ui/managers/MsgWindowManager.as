package grassland.ui.managers {
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.desktop.NotificationType;
	import grassland.core.Env;
	import grassland.core.utils.JID;
	import grassland.core.roster.RosterItem;
	import grassland.ui.managers.MsgWindowConfig;
	import grassland.ui.windows.MessageWindow;
	import grassland.ui.events.*;
	import grassland.xmpp.packets.MessagePacket;
	
	public class MsgWindowManager extends EventDispatcher {
		private static var _instance:MsgWindowManager;
		//store msg window instances
		private var _winArr:Vector.<MessageWindow>;
		
		public function MsgWindowManager(singlentonEnforcer:SingletonEnforcer){
			_winArr = new Vector.<MessageWindow>();
		}
		
		public static function getInstance():MsgWindowManager{
			if(MsgWindowManager._instance == null){
				MsgWindowManager._instance = new MsgWindowManager(new SingletonEnforcer());
			}
			return MsgWindowManager._instance;
		}
		
		//append msg to the chat log panel
		public function appendMsg(config:MsgWindowConfig,packet:MessagePacket):void{
			//get the index of specified window configuration and update it
			var tmpWin:MessageWindow = searchWin(config);
			var msg:String = packet.body;
			msg = msg.replace(/\</g, "&lt;");
			msg = msg.replace(/\>/g, "&gt;");
			//msg = msg.replace(/\n/g, "<br />");
			var r:RosterItem = Env.getInstance().getRosterItemByJID(packet.from);
			if(r.nick == null || r.nick == ''){
				tmpWin.addText("  <b>" + packet.from.node + " :</b><br />    " + msg);
			}else{
				tmpWin.addText("  <b>" + r.nick + " :</b><br />    " + msg);
			}
			tmpWin.guestTyping("stopped");
		}
		
		private function searchWin(c:MsgWindowConfig):MessageWindow{
			/*
			var l:uint = _winArr.length;
			for(var i:uint = 0;i<l;i++){
				if(_winArr[i].config.guest.uid.node == c.guest.uid.node){
					return i;
				}
			}
			return -1;
			*/
			
			var searchFunc:Function = function (item:MessageWindow, index:int, vector:Vector.<MessageWindow>):Boolean {
				return (JID(MsgWindowConfig(item.config).guest.uid).node == JID(c.guest.uid).node);
			}
			
			var filterItems:Vector.<MessageWindow> = _winArr.filter(searchFunc, null);
			if (filterItems.length == 0) {
				return null;
			} else {
				return filterItems[0];
			}
		}
		
		public function isWinActived(c:MsgWindowConfig):Boolean{
			if(searchWin(c) != null){
				return true;
			}else{
				return false;
			}
		}
		
		//create a new msg window with paticular configure file
		public function newMsgWindow(config:MsgWindowConfig):MessageWindow{
			trace("open new msg win:",config.guest.uid.node);
			var tmpWin:MessageWindow = searchWin(config);
			if(tmpWin != null){
				tmpWin.notifyUser(NotificationType.CRITICAL);
				return tmpWin;
			}else{
				var pos:uint = _winArr.length;
				var newMsgWin:MessageWindow = new MessageWindow(config.clone());
				_winArr.push(newMsgWin);
				_winArr[pos].addEventListener(MessageWindow.TYPING,onTyping,false,0,true);
				_winArr[pos].addEventListener(SendMsgEvent.SENT,onMsgSend,false,0,true);
				_winArr[pos].addEventListener(CloseWinEvent.CLOSE,closeWinHandler,false,0,true);
				_winArr[pos].addEventListener(MinWinEvent.MINISIZE,minWinHandler,false,0,true);
				_winArr[pos].addEventListener(MoveWinEvent.MOVE,moveWinHandler,false,0,true);
				_winArr[pos].addEventListener(Event.CLOSING,closeWin,false,0,true);
				_winArr[pos].updateProfile(config.guest.nick,config.guest.show,config.guest.status,config.guest.avatar);
				_winArr[pos].activate();
				_winArr[pos].notifyUser(NotificationType.CRITICAL);
				return _winArr[pos];
			}
			
		}
		
		public function updateProfile(config:MsgWindowConfig):void {
			
		}
		
		public function guestTyping(r:MsgWindowConfig, t:Boolean):void {
			var tmpWin:MessageWindow = searchWin(r);
			if(tmpWin != null){
				if(t){
					tmpWin.guestTyping("typing");
				}else{
					tmpWin.guestTyping("paused");
				}
			}
		}
		
		private function onTyping(e:Event):void{
			dispatchEvent(new MsgWinManagerEvent(MsgWinManagerEvent.TYPING,e.target.config.guest.uid.clone()));
		}
		
		//dispatch a event when the SEND button pressed
		private function onMsgSend(e:SendMsgEvent):void{
			var ee:MsgWinManagerEvent = new MsgWinManagerEvent(MsgWinManagerEvent.MSG,e.config.guest.uid.clone(),e.msg,MessagePacket.TYPE_CHAT);
			dispatchEvent(ee);
			var msg:String = e.msg;
			msg = msg.replace(/\</g, "&lt;");
			msg = msg.replace(/\>/g, "&gt;");
			
			MessageWindow(e.target).addText("  <b>Me :</b><br />    " + msg);
			MessageWindow(e.target).guestTyping("stopped");
		}
		
		//handle msg window's close order
		private function closeWinHandler(e:CloseWinEvent):void{
			var winConfig:MsgWindowConfig = e.config;
			var tmpWin:MessageWindow = searchWin(winConfig);
			tmpWin.removeEventListener(MessageWindow.TYPING,onTyping);
			tmpWin.removeEventListener(SendMsgEvent.SENT,onMsgSend);
			tmpWin.removeEventListener(CloseWinEvent.CLOSE,closeWinHandler);
			tmpWin.removeEventListener(MinWinEvent.MINISIZE,minWinHandler);
			tmpWin.removeEventListener(MoveWinEvent.MOVE,moveWinHandler);
			tmpWin.removeEventListener(Event.CLOSE,closeWin);
			tmpWin.dispose();
			_winArr.splice(_winArr.indexOf(tmpWin), 1)[0] = null;
		}
		
		private function closeWin(e:Event):void{
			e.preventDefault();
			
			var winConfig:MsgWindowConfig = e.target.config;
			var tmpWin:MessageWindow = searchWin(winConfig);
			tmpWin.removeEventListener(MessageWindow.TYPING,onTyping);
			tmpWin.removeEventListener(SendMsgEvent.SENT,onMsgSend);
			tmpWin.removeEventListener(CloseWinEvent.CLOSE,closeWinHandler);
			tmpWin.removeEventListener(MinWinEvent.MINISIZE,minWinHandler);
			tmpWin.removeEventListener(MoveWinEvent.MOVE,moveWinHandler);
			tmpWin.removeEventListener(Event.CLOSE,closeWin);
			tmpWin.dispose();
			_winArr.splice(_winArr.indexOf(tmpWin), 1)[0] = null;
		}
		
		//handle msg window's minisize order 
		private function minWinHandler(e:MinWinEvent):void{
			var winConfig:MsgWindowConfig = e.config;
			var tmpWin:MessageWindow = searchWin(winConfig);
			tmpWin.minimize();
		}
		
		//handle msg window's maxsize order
		private function moveWinHandler(e:MoveWinEvent):void{
			var winConfig:MsgWindowConfig = e.config;
			var tmpWin:MessageWindow = searchWin(winConfig);
			tmpWin.startMove();
		}
	}
}
class SingletonEnforcer {}