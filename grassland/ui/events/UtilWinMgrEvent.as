package grassland.ui.events {
	import flash.events.Event;
	public class UtilWinMgrEvent extends Event {
		public static const DEBUG_RAW_INPUT:String = "debug_raw_input";
		private var _data:Object;
		
		public function UtilWinMgrEvent(t:String, s:Object = null) {
			super(t, true, false);
			_data = s;
		}
		
		public function set data(value:Object):void{
			_data = value;
		}
		
		public function get data():Object{
			return _data;
		}
	}
}