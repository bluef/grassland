package grassland.ui.events {
	import flash.events.Event;
	public class UtilWinEvent extends Event {
		public static const DATA:String = "util_window_data";
		private var _data:Object;
		public function UtilWinEvent(t:String, s:Object = null) {
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