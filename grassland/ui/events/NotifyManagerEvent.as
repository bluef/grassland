package grassland.ui.events {
	import flash.events.Event;
	import grassland.core.utils.JID;
	
	public class NotifyManagerEvent extends Event {
		public static const CLICK:String = "notify_click";
		private var _from:JID;
		private var _type:String;
		
		public function NotifyManagerEvent(from:JID,wtype:String){
			_from = from.clone();
			_type = wtype;
			super(CLICK,true,false);
		}
		
		public function get from():JID{
			return _from.clone();
		}
		
		public function get wtype():String{
			return _type;
		}
	}
}