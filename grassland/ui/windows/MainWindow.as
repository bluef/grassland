package grassland.ui.windows {
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.BitmapData;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowBoundsEvent;
	import flash.utils.getDefinitionByName;
	import flash.geom.Rectangle;
	
	import fl.events.ScrollEvent;
	//import fl.controls.UIScrollBar;
	
	import grassland.core.interfaces.ICommand;
	import grassland.core.roster.RosterGroup;
	
	import grassland.core.commands.ExitAppCommand;
	import grassland.core.commands.ShowUtilCommand;
	
	import grassland.ui.base.BasicWindow;
	import grassland.ui.events.ContactListEvent;
	import grassland.ui.events.ChangeStateEvent;
	import grassland.ui.events.SearchContactEvent;
	import grassland.ui.utils.contact.ContactListItem;
	import grassland.ui.utils.contact.ContactList;
	import grassland.ui.utils.MyProfile;
	import grassland.ui.utils.MainMenuBtn;
	import grassland.ui.utils.InputField;
	import grassland.ui.utils.ScrollBar;
	
	import grassland.ui.events.UtilWindowType;
	
	public class MainWindow extends BasicWindow {
		public static const PROFILE_INITED:String = "profile_inited";
		public static const HIDE_SHOW_OFFLINE:String = "hide_show_offline";
		public static const EXIT_APP:String = "exit_app";
		
		private var _myProfile:MyProfile;
		private var _contactList:ContactList;
		private var _msk:Sprite;
		private var _container:Sprite;
		private var _scrollBar:ScrollBar;
		private var _mainMenuBtn:MainMenuBtn;
		private var _mainMenu:NativeMenu;
		private var _searchBox:InputField;
		
		public function MainWindow() {
			trace("INITIATING MAIN WINDOWN");
			
			super(285, 525, true, 285, 525);
			title = "Grassland";
			
			init();
			
		}
		
		public function init():void {
			_myProfile = new MyProfile();
			_myProfile.x = 15;
			_myProfile.y = 16;
			_myProfile.addEventListener(MyProfile.UPDATED, onStateChange);
			_myProfile.addEventListener(Event.ADDED_TO_STAGE, onProfileInited);
			stage.addChild(_myProfile);
			
			_searchBox = new InputField();
			_searchBox.x = 0;
			_searchBox.y = 85;
			_searchBox.addEventListener(Event.CHANGE, searchContact);
			stage.addChild(_searchBox);
			
			_container = new Sprite();
			_container.y = 0;
			_panel.addChild(_container);
			
			_msk = new Sprite();
			_msk.graphics.lineStyle();
			_msk.graphics.beginFill(0x000000);
			_msk.graphics.drawRect(0, 0, 280, 410);
			_msk.graphics.endFill();
			_container.addChild(_msk);
			
			_contactList = new ContactList();
			_contactList.x = 1;
			_contactList.y = 0;
			_contactList.addEventListener(ContactListEvent.ITEM_CLICKED, onContactClick);
			_contactList.addEventListener(ContactList.UPDATED, resizeScrollbar);
			_contactList.mask = _msk;
			_container.addChild(_contactList);
			
			
			
			_scrollBar = new ScrollBar();
			_scrollBar.drawFocus(false);
			_scrollBar.x = 268;
			_scrollBar.y = 0;
			_scrollBar.height = 410;
			_scrollBar.pageScrollSize = 5;
			_scrollBar.addEventListener(ScrollEvent.SCROLL, onScroll);
			_container.addChild(_scrollBar);
			
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMWheel);
			
			_mainMenu = new NativeMenu();
			
			
			
			//addMenuItem("隐藏离线好友", "HideOfflineContactCommand");
			addMenuItem("关于", new ShowUtilCommand(UtilWindowType.ABOUT));
			addMenuItem("Debug", new ShowUtilCommand(UtilWindowType.DEBUG));
			addMenuItem("", null, true);
			addMenuItem("退出Grassland", new ExitAppCommand());
			
			_mainMenuBtn = new MainMenuBtn();
			_mainMenuBtn.x = 10;
			_mainMenuBtn.y = 410;
			_mainMenuBtn.addEventListener(MouseEvent.CLICK, showMainMenu);
			_panel.addChild(_mainMenuBtn);
			
			this.addEventListener(NativeWindowBoundsEvent.RESIZING, onResizeWin);
		}
		
		private function onContactClick(e:ContactListEvent):void {
			var c:ContactListEvent = new ContactListEvent(e.index, e.group);
			dispatchEvent(c);
			//trace(e.type);
		}
		
		public function updateLayout(r:RosterGroup):void {
			_contactList.updateLayout(r);
		}
		
		public function updateProfile(n:String, sshow:String, sstatus:String, a:BitmapData):void {
			_myProfile.nick = n;
			_myProfile.show = sshow;
			_myProfile.status = sstatus;
			_myProfile.avatar = a;
		}
		
		public function updateState(sshow:String, sstatus:String):void {
			_myProfile.show = sshow;
			_myProfile.status = sstatus;
		}
		
		private function onProfileInited(e:Event):void {
			dispatchEvent(new Event(PROFILE_INITED, true));
		}
		
		private function onStateChange(e:Event):void {
			dispatchEvent(new ChangeStateEvent(_myProfile.show, _myProfile.status));
		}
		
		private function onScroll(e:ScrollEvent):void {
			//trace(e.target.scrollPosition);
			//_contactList.y = 0 - e.target.scrollPosition;
			_contactList.y = (0 - e.target.scrollPosition) * 80 + 5;
		}
		
		private function onMWheel(e:MouseEvent):void {
			if (e.delta > 0) {
				if (_contactList.y < 0) {
					_contactList.y += e.delta * 5;
				} else {
					_contactList.y = 0;
				}
			} else {
				if (_contactList.y > 0 - _contactList.height + 500) {
					_contactList.y += e.delta * 5;
				}
			}
			//_scrollBar.scrollPosition = 0 - _contactList.y;
			_contactList.y = (0 - _scrollBar.scrollPosition) * 80 + 5;
		}
		
		private function resizeScrollbar(e:Event):void {
			//_scrollBar.maxScrollPosition = _contactList.height - 500;
			_scrollBar.maxScrollPosition = (_contactList.visualHeight - _scrollBar.height) / 80;
			
		}
		
		private function showMainMenu(e:MouseEvent):void {
			var p:Point = new Point(_mainMenuBtn.x - 4, _mainMenuBtn.y + 10);
			
			_mainMenu.display(stage, _panel.localToGlobal(p).x + 2, _panel.localToGlobal(p).y + 10)
		}
		
		private function addMenuItem(label:String, cmd:ICommand, isSeparator:Boolean = false):void {
			if (isSeparator) {
				_mainMenu.addItem(new NativeMenuItem('', true));
			} else {
				var item:NativeMenuItem = _mainMenu.addItem(new NativeMenuItem(label));
				trace("ADD MENUITEM: grassland.core.commands." + cmd);
				
				var o:Object = new Object();
				o.command = cmd;
				o.arg = label;
				item.data = o;
				item.addEventListener(Event.SELECT, onItemSelected);
			}
		}
		
		private function onItemSelected(e:Event):void {
			trace("MENU SELECT", e.target.label)
			var cmd:ICommand = NativeMenuItem(e.target).data.command;
			cmd.setArgs(NativeMenuItem(e.target).data.arg);
			cmd.exec();
		}
		
		private function searchContact(e:Event):void {
			dispatchEvent(new SearchContactEvent(e.target.text));
		}
		
		private function onResizeWin(e:NativeWindowBoundsEvent):void {
			if (!this.resizable) {
				return;
			}
			
			if (Rectangle(e.afterBounds).width < 285 || Rectangle(e.afterBounds).height < 525) {
				e.preventDefault();
				return;
			}
			
			_container.width = Rectangle(e.afterBounds).width;
			_msk.width = Rectangle(e.afterBounds).width;
			_contactList.width = Rectangle(e.afterBounds).width;
			_scrollBar.x = Rectangle(e.afterBounds).width - 14;
			_scrollBar.resize(0, Rectangle(e.afterBounds).height - 115);
		}
		
		override protected function closeWin(e:MouseEvent):void {
			this.stage.nativeWindow.minimize();
		};
	}
}