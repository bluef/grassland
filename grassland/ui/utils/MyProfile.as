package grassland.ui.utils {
	import flash.ui.Keyboard;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import grassland.ui.utils.LabelText;
	import grassland.ui.utils.StateIndicator;
	import grassland.ui.events.ProfileEvent;
	
	public class MyProfile extends Sprite {
		public static const INITED:String = "inited";
		public static const UPDATED:String = "updated";
		
		private var _show:String;
		private var _status:String;
		private var _label:LabelText;
		private var _state:StateIndicator;
		private var _statusT:TextField;
		private var _avatar:Bitmap;
		private var _menu:NativeMenu;
		public function MyProfile(){
			_show = 'online';
			_status = '';
			
			_menu = new NativeMenu();
			initStateMenu();
			
			_label = new LabelText('',300,true,0xFFFFFF,false,14);
			_label.x = 68;
			_label.y = 22;
			_label.text = "";
			addChild(_label);
			
			_statusT = new TextField();
			var t2:TextFormat = new TextFormat();
			t2.color = 0xFFFFFF;
			t2.font = "微软雅黑";
			t2.size = 12;
			t2.italic = true;
			_statusT.textColor = 0xFFFFFF;
			_statusT.defaultTextFormat = t2;
			_statusT.width = 150;
			_statusT.height = 20; 
			_statusT.multiline = false;
			_statusT.x = 68;
			_statusT.y = 40;
			_statusT.addEventListener(MouseEvent.CLICK,onStatusClicked);
			_statusT.addEventListener(KeyboardEvent.KEY_DOWN,onEnter);
			_statusT.addEventListener(FocusEvent.FOCUS_OUT,onFocusOut);
			
			addChild(_statusT);
			
			_state = new StateIndicator();
			_state.buttonMode = true;
			_state.useHandCursor = true;
			_state.x = 60;
			_state.y = 33;
			_state.mode = "online";
			_state.addEventListener(MouseEvent.CLICK,changeState);
			addChild(_state);
			
			_avatar = new Bitmap();
			_avatar.y = 10;
			addChild(_avatar);
			
			
		}
		
		private function initStateMenu():void{
			var arr:Array = ["Online","Busy","Away"];
			for(var i:uint = 0;i<arr.length;i++){
				var item:NativeMenuItem = _menu.addItem(new NativeMenuItem(arr[i]));
				item.addEventListener(Event.SELECT,onItemSelected);
			}
		}
		
		private function onItemSelected(e:Event):void{
			_show = e.target.label.toLowerCase();
			dispatchEvent(new Event(UPDATED,true));
		}
		
		private function onStatusClicked(e:MouseEvent):void{
			trace(e.target.type);
			if(e.target.type == TextFieldType.DYNAMIC){
				_statusT.textColor = 0x000000;
				_statusT.border = true;
				_statusT.background = true;
				_statusT.selectable = true;
				e.target.type = TextFieldType.INPUT;
			}
		}
		
		private function onEnter(e:KeyboardEvent):void{
			_status = _statusT.text;
			
			if(e.keyCode == Keyboard.ENTER){
				updateStatus();
				e.target.type = TextFieldType.DYNAMIC;
			}
		}
		
		private function onFocusOut(e:FocusEvent):void{
			updateStatus();
			e.target.type = TextFieldType.DYNAMIC;
		}
		
		private function updateStatus():void{
			_status = _statusT.text;
			_statusT.scrollH = 0;
			_statusT.textColor = 0xFFFFFF;
			_statusT.border = false;
			_statusT.background = false;
			_statusT.selectable = false;
			dispatchEvent(new Event(UPDATED,true));
		}
		
		public function set nick(s:String):void{
			_label.text = s;
		}
		
		public function set status(s:String):void{
			_status = s;
			if(s != null){
				_statusT.text = s;
			}else{
				_statusT.text = '';
			}
			//var e:ProfileEvent = new ProfileEvent(_show,_status);
			//dispatchEvent(e);
		}
		
		public function get status():String{
			return _status;
		}
		
		public function set show(s:String):void{
			if(s != null){
				_show = s;
				_state.mode = s;
			}
		}
		
		public function get show():String{
			return _show.toLowerCase();
		}
		
		public function set avatar(b:BitmapData):void{
			_avatar.bitmapData = b;
		}
		
		public function disposeAvatar():void{
			_avatar.bitmapData.dispose();
		}
		
		private function changeState(e:MouseEvent):void{
			trace("clicked");
			var p:Point = new Point(_state.x-4,_state.y+10);
			
			_menu.display(this.stage,this.localToGlobal(p).x,this.localToGlobal(p).y)
			//_menu.display(this.stage,80,80);
		}
	}
}