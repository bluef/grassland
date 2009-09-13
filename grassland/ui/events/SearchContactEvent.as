package grassland.ui.events {
	import flash.events.Event;
	public class SearchContactEvent extends Event {
		public static const SEARCH:String = "search_contact";
		private var _keyword:String;
		
		public function SearchContactEvent(s:String){
			_keyword = s;
			super(SEARCH,true,false);
		}
		
		public function get keyword():String{
			return _keyword;
		}
	}
}