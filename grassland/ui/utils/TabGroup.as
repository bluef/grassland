package grassland.ui.utils {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import grassland.ui.utils.Tab;
	
	public class TabGroup extends EventDispatcher {
		private var _selection:Tab;
		public function TabGroup():void {
			super();
		}
		
		public function set selection(s:Tab):void {
			_selection.triggled = false;
			_selection = s;
			_selection.triggled = true;
			dispatchEvent(new Event(Event.CHANGE,true,false));
		}
		
		public function get selection():Tab {
			return _selection;
		}
		
		public function get selectedData():Object {
			return _selection.data;
		}
	}
}