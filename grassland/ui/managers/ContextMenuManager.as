package grassland.ui.managers {
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.ContextMenuEvent;
	import flash.display.InteractiveObject;
	import flash.display.NativeMenu;
	import grassland.core.interfaces.ICommand;
	import grassland.ui.events.ContextMenuItemEvent;
	import grassland.ui.utils.DeclarativeMenu;
	import grassland.ui.utils.contact.ContactListItem;
	

	public class ContextMenuManager extends EventDispatcher {
		private static var _instance:ContextMenuManager;
		
		private var _contextMenu:DeclarativeMenu;
		private var _mouseTarget:InteractiveObject;
		
		public function ContextMenuManager(singlentonEnforcer:SingletonEnforcer) {
			init();
		}
		
		//singleton mode
		public static function getInstance():ContextMenuManager {
			if(ContextMenuManager._instance == null){
				ContextMenuManager._instance = new ContextMenuManager(new SingletonEnforcer());
			}
			return ContextMenuManager._instance;
		}
		
		public function get menu():NativeMenu{
			return _contextMenu;
		}
		
		private function init():void {
			var data:XML = <list/>
			_contextMenu = new DeclarativeMenu(data);
			_contextMenu.addEventListener(ContextMenuItemEvent.SELECT,onMenuSelected);
			_contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,onMenuShow);
		}
		
		public function load(data:XML):void {
			_contextMenu = new DeclarativeMenu(data);
			//_contextMenu.addEventListener(ContextMenuItemEvent.SELECT,onMenuSelected);
			_contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,onMenuShow);
		}
		
		private function onMenuShow(e:ContextMenuEvent):void {
			_mouseTarget = e.mouseTarget;
		}
		
		private function onMenuSelected(e:ContextMenuItemEvent):void {
			//dispatchEvent(new ContextMenuManagerEvent(_mouseTarget, e.data));
			var cmd:ICommand = e.data.command;
			cmd.setArgs(_mouseTarget,e.data.arg);
			cmd.exec();
		}
		
		public function get mouseTarget():InteractiveObject {
			return _mouseTarget;
		}
	}
}
class SingletonEnforcer {}