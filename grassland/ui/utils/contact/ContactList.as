package grassland.ui.utils.contact {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.display.Shape;
	
	import grassland.core.roster.RosterGroup;
	import grassland.core.roster.RosterItem;
	import grassland.core.utils.JID;
	import grassland.ui.interfaces.IScrollable;
	import grassland.ui.utils.contact.ContactListItem;
	import grassland.ui.utils.contact.ContactGroup;
	import grassland.ui.events.ContactListEvent;
	import grassland.ui.events.ContactGroupEvent;
	
	public class ContactList extends Sprite implements IScrollable {
		public static const UPDATED:String = "layout_updated";
		private var _groupArr:Vector.<ContactGroup>;
		private var _width:int = 270;
		private var _height:Number = 0;
		
		public function ContactList() {
			_groupArr = new Vector.<ContactGroup>();
		}
		
		private function onClick(e:ContactListEvent):void {
			var c:ContactListEvent = new ContactListEvent(e.index,e.group);
			dispatchEvent(c);
		}
		
		private function getGroupByName(s:String):int {
			var l:int = _groupArr.length;
			for (var i:int = 0;i<l;i++) {
				if (ContactGroup(_groupArr[i]).gname == s) {
					return i;
				}
			}
			return -1;
		}
		
		public function updateLayout(rosterGroup:RosterGroup):void {
			var l:int = rosterGroup.length;
			var i:int;
			var ll:int;
			var addRoster:Boolean = false;
			var contactItem:ContactListItem;
			var _groupPos:int = getGroupByName(rosterGroup.name);
			
			if (_groupPos != -1) {//if this contact group exist
				//if the number of items in roster group differ from the one in contact group
				while (l > ContactGroup(_groupArr[_groupPos]).itemCount) {
					addRoster = true;
					ContactGroup(_groupArr[_groupPos]).addItem();
				}
				
				while (l < ContactGroup(_groupArr[_groupPos]).itemCount)  {
					addRoster = true;
					ContactGroup(_groupArr[_groupPos]).removeItem();
				}
				
			} else {//if there's no such contact group here
				var newGroup:ContactGroup = new ContactGroup(rosterGroup.name);
				newGroup.fold();
				newGroup.addEventListener(ContactGroupEvent.FOLD, foldGroup, false, 0, true);
				newGroup.addEventListener(ContactGroupEvent.UNFOLD, unfoldGroup, false, 0, true);
				newGroup.addEventListener(ContactListEvent.ITEM_CLICKED, onClick, false, 0, true);
				_groupArr.push(newGroup);
				ContactGroup(_groupArr[_groupArr.length - 1]).y = ContactGroup.CTRL_H * (_groupArr.length - 1);
				while (l > ContactGroup(_groupArr[_groupArr.length - 1]).itemCount) {
					addRoster = true;
					ContactGroup(_groupArr[_groupArr.length - 1]).addItem();
				}
				
				while (l < ContactGroup(_groupArr[_groupArr.length - 1]).itemCount)  {
					addRoster = true;
					ContactGroup(_groupArr[_groupArr.length - 1]).removeItem();
				}
				
				_groupPos = _groupArr.length - 1;
				addChild(ContactGroup(_groupArr[_groupArr.length-1]));
			}
			
			
			if (addRoster) {
				//trace("contactlist:Add");
				dispatchEvent(new Event(UPDATED, true));
			}
			
			var tmpRosterItem:RosterItem;
			
			var foreachFunc:Function = function (item:ContactListItem, index:int, vector:Vector.<ContactListItem>):void {
				ContactListItem(item).index = index;
				
				tmpRosterItem = RosterGroup(rosterGroup).getRosterItemAt(index);
				
				if (tmpRosterItem.nick != null) {
					ContactListItem(item).labelText = tmpRosterItem.nick;
				} else {
					ContactListItem(item).labelText = JID(tmpRosterItem.uid).node;
				}
				
				ContactListItem(item).show = tmpRosterItem.show;
				ContactListItem(item).avatar = tmpRosterItem.avatar;
				ContactListItem(item).statusText = tmpRosterItem.status;
			};
			
			ContactGroup(_groupArr[_groupPos]).items.forEach(foreachFunc, null);
			
		}
		
		private function foldGroup(e:ContactGroupEvent):void {
			var pos:int = getGroupByName(e.data);
			var l:int = _groupArr.length;
			
			_height = 0;
			var i:int;
			
			for (i = pos + 1; i < l; ++i) {
				ContactGroup(_groupArr[i]).y -= (ContactGroup(_groupArr[pos]).itemCount * ContactListItem.BTNH);
				
			}
			
			ContactGroup(_groupArr[pos]).fold();
			
			_groupArr.forEach(countHeight);
			
			dispatchEvent(new Event(UPDATED, true));
		}
		
		private function unfoldGroup(e:ContactGroupEvent):void {
			var pos:int = getGroupByName(e.data);
			var l:int = _groupArr.length;
			
			_height = 0;
			ContactGroup(_groupArr[pos]).unfold();
			
			var i:int
			
			for (i = pos + 1; i < l; ++i) {
				ContactGroup(_groupArr[i]).y += (ContactGroup(_groupArr[pos]).itemCount*ContactListItem.BTNH);
			}
			
			_groupArr.forEach(countHeight);
			
			dispatchEvent(new Event(UPDATED, true));
		}
		
		public function scroll(scrollPosition:Number):void {
			this.y = 0 - scrollPosition;
		}
		
		public function get visualHeight():Number {
			return _height;
		};
		
		private function countHeight(item:ContactGroup, index:int, vector:Vector.<ContactGroup>):void {
			_height += item.visualHeight;
		};
	}
}