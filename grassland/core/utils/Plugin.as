package grassland.core.utils {
	public class Plugin {
		private var _nicename:String;
		private var _filename:String;
		public function Plugin(n:String,f:String){
			_nicename = n;
			_filename = f;
		}
		
		public function get nicename():String{
			return _nicename;
		}
		
		public function get filename():String{
			return _filename;
		}
	}
}