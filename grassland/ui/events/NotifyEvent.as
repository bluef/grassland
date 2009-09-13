package grassland.ui.events {
	import flash.events.Event;
	import grassland.core.utils.JID;
	
	public class NotifyEvent extends Event {
		public static const CLICK:String = "notify_click";
		public static const TIMEUP:String = "time_up";
		
		public static const TYPE_MSG:String = "type_msg";
		public static const TYPE_SHOW:String = "type_show";
		
		private var _wid:String;
		private var _from:JID;
		private var _type:String;
		
		public function NotifyEvent(t:String,wid:String,from:JID,ptype:String){
			_wid = wid;
			_from = from.clone();
			_type = ptype;
			super(t,true,false);
		}
		
		public function get wid():String{
			return _wid;
		}
		
		public function get from():JID{
			return _from.clone();
		}
		
		public function get wtype():String{
			return _type;
		}
	}
}