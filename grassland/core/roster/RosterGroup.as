package grassland.core.roster {
	import grassland.core.roster.RosterItem;
	import grassland.core.utils.JID;
	import grassland.core.interfaces.ISorter;
	
	public class RosterGroup {
		private var _name:String;
		private var _itemArr:Vector.<RosterItem>;
		private var _onlineCount:uint;
		
		public function RosterGroup(n:String) {
			_itemArr = new Vector.<RosterItem>();
			_name = n;
		}
		
		public function addItem(s:RosterItem):void {
			_itemArr.push(s.clone());
		}
		
		public function addItemLink(s:RosterItem):void {
			_itemArr.push(s);
		}
		
		public function removeItem(s:RosterItem):RosterItem {
			var pos:uint = getRosterItemPosByJID(s.uid);
			return _itemArr.splice(pos,1)[0];
		}
		
		public function removeItemAt(pos:uint):RosterItem {
			return _itemArr.splice(pos,1)[0];
		}
		
		public function get length():uint {
			return _itemArr.length;
		}
		
		public function get onlineLength():uint {
			return _onlineCount;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function set name(s:String):void {
			_name = s;
		}
		
		public function getRosterItemPosByJID(j:JID):uint {
			var l:int = _itemArr.length;
			for (var i:int = 0; i < l; ++i) {
				if (JID(_itemArr[i].uid).toString() == JID(j).toString()) {
					break;
				}
			}
			return i;
		}
		
		public function getRosterItemAt(pos:int):RosterItem {
			return _itemArr[pos];
		}
		
		//return roster item by a specified JID
		public function getRosterItemByJID(j:JID):RosterItem {			
			_rosterJIDForSearch = j;
			
			var filterItems:Vector.<RosterItem> = _itemArr.filter(searchRosterItemObjByName, null);
			if (filterItems.length == 0) {
				return null;
			} else {
				return filterItems[0];
			}
		}
		
		private var _rosterJIDForSearch:JID;
		
		private function searchRosterItemObjByName(item:RosterItem, index:int, vector:Vector.<RosterItem>):Boolean {
			return (JID(item.uid).toString() == JID(_rosterJIDForSearch).toString());
		}
		
		public function sort(sorter:ISorter):void {
			//sorter.sort(_itemArr);
			_itemArr.sort(sorter.sort);
		}
		
		public function countOnline():void {
			_onlineCount = 0;
			
			var filterItems:Vector.<RosterItem> = _itemArr.filter(searchFunc, null);
			
			_onlineCount = filterItems.length;
		}
		
		private function searchFunc(item:RosterItem, index:int, vector:Vector.<RosterItem>):Boolean {
			return (item.show != "offline");
		};
	}
}