package grassland.core.events {
	import flash.events.Event;
	public class RosterUpdateEvent extends Event {
		public static const UPDATED:String = "updated";
		private var _pos:uint;
		public function RosterUpdateEvent(pos:uint){
			super(UPDATED,true,false);
			_pos = pos;
		}
		
		public function set pos(s:uint):void{
			_pos = pos;
		}
		
		public function get pos():uint{
			return _pos;
		}
	}
}