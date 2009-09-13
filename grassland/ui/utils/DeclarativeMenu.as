package grassland.ui.utils {
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import grassland.ui.events.ContextMenuItemEvent;
	import grassland.core.commands.*;
	
	public class DeclarativeMenu extends NativeMenu {
		
		public function DeclarativeMenu(XMLMenuDefinition:XML):void {
			super();
			addChildrenToMenu(this, XMLMenuDefinition.children());
		}
		
		private function addChildrenToMenu(menu:NativeMenu,children:XMLList):NativeMenuItem {
			var menuItem:NativeMenuItem;
			var submenu:NativeMenu;
			for each (var child:XML in children) {
				menuItem = new NativeMenuItem(child.@label);
				/*var cmdClass:Class = getDefinitionByName("grassland.core.commands."+child.@cmd) as Class;
				*/
				var o:Object = new Object();
				//o.command = new cmdClass();
				//o.arg = child.@label;
				menuItem.data = o;
				if (child.@event != null && child.@event != '' ){
					NativeMenuItem(menu.addItem(menuItem)).addEventListener(Event.SELECT,onItemSelected);
				}
				
				if (child.children().length() > 0) {
					menuItem.submenu = new NativeMenu();
					addChildrenToMenu(menuItem.submenu,child.children());
				}
			}
			return menuItem;
		}
		
		private function onItemSelected(e:Event):void {
			dispatchEvent(new ContextMenuItemEvent(e.target.data));
		}
	}
}