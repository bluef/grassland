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
		public function LoginWindow() {
			super(380, 200, false);
			title = "Grassland - Login";
			width = 380;
			height = 200;
			
			_userLabel = new LabelText("帐号", 200);
			_userLabel.x = 17;
			_userLabel.y = 20;
			_panel.addChild(_userLabel);
			
			_userText = new InputField(190, 20);
			_userText.x = 50;
			_userText.y = 20;
			_userText.tabIndex = 1;
			_userText.addEventListener(KeyboardEvent.KEY_DOWN, onEnter);
			_panel.addChild(_userText);
			
			_pwLabel = new LabelText("密码");
			_pwLabel.x = 17;
			_pwLabel.y = 60;
			_panel.addChild(_pwLabel);
			
			_pwText = new InputField(190, 20, true);
			_pwText.x = 50;
			_pwText.y = 60;
			_pwText.tabIndex = 2;
			_pwText.addEventListener(KeyboardEvent.KEY_DOWN, onEnter);
			_panel.addChild(_pwText);
			
			_checkBox = new CheckBox();
			_checkBox.label = "记住登录状态";
			_checkBox.x = 50;
			_checkBox.y = 85;
			//_panel.addChild(_checkBox);
			
			_loginBtn = new CmdBtn("登录", 80, 60);
			_loginBtn.x = 270;
			_loginBtn.y = 20;
			_loginBtn.addEventListener(MouseEvent.CLICK, onLoginBtnClicked);
			_panel.addChild(_loginBtn);
			
			_loginState = new LabelText();
			_loginState.width = 200;
			_panel.addChild(_loginState);
			
			stage.focus = _userText;
		}
		
		private function onEnter(e:KeyboardEvent):void {
			if(e.keyCode == Keyboard.ENTER) {
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
			if(_userText.text == '') {
				setState("您忘了填写用户名喔");
				return false;
			}
			if(_pwText.text == '') {
				setState("您忘了填写密码喔");
				return false;
			}
			var a:Array  = _userText.text.split("@");
			var node:String;
    	
    		if(a.length > 1) {
    			node = a[0];
    		}else {
    			node = _userText.text;
    		}
			var ee:LoginEvent = new LoginEvent(node, _pwText.text, true);
			dispatchEvent(ee);
			setState("登录中...");
			return true;
		}
		
		public function set updating(s:Boolean):void {
			if(s) {
				var msk:Sprite = new Sprite();
				with(msk.graphics) {
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
			}else {
				if(stage.contains(msk)) {
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