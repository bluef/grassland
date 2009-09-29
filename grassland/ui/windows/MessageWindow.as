package grassland.ui.windows {
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.events.NativeWindowBoundsEvent;
	import flash.ui.Keyboard;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.StyleSheet;
	import flash.geom.Rectangle;
	
	import fl.events.ScrollEvent;
	
	import grassland.core.utils.JID;
	
	import grassland.ui.managers.MsgWindowConfig;
	import grassland.ui.base.BasicWindow;
	import grassland.ui.utils.DefaultTextFormat;
	import grassland.ui.utils.InputField;
	import grassland.ui.utils.ProfileBlock;
	import grassland.ui.utils.ScrollBar;
	import grassland.ui.events.SendMsgEvent;
	import grassland.ui.events.CloseWinEvent;
	
	public class MessageWindow extends BasicWindow {
		public static const TYPING:String = "is_typing";
		private static var _isTyping:Typing;
		
		private var _config:MsgWindowConfig;
		
		private var txtFormat:DefaultTextFormat;
		private var _disArea:TextField;
		private var _inputArea:TextField;
		
		private var _guestProfile:ProfileBlock;
		//private var _sendBtn:CmdBtn;

		//private var _bar:Sprite;
		private var _scrollBar:ScrollBar;
		
		public function MessageWindow(config:MsgWindowConfig) {
			_config = config.clone();			
			super(350, 460, true, 350, 460);
			title = JID(_config.guest.uid).valueOf();
			init();
		}
		
		private function init():void {
			if(_isTyping == null) {
				_isTyping = new Typing();
			}
			_guestProfile = new ProfileBlock();
			_guestProfile.x = 15;
			_guestProfile.y = 16;
			stage.addChild(_guestProfile);
			
			txtFormat = new DefaultTextFormat();
			txtFormat.leftMargin = 5;
			txtFormat.rightMargin = 10;
			
			_disArea = new TextField();
			_disArea.multiline = true;
			_disArea.wordWrap = true;
			_disArea.defaultTextFormat = txtFormat;
			_disArea.width = width - 20;
			
			_disArea.height = 305;
			_disArea.x = 0;
			_disArea.y = 5;
			
			_panel.addChild(_disArea);
			
			_inputArea = new InputField(290, 20);
			_inputArea.wordWrap = true;
			_inputArea.defaultTextFormat = txtFormat;
			_inputArea.height = 50;
			_inputArea.width = width - 2;
			_inputArea.x = 0;
			_inputArea.y = height - 155;
			_inputArea.addEventListener(KeyboardEvent.KEY_DOWN, onEnter);
			_inputArea.addEventListener(Event.CHANGE, onTyping);

			_panel.addChild(_inputArea);
			stage.focus = _inputArea;
			
			_scrollBar = new ScrollBar();
			_scrollBar.drawFocus(false);
			_scrollBar.x = width - 16;
			_scrollBar.y = 0;
			_scrollBar.height = height - 155;
			_scrollBar.pageScrollSize = 5;
			_scrollBar.addEventListener(ScrollEvent.SCROLL, onScroll);
			_panel.addChild(_scrollBar);
			
			configureListener();
		}
		
		private function drawBackground():void {
			var bg:Sprite = new Sprite();
			with (bg.graphics) {
				lineStyle(1);
				beginFill(0x000000);
					drawRoundRect(0, 0, 480, 500, 5, 5);
				endFill();
			}
			_panel.addChildAt(bg,  0);
		}
		
		private function configureListener():void {
			//_sendBtn.addEventListener(MouseEvent.CLICK, sendMsg);
			//_closeBtn.addEventListener(MouseEvent.CLICK, closeWin);
			//_minBtn.addEventListener(MouseEvent.CLICK, minWin);
			//_bar.addEventListener(MouseEvent.MOUSE_DOWN, moveWin);
			this.addEventListener(NativeWindowBoundsEvent.RESIZING,  onResizeWin);
			
		}
		
		private function onEnter(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.ENTER) {
				var ee:SendMsgEvent = new SendMsgEvent(_config, _inputArea.text);
				dispatchEvent(ee);
				_inputArea.text = "";
			}
		}
		
		public function guestTyping(s:String):void {
			switch (s) {
				case "typing":
					if (!stage.contains(_isTyping)) {
						_isTyping.x = 140;
						_isTyping.y = 40;
						stage.addChild(_isTyping);
					}
					_isTyping.visible = true;
					_isTyping.play();
					break;
					
				case "paused":
					if (!stage.contains(_isTyping)) {
						_isTyping.x = 140;
						_isTyping.y = 40;
						stage.addChild(_isTyping);
					}
					_isTyping.visible = true;
					_isTyping.stop();
					break;
					
				case "stopped":
					if (stage.contains(_isTyping)) {
						_isTyping.visible = false;
					}
					break;
			}
		}
		
		private function onTyping(e:Event):void {
			dispatchEvent(new Event(TYPING, true));
		}
		
		private function sendMsg(e:MouseEvent):void {
			var ee:SendMsgEvent = new SendMsgEvent(_config, _inputArea.text);
			dispatchEvent(ee);
			_inputArea.text = "";
		}
		
		protected override function closeWin(e:MouseEvent):void {
			var ee:CloseWinEvent = new CloseWinEvent(_config);
			dispatchEvent(ee);
		}
		
		public function addText(pmsg:String):void {
			//_disArea.htmlText += pmsg + "<br />";
			_disArea.htmlText = [_disArea.htmlText, pmsg + "<br />"].join('');
			trace("ADD TEXT:", pmsg);
			//_scrollBar.maxScrollPosition = (_disArea.maxScrollV - _scrollBar.height) / 50;
			
			_disArea.scrollV = _disArea.maxScrollV;
			_scrollBar.maxScrollPosition = _disArea.maxScrollV / 5;
			_scrollBar.scrollPosition = _scrollBar.maxScrollPosition;
		}
		
		public function get config():MsgWindowConfig {
			return _config;
		}
		
		public function updateProfile(n:String, sshow:String, sstatus:String, a:BitmapData):void {
						
			loadAvatar(JID(_config.guest.uid).node);
			_guestProfile.nick = n;
			_guestProfile.show = sshow;
			_guestProfile.status = sstatus;
		}
		
		/*
		private function onMWheel(e:MouseEvent):void {
			if(e.delta > 0) {
				if(_contactList.y < 0) {
					_contactList.y += e.delta*5;
				}else {
					_contactList.y = 0;
				}
			}else {
				if(_contactList.y > 0 - _contactList.height + 500) {
					_contactList.y += e.delta*5;
				}
			}
			_scrollBar.scrollPosition = 0 - _contactList.y;
		}
		*/
		
		private function onScroll(e:ScrollEvent):void {
			//_disArea.scrollV = e.target.scrollPosition;
			_disArea.scrollV = ScrollBar(e.target).scrollPosition * 5;
		}
		
		public function dispose():void {
			_guestProfile.disposeAvatar();
			_disArea.styleSheet = null;
			super.close();
		}
		
		public function set styleSheet(value:StyleSheet):void {
			if (value != null) {
				_disArea.styleSheet = value;
			}
		};
		
		private function loadAvatar(u:String):void {
			var r:URLRequest = new URLRequest("http://www2.dormforce.net/cache/imgc.php?a=get&m=uid&u=" + u);
			var l:Loader = new Loader();
			LoaderInfo(l.contentLoaderInfo).addEventListener(Event.COMPLETE, onAvatarLoaded);
			l.load(r);
		}
		
		private function onAvatarLoaded(e:Event):void {
			var u:String = e.target.url.substring(55);
			_guestProfile.avatar = Bitmap(e.target.content).bitmapData;
			LoaderInfo(e.target).removeEventListener(Event.COMPLETE, onAvatarLoaded);
			//dispatchEvent(new Event(ROSTER_UPDATED, true));
			//trace("b=", getRosterItemByNode(u).avatar.getPixel(10, 10));
			//getRosterItemByNode(u).avatar.addChild(e.target.content);
		}
		
		private function onResizeWin(e:NativeWindowBoundsEvent):void {
			if(!this.resizable){
				return;
			}
			
			if(Rectangle(e.afterBounds).width < 350 || (e.afterBounds).height < 460){
				e.preventDefault();
				return;
			}
			
			_inputArea.width = Rectangle(e.afterBounds).width - 2;
			_disArea.width = Rectangle(e.afterBounds).width;
			_disArea.height = (e.afterBounds).height - 155;
			_inputArea.y = height - 155;
			_scrollBar.x = (e.afterBounds).width - 16;
			_scrollBar.resize(0, Rectangle(e.afterBounds).height - 155);
		}
	}
}