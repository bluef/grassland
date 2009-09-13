package grassland.ui.events {
	import flash.events.Event;
	import grassland.ui.managers.MsgWindowConfig;
	
	public class MinWinEvent extends Event {
		public static const MINISIZE:String = "win_minisized";
		
		private var _winConfig:MsgWindowConfig;
		
		public function MinWinEvent(winConfig:MsgWindowConfig){
			_winConfig = winConfig.clone();
			
			super(MINISIZE,true,false);
		}
		
		public function get config():MsgWindowConfig{
			return _winConfig.clone();
		}
	}
}