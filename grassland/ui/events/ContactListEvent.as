package grassland.ui.events {
	import flash.events.Event;
	
	public class ContactListEvent extends Event {
		public static const ITEM_CLICKED:String = "item_clicked";
		private var _index:int;
		private var _groupName:String;
		
		public function ContactListEvent(i:int,group:String){
			_index = i;
			_groupName = group;
			super(ITEM_CLICKED,true,false);
		}
		
		public function get index():int{
			return _index;
		}
		
		public function get group():String{
			return _groupName;
		}
	}
}