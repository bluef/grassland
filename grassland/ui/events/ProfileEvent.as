package grassland.ui.events {
	import flash.events.Event;
	public class ProfileEvent extends Event {
		public static const UPDATED:String = "profile_updated";
		private var _show:String;
		private var _status:String;
		public function ProfileEvent(show:String,status:String){
			_show = show;
			_status = status;
			super(UPDATED,true,false);
		}
		
		public function set show(s:String):void{
			_show = s;
		}
		
		public function get show():String{
			return _show;
		}
		
		public function set status(s:String):void{
			_status = s;
		}
		
		public function get status():String{
			return _status;
		}
		
	}
}