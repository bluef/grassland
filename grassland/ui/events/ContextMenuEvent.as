package grassland.ui.events {
	import flash.events.Event;
	public class ContextMenuEvent extends Event {
		public static const SELECT:String = "context_menu_selected";
		private var _data:Object;
		
		public function ContextMenuEvent(s:Object):void{
			_data = Object;
			super(SELECT,true,false);
		}
		
		public function set data(s:Object):void{
			_data = s;
		}
		
		public function get data():Object{
			return _data;
		}
	}
}