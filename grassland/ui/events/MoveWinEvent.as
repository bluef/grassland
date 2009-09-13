package grassland.ui.events {
	import flash.events.Event;
	import grassland.ui.managers.MsgWindowConfig;
	
	public class MoveWinEvent extends Event {
		public static const MOVE:String = "win_move";
		
		private var _winConfig:MsgWindowConfig;
		
		public function MoveWinEvent(winConfig:MsgWindowConfig){
			_winConfig = winConfig.clone();
			
			super(MOVE,true,false);
		}
		
		public function get config():MsgWindowConfig{
			return _winConfig.clone();
		}
	}
}