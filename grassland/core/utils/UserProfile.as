package grassland.core.utils {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import grassland.core.utils.JID;
	public class UserProfile {
		private var _user:JID;
		private var _pw:String;
		private var _avatar:BitmapData;
		private var _show:String;
		private var _status:String;
		private var _nick:String;
		
		public function UserProfile(username:String, passwd:String){
			_user = new JID(username + "@dormforce.net");
			_pw = passwd;
			_avatar = new BitmapData(48,48);
			_nick = '';
		}
		
		public function get user():JID {
			return _user;
		}
		
		public function set password(s:String):void {
			_pw = s;
		}
		
		public function get password():String {
			return _pw;
		}
		
		public function set avatar(b:BitmapData):void{
			_avatar = b.clone();
		}
		
		public function get avatar():BitmapData {
			return _avatar;
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
		
		public function set nick(value:String):void {
			_nick = value;
		};
		
		public function get nick():String {
			if (_nick == '') {
				return _user.toString();
			} else {
				return _nick;
			}
		};
		
		public function clone():UserProfile {
			var i:UserProfile = new UserProfile(_user.node,_pw);
			i.show = _show;
			i.status = _status;
			
			return i;
		}
	}
}