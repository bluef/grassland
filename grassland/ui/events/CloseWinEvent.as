package grassland.ui.events {
	import flash.events.Event;
	import grassland.ui.managers.MsgWindowConfig;
	
	public class CloseWinEvent extends Event {
		public static const CLOSE:String = "win_close";
		
		private var _winConfig:MsgWindowConfig;
		
		public function CloseWinEvent(winConfig:MsgWindowConfig){
			_winConfig = winConfig.clone();
			
			super(CLOSE,true,false);
		}
		
		public function get config():MsgWindowConfig{
			return _winConfig.clone();
		}
	}
}