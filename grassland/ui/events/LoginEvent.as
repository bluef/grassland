package grassland.ui.events {
	import flash.events.Event;
	public class LoginEvent extends Event {
		public static const LOGIN:String = "login";
		private var _user:String;
		private var _pw:String;
		private var _checked:Boolean;
		public function LoginEvent(user:String,passwd:String,checked:Boolean){
			_user = user;
			_pw = passwd;
			_checked = checked;
			if(_checked){
				//trace("11111111111111111111");
			}
			super(LOGIN,true,false);
		}
		
		public function set user(s:String):void{
			_user = s;
		}
		
		public function get user():String{
			return _user;
		}
		
		public function set password(s:String):void{
			_pw = s;
		}
		
		public function get password():String{
			return _pw;
		}
		
		public function set checked(s:Boolean):void{
			_checked = s;
		}
		
		public function get checked():Boolean{
			return _checked;
		}
		
		
	}
}