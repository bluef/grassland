package grassland.ui.events {
	import flash.events.Event;
	public class ChangeStateEvent extends Event {
		public static const CHANGED:String = "state_changed";
		private var _show:String;
		private var _status:String;
		public function ChangeStateEvent(s1:String,s2:String){
			_show = s1;
			_status = s2;
			super(CHANGED,true,false);
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