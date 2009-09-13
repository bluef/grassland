package grassland.ui.utils.contact {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import grassland.ui.events.ContactGroupEvent;
	import grassland.ui.events.ContactListEvent;
	import grassland.ui.utils.contact.ContactListItem;
	import grassland.ui.utils.contact.FoldCtrl;
	import grassland.ui.managers.ContextMenuManager;
	
	public class ContactGroup extends Sprite {
		public static const CTRL_H:uint = 30;
		private var _name:String;
		private var _label:String;
		private var _folded:Boolean;
		private var _foldCtrl:FoldCtrl;
		private var _msk:Sprite;
		private var _itemArr:Vector.<ContactListItem>;
		
		public function ContactGroup(n:String) {
			init(n);
		}
		
		private function init(n:String):void {
			_itemArr = new Vector.<ContactListItem>();
			_folded = false;
			_name = n;
			_label = n;
			_msk = new Sprite();
			_msk.mouseEnabled = false;
			with(_msk.graphics) {
				lineStyle(0);
				beginFill(0xff0000);
				drawRect(0,0,260,CTRL_H);
				endFill();
			}
			addChild(_msk);
			_foldCtrl = new FoldCtrl(_label);
			this.mask = _msk;
			_foldCtrl.addEventListener(MouseEvent.CLICK,onClick);
			addChild(_foldCtrl);
		}
		
		public function addItem():void {
			_itemArr.push(new ContactListItem());
			ContactListItem(_itemArr[_itemArr.length-1]).contextMenu = ContextMenuManager.getInstance().menu;
			ContactListItem(_itemArr[_itemArr.length-1]).y = (_itemArr.length-1)*ContactListItem.BTNH+CTRL_H;
			addChild(ContactListItem(_itemArr[_itemArr.length-1]));
			ContactListItem(_itemArr[_itemArr.length-1]).addEventListener(MouseEvent.CLICK,onItemClick,false,0,true);
		}
		
		/*
		public function addItem(s:ContactListItem):void {
			_itemArr.push(s.clone());
			_itemArr[_itemArr.length-1]).contextMenu = ContextMenuManager.getInstance().menu;
			ContactListItem(_itemArr[_itemArr.length-1]).y = (_itemArr.length-1)*ContactListItem.BTNH+CTRL_H;
			addChild(ContactListItem(_itemArr[_itemArr.length-1]));
			ContactListItem(_itemArr[_itemArr.length-1]).addEventListener(MouseEvent.CLICK,onItemClick);
		}*/
		
		public function removeItem():void {
			removeChild(ContactListItem(_itemArr.pop()));
		}
		
		public function onClick(e:MouseEvent):void {
			if(_folded) {
				dispatchEvent(new ContactGroupEvent(ContactGroupEvent.UNFOLD,_name));
				_folded = false;
			}else {
				dispatchEvent(new ContactGroupEvent(ContactGroupEvent.FOLD,_name));
				_folded = true;
			}
		}
		
		private function onItemClick(e:MouseEvent):void {
			//trace(e.target.index);
			var ee:ContactListEvent = new ContactListEvent(ContactListItem(e.target).index,_name);
			dispatchEvent(ee);
		}
		
		public function fold():void {
			_msk.height = CTRL_H;
			_folded = true;
			_foldCtrl.fold = true;
		}
		
		public function unfold():void {
			_msk.height = _itemArr.length*ContactListItem.BTNH+CTRL_H;
			_folded = false;
			_foldCtrl.fold = false;
		}
		
		public function set label(s:String):void {
			_label = s;
			_foldCtrl.label = s;
		}
		
		public function get label():String {
			return _label;
		}
		
		public function set gname(s:String):void {
			_name = s;
		}
		
		public function get gname():String {
			return _name;
		}
		
		public function get itemCount():int {
			return _itemArr.length;
		}
		
		public function getItemAt(s:int):ContactListItem {
			return ContactListItem(_itemArr[s]);
		}
	}
}