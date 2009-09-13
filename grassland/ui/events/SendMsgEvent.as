package grassland.ui.events {
	import flash.events.Event;
	import grassland.ui.managers.MsgWindowConfig;
	
	public class SendMsgEvent extends Event {
		public static const SENT:String = "send_msg";
		
		private var _winConfig:MsgWindowConfig;
		private var _msg:String;
		
		public function SendMsgEvent(winConfig:MsgWindowConfig,msg:String){
			_winConfig = winConfig.clone();
			_msg = msg;
			
			super(SENT,true,false);
		}
		
		public function get msg():String{
			return _msg;
		}
		
		public function get config():MsgWindowConfig{
			return _winConfig.clone();
		}
	}
}