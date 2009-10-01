package grassland.ui.events {
	import flash.events.Event;
	public class LoginEvent extends Event {
		public static const LOGIN:String = "login";
		private var _user:String;
		private var _pw:String;
		private var _server:String = '';
		private var _port:uint = 0;
		private var _domain:String = '';
		private var _resource:String = '';
		private var _checked:Boolean;
		
		public function LoginEvent(user:String, passwd:String, checked:Boolean, server:String = '', port:String = '', domain:String = '', resource:String = '') {
			_user = user;
			_pw = passwd;
			_checked = checked;
			
			if (server != '') {
				_server = server;
			}
			
			if (port != '') {
				_port = uint(port);
			}
			
			if (domain != '') {
				_domain = domain;
			}
			
			if (resource != '') {
				_resource = resource;
			}
			
			super(LOGIN,true,false);
		}
		
		public function set user(s:String):void {
			_user = s;
		}
		
		public function get user():String {
			return _user;
		}
		
		public function set password(s:String):void {
			_pw = s;
		}
		
		public function get password():String {
			return _pw;
		}
		
		public function set checked(s:Boolean):void {
			_checked = s;
		}
		
		public function get checked():Boolean {
			return _checked;
		}
		
		public function set server(s:String):void {
			_server = s;
		}
		
		public function get server():String {
			return _server;
		}
		
		public function set port(s:uint):void {
			_port = s;
		}
		
		public function get port():uint {
			return _port;
		}
		
		public function set domain(s:String):void {
			_domain = s;
		}
		
		public function get domain():String {
			return _domain;
		}
		
		public function set resource(s:String):void {
			_resource = s;
		}
		
		public function get resource():String {
			return _resource;
		}
		
	}
}