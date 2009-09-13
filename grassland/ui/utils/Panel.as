package grassland.ui.managers {
	import flash.display.Sprite;
	import flash.html.HTMLLoader;
	
	import grassland.ui.interfaces.IScrollable;
	import grassland.ui.events.ContactListEvent;
	import grassland.ui.utils.Tab;
	import grassland.ui.utils.TabGroup;
	import grassland.ui.utils.contact.ContactListItem;
	import grassland.ui.utils.contact.ContactList;
	import grassland.ui.utils.ScrollBar;
	
	public class Panel extends Sprite {
		private var _config:XML;
		private var _tabGroup:TabGroup;
		private var _tabs:Vector.<Tab>;
		private var _contactList:ContactList;
		private var _html:HTMLLoader;
		private var _scrollBar:ScrollBar;
		private var _msk:Sprite;
		private var _container:Sprite;
		
		public function Panel():void {
			init();
		}
		
		private function init():void {
			_container = new Sprite();
			_container.y = 0;
			_panel.addChild(_container);
			
			_msk = new Sprite();
			_msk.graphics.lineStyle();
			_msk.graphics.beginFill(0x000000);
			_msk.graphics.drawRect(0,0,280,410);
			_msk.graphics.endFill();
			_container.addChild(_msk);
			
			_contactList = new ContactList();
			_contactList.x = 1;
			_contactList.y = 0;
			_contactList.addEventListener(ContactListEvent.ITEM_CLICKED,onContactClick);
			_contactList.addEventListener(ContactList.UPDATED,resizeScrollbar);
			_contactList.mask = _msk;
			_container.addChild(_contactList);
			
			_html = new HTMLLoader();
			_html.width = 270;
			_html.height = 410;
			
			_scrollBar = new UIScrollBar();
			_scrollBar.drawFocus(false);
			_scrollBar.x = 268;
			_scrollBar.y = 0;
			_scrollBar.height = 410;
			_scrollBar.pageScrollSize = 5;
			_scrollBar.host = _contactList;
			//_scrollBar.addEventListener(ScrollEvent.SCROLL,onScroll);
			addChild(_scrollBar);
			
			_tabGroup = new TabGroup();
			_tabGroup.addEventListener(Event.CHANGE, onTabChange);
		}
		
		public function loadConfig(s:XML):void {
			_config = XML(s).copy();
			pasteXML();
		}
		
		private function pasteXML():void {
			for each (var child:XML in _config) {
				var tab:Tab = new Tab(child.tooltip, child.logo, child.url);
				_tabs.push(tab);
				_tabs[_tabs.length - 1].x = _tabs.length * 40;
				_tabs[_tabs.length - 1].y = 200;
				addChild(_tabs[_tabs.length - 1]);
			}
		}
		
		private function onTabChange(e:Event):void {
			if (e.target.selection.data.tooltips == "Chat"){
				if(!_container.contains(_contactList)){
					_container.removeChild(_html);
					_container.addChild(_contactList);
					_scrollBar.host = _contactList;
				}
			}else{
				_scrollBar.host = _html;
				_container.addChild(_html);
				_html.load(e.target.selection.data.url);
			}
		}
		
		private function onContactClick(e:ContactListEvent):void{
			var c:ContactListEvent = new ContactListEvent(e.index,e.group);
			dispatchEvent(c);
			//trace(e.type);
		}
		
		private function onScroll(e:ScrollEvent):void{
			//trace(e.target.scrollPosition);
			_contactList.y = 0 - e.target.scrollPosition;
		}
	}
}