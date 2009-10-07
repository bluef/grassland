package grassland.ui.windows {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import fl.controls.CheckBox;
	import grassland.ui.base.BasicWindow;
	import grassland.ui.utils.DefaultTextFormat;
	import grassland.ui.utils.CmdBtn;
	import grassland.ui.utils.InputField;
	import grassland.ui.utils.LabelText;
	import grassland.ui.events.LoginEvent;
	
	public class LoginWindow extends BasicWindow {
		public static const CANCEL_UPDATE:String = "cancel_update_event";
		private var _userLabel:LabelText;
		private var _pwLabel:LabelText;
		private var _userText:InputField;
		private var _pwText:InputField;
		private var _loginState:TextField;
		private var _loginBtn:CmdBtn;
		private var _version:LabelText;
		private var _checkBox:CheckBox;
		
		private var _serverLabel:LabelText;
		private var _serverText:InputField;
		private var _portText:InputField;
		
		private var _domainLabel:LabelText;
		private var _domainText:InputField;
		private var _resourceText:InputField;
		
		public function LoginWindow() {
			super(380, 300, false);
			title = "Grassland - Login";
			
			init();
		}
		
		private function init():void {
			_userLabel = new LabelText("帐号", 200);
			_userLabel.x = 20;
			_userLabel.y = 20;
			_panel.addChild(_userLabel);
			
			_userText = new InputField(190, 20);
			_userText.x = 53;
			_userText.y = 20;
			_userText.tabIndex = 1;
			_userText.addEventListener(KeyboardEvent.KEY_DOWN, onEnter);
			_panel.addChild(_userText);
			
			_pwLabel = new LabelText("密码");
			_pwLabel.x = 20;
			_pwLabel.y = 60;
			_panel.addChild(_pwLabel);
			
			_pwText = new InputField(190, 20, true);
			_pwText.x = 53;
			_pwText.y = 60;
			_pwText.tabIndex = 2;
			_pwText.addEventListener(KeyboardEvent.KEY_DOWN, onEnter);
			_panel.addChild(_pwText);
			
			_serverLabel = new LabelText("服务器", 200);
			_serverLabel.x = 9;
			_serverLabel.y = 110;
			_panel.addChild(_serverLabel);
			
			_serverText = new InputField(140, 20);
			_serverText.x = 53;
			_serverText.y = 110;
			_serverText.tabIndex = 3;
			_serverText.text = '202.115.22.207';
			_panel.addChild(_serverText);
			
			_portText = new InputField(40, 20);
			_portText.x = 203;
			_portText.y = 110;
			_portText.tabIndex = 4;
			_portText.text = '5222';
			_panel.addChild(_portText);
			
			_domainLabel = new LabelText("域", 200);
			_domainLabel.x = 31;
			_domainLabel.y = 150;
			_panel.addChild(_domainLabel);
			
			_domainText = new InputField(140, 20);
			_domainText.x = 53;
			_domainText.y = 150;
			_domainText.tabIndex = 3;
			_domainText.text = 'dormforce.net';
			_panel.addChild(_domainText);
			
			_resourceText = new InputField(40, 20);
			_resourceText.x = 203;
			_resourceText.y = 150;
			_resourceText.tabIndex = 4;
			_resourceText.text = 'HOME';
			_panel.addChild(_resourceText);
			
			_checkBox = new CheckBox();
			_checkBox.label = "记住登录状态";
			_checkBox.selected = true;
			_checkBox.x = 50;
			_checkBox.y = 85;
			_panel.addChild(_checkBox);
			
			_loginBtn = new CmdBtn("登录", 80, 60);
			_loginBtn.x = 270;
			_loginBtn.y = 20;
			_loginBtn.addEventListener(MouseEvent.CLICK, onLoginBtnClicked);
			_panel.addChild(_loginBtn);
			
			_loginState = new LabelText();
			_loginState.width = 200;
			_loginState.x = 5;
			_loginState.y = 190;
			_panel.addChild(_loginState);
			
			stage.focus = _userText;
		};
		
		private function onEnter(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.ENTER) {
				login();
			}
		}
		
		private function onLoginBtnClicked(e:MouseEvent):void {
			login();
		}
		
		private function onCancelUpdate(e:MouseEvent):void {
			dispatchEvent(new Event(CANCEL_UPDATE, true, false));
		}
		
		private function login():Boolean {
			if (_userText.text == '') {
				setState("您忘了填写用户名喔");
				return false;
			}
			
			if (_pwText.text == '') {
				setState("您忘了填写密码喔");
				return false;
			}
			
			var a:Array  = _userText.text.split("@");
			var node:String;
    		
    		if (a.length > 1) {
    			node = a[0];
    		} else {
    			node = _userText.text;
    		}
    		
			var ee:LoginEvent = new LoginEvent(node, _pwText.text, _checkBox.selected, _serverText.text, _portText.text, _domainText.text, _resourceText.text);
			dispatchEvent(ee);
			setState("登录中...");
			return true;
		}
		
		public function set updating(s:Boolean):void {
			if (s) {
				var msk:Sprite = new Sprite();
				with (msk.graphics) {
					lineStyle(0);
					beginFill(0x333333, 0.3);
					drawRect(0, 0, _panel.width, _panel.height);
					endFill();
				}
				msk.y = _panel.y;
				stage.addChild(msk);
				var cancelBtn:CmdBtn = new CmdBtn("取消更新", 80, 26);
				cancelBtn.x = 160;
				cancelBtn.y = 30;
				cancelBtn.addEventListener(MouseEvent.CLICK, onCancelUpdate);
				msk.addChild(cancelBtn);
			} else {
				if (stage.contains(msk)) {
					stage.removeChild(msk);
				}
			}
		}
		
		public function authFailed():void {
			_loginState.text = "登录失败, 请检查您的用户名和密码是否正确";
		}
		
		public function authed():void {
			_loginState.text = "登录成功, 正在下载信息...";
		}
		
		public function setState(s:String):void {
			_loginState.text = s;
		}
		
		public function set username(s:String):void {
			_userText.text = s;
		}
		
		public function set password(s:String):void {
			_pwText.text = s;
		}
	}
}