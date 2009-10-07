package grassland.ui.windows {
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextFieldType;
	
	import fl.controls.ComboBox;
	
	import grassland.core.Env;
	
	import grassland.ui.base.BasicWindow;
	import grassland.ui.utils.LabelText;
	import grassland.ui.utils.InputField;
	import grassland.ui.utils.CmdBtn;
	
	import grassland.ui.events.UtilWinEvent;
	
	import grassland.ui.interfaces.IUtilWindow;
	
	public class SubscribeWindow extends BasicWindow implements IUtilWindow {
		public static const SUBSCRIBE_MODE:String = "Subwin_subscribe_mode";
		public static const APPROVE_MODE:String = "Subwin_approve_mode";
		
		private var _mode:String;
		
		private var _jidLabel:LabelText;
		private var _jidText:InputField;
		private var _nameLabel:LabelText;
		private var _nameText:InputField;
		private var _groupLabel:LabelText;
		private var _groupBox:ComboBox;
		private var _okBtn:CmdBtn;
		private var _cancelBtn:CmdBtn;

		private var _group:String;
		
		private var _id:String = "grassland.ui.windows::SubscribeWindow";
		
		public function SubscribeWindow(mode:String = SubscribeWindow.APPROVE_MODE):void {
			_mode = mode;
			
			super(380, 220, false);
			title = "Add to your contact";
			
			init();
		}
		
		private function init():void {
			_group = '';
			
			_jidLabel = new LabelText("帐号", 200);
			_jidLabel.x = 20;
			_jidLabel.y = 20;
			_panel.addChild(_jidLabel);
			
			_jidText = new InputField(190, 20);
			_jidText.x = 53;
			_jidText.y = 20;
			_jidText.tabIndex = 1;
			_panel.addChild(_jidText);
			
			if (_mode == APPROVE_MODE) {
				_jidText.type = TextFieldType.DYNAMIC;
			}
			
			_nameLabel = new LabelText("备注");
			_nameLabel.x = 20;
			_nameLabel.y = 60;
			_panel.addChild(_nameLabel);
			
			_nameText = new InputField(190, 20);
			_nameText.x = 53;
			_nameText.y = 60;
			_nameText.tabIndex = 2;
			_panel.addChild(_nameText);
			
			_groupLabel = new LabelText("分组");
			_groupLabel.x = 20;
			_groupLabel.y = 100;
			_panel.addChild(_groupLabel);
			
			_groupBox = new ComboBox();
			_groupBox.setSize(190, 22);
            _groupBox.addEventListener(Event.CHANGE, onGroupSelect);
            _groupBox.x = 53;
            _groupBox.y = 100;
            _panel.addChild(_groupBox);
            
            groupsData = Env.getInstance().groupsData;
            
    		_okBtn = new CmdBtn("添加好友", 80, 30);
			_okBtn.x = 270;
			_okBtn.y = 40;
			_okBtn.addEventListener(MouseEvent.CLICK, onOkBtnClicked);
			_panel.addChild(_okBtn);
			
			if (_mode == APPROVE_MODE) {
				_cancelBtn = new CmdBtn("拒绝请求", 80, 30);
			} else {
				_cancelBtn = new CmdBtn("取消", 80, 30);
			}
			
			_cancelBtn.x = 270;
			_cancelBtn.y = 90;
			_cancelBtn.addEventListener(MouseEvent.CLICK, onCancelBtnClicked);
			_panel.addChild(_cancelBtn);    
		}
		
		public function get id():String {
			return _id;
		};
		
		public function set groupsData(groups:Vector.<String>):void {
			if (groups.length > 0) {
				_group = groups[0];
				var ll:int = groups.length;
				for	(var i:int = 0; i < ll; ++i) {
					_groupBox.addItem({label:groups[i], data:groups[i]});
				}
			}
			
		};
		
		private function onGroupSelect(e:Event):void {
			_group = ComboBox(_groupBox).selectedItem.data;
		};
		
		public function get group():String {
			return _group;
		};
		
		public function set jid(value:String):void {
			_jidText.text = value;
		};
		
		private function onOkBtnClicked(e:MouseEvent):void {
			if (_jidText.text == '') {
				
			} else {
				var type:String = "subscribe";
				trace(_jidText.text, _nameText.text, _group);
				switch ( _mode ) {
					case SUBSCRIBE_MODE :
						type = "subscribe";
						break;
						
					case APPROVE_MODE :
						type = "approveSubscribe";
						break;
				}
				dispatchEvent(new UtilWinEvent(UtilWinEvent.DATA, {type:type, jid:_jidText.text, cname:_nameText.text, group:_group}));
			}
		};
		
		private function onCancelBtnClicked(e:MouseEvent):void {
			if (_mode == APPROVE_MODE) {
				dispatchEvent(new UtilWinEvent(UtilWinEvent.DATA, {type:'denySubscribe', jid:_jidText.text})); //UtilWinEvent.DATA, {type:'unsubscribe', jid:_jidText.text}
				
			}
		};
		
		override protected function closeWin(e:MouseEvent):void {
			dispatchEvent(new Event(Event.CLOSING)); //Event.CLOSING
		}
	}
}