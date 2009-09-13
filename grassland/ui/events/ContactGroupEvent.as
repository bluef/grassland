package grassland.ui.events {
	import flash.events.Event;
	public class ContactGroupEvent extends Event {
		public static const UNFOLD:String = "unfold_group";
		public static const FOLD:String = "fold_group";
		private var _name:String;
		
		public function ContactGroupEvent(etype:String,label:String){
			_name = label;
			super(etype,true,false);
		}
		
		public function set data(s:String):void{
			_name = s;
		}
		
		public function get data():String{
			return _name;
		}
	}
}