package grassland.ui.events {
	import flash.events.Event;
	import grassland.core.utils.JID;
	
	public class MsgWinManagerEvent extends Event {
		public static const MSG:String = "message_send";
		public static const TYPING:String = "message_typing";
		private var _to:JID;
		private var _msg:String;
		private var _type:String;
		private var _etype:String;
		
		public function MsgWinManagerEvent(t:String,pto:JID,pmsg:String = null,ptype:String = null){
			_etype = t;
			_to = pto.clone();
			_msg = pmsg;
			_type = ptype;
			super(_etype,true,false);
		}
		
		public function set to(pto:JID):void{
			_to = pto.clone();
		}
		
		public function get to():JID{
			return _to.clone();
		}
		
		public function set msg(pmsg:String):void{
			_msg = pmsg;
		}
		
		public function get msg():String{
			return _msg;
		}
		
		public function set wtype(ptype:String):void{
			_type = ptype;
		}
		
		public function get wtype():String{
			return _type;
		}
	}
}