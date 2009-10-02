package grassland.core.roster {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import grassland.core.utils.JID;
	
	public class RosterItem {
		private var _name:String;
		private var _uid:JID;
		private var _group:String;
		private var _show:String;
		private var _status:String;
		private var _avatar:BitmapData;
		
		public function RosterItem(ruid:JID, rshow:String = null, rstatus:String = null) {
			_uid = ruid.clone();
			_show = rshow;
			_status = rstatus;
			_avatar = new BitmapData(1, 1);
		}
		
		public function clone():RosterItem {
			var i:RosterItem = new RosterItem(_uid, _show, _status);
			i.group = _group;
			i.nick = _name;
			return i;
		}
		
		public function set uid(s:JID):void {
			_uid = s.clone();
		}
		
		public function get uid():JID {
			return _uid.clone();
		}
		
		public function set show(s:String):void {
			_show = s;
		}
		
		public function get show():String {
			return _show;
		}
		
		public function set status(s:String):void {
			_status = s;
		}
		
		public function get status():String {
			return _status;
		}
		
		public function get avatar():BitmapData {
			return _avatar;
		}
		
		public function set avatar(b:BitmapData):void {
			_avatar = b.clone();
		}
		
		public function set nick(s:String):void {
			_name = s;
		}
		
		public function get nick():String {
			return _name;
		}
		
		public function set group(s:String):void {
			_group = s;
		}
		
		public function get group():String {
			return _group;
		}
	}
}