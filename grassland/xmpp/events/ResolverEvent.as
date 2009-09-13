package grassland.xmpp.events {
	import flash.events.Event;
	public class ResolverEvent extends Event {
		public static const TAIL:String = "data_tail"
		private var _data:String;
		public function ResolverEvent(s:String){
			super(TAIL,true,false);
			//data = new XML();
			//data = s.copy();
			_data = s;
		}
		
		public function set data(s:String):void{
			//_data = s.copy();
			_data = s;
		}
		
		public function get data():String{
			//return _data.copy();
			return _data;
		}
	}
}