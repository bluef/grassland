package grassland.ui.utils.contact {
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import grassland.ui.base.BasicBtn;
	import grassland.ui.utils.StateIndicator;
	import grassland.ui.utils.LabelText;
	
	public class ContactListItem extends Sprite {
		public static const FULL:String = "fullmode";
		public static const MINI:String = "minimode";
		public static const BTNH:int = 40;
		private static const LABELX:Number = 25;
		private static const LABELY:Number = 10;
		private static const STATUSX:Number = 25;
		private static const STATUSY:Number = 26;
		
		public static var hoverStyle:ColorTransform;
		public static var upStyle:ColorTransform;
		
		private var _w:uint;
		private var _h:uint;
		private var _index:int;
		private var _onlineMode:Boolean;
		private var _showtext:String;
		private var _statustext:String;
		private var _label:LabelText;
		private var _status:LabelText;
		private var _show:StateIndicator;
		private var _avatar:Bitmap;
		private var _hoved:Boolean;
		private var _bg:Shape;
		private var _seprateLine:Shape;
		private var _hovered:Boolean;
		
		
		public function ContactListItem(index:uint = 0, label:String = '', show:String = '', status:String = '') {
			init();
			
			_showtext = show;
			_index = index;
			
			_label.text = label;
			
			if (status != null) {
				_status.text = status;
			} else {
				_status.text = '';
			}
			
			_show.mode = show;
		}
		
		private function init():void {
			if (upStyle == null) {
				upStyle = setUpStyle(0xFFFFFF);
			}
			
			if (hoverStyle == null) {
				hoverStyle = setHoverStyle(0xEDFCFF);
			}
			
			_hovered = false;
			
			addEventListener(MouseEvent.MOUSE_OVER,onHover);
			addEventListener(MouseEvent.MOUSE_OUT,onOut);
			
			useHandCursor = true;
			buttonMode = true;
			
			_label = new LabelText('', 200, true, 0x333333, false, 10);
			_label.bold = true;
			_label.size = 12;
			
			_status = new LabelText('', 50, false, 0x666666, false, 10);
			_status.size = 10;
			
			_show = new StateIndicator();
			_show.x = 16;
			_show.y = 12;
			
			_w = 270;			
			_h = BTNH;
			
			_label.x = 25;
			_label.y = 2;
			
			_status.x = 25;
			_status.y = 18;
			_status.width = 260;
			
			_avatar = new Bitmap();
			_avatar.x = 208;
			_avatar.y = 3;
			
			drawBG(_w,_h);
			
			addChild(_label);
			addChild(_status);
			addChild(_show);
			addChild(_avatar);
		};
		
		private function setFullLayout():void{
			_h = 65;
			
			if(_bg != null){
				_bg.height = _h;
			}
			
			_label.x = 25;
			_label.y = 10;
			
			_status.x = 25;
			_status.y = 26;
			_status.width = 260;
			
			_show.x = 16;
			_show.y = 20;
			
			_avatar.x = 208;
			_avatar.y = 10;
			
			if (_avatar == null) {
				_avatar = new Bitmap();
			}
			
			if (!contains(_avatar)) {
				addChild(_avatar);
			}
		}
		
		private function setMinLayout():void{
			_h = 35;
			
			if(_bg != null){
				_bg.height = _h;
			}
			
			_label.x = 15;
			_label.y = 10;
			
			_status.x = 20 + _label.width;
			_status.y = 10;
			_status.width = 260;
			
			_show.x = 16;
			_show.y = 20;
			
			if (contains(_avatar)) {
				removeChild(_avatar);
			}
		}
		
		private function drawBG(w:uint,h:uint):void{
			_seprateLine = new Shape();
			with (_seprateLine.graphics) {
				lineStyle(0,0xe6e6e6);
				moveTo(0,h-2);
				lineTo(w,h-2);
			}
			
			addChild(_seprateLine);
			_bg = new Shape();
			
			with (_bg.graphics) {
				lineStyle(0, 0xFFFFFF);
				beginFill(upStyle.color);
				drawRect(0, 0, w, h);
				endFill();
			}
			//_bg.mouseEnabled = false;
			addChildAt(_bg,0);
			//hitArea = _bg;
		}
		
		private function onHover(e:MouseEvent):void {
			if (!_hovered) {
				_bg.transform.colorTransform = hoverStyle;
				_hovered = true;
			}
		}
		
		private function onOut(e:MouseEvent):void {
			if (_hovered) {
          		_bg.transform.colorTransform = upStyle;
          		_hovered = false;
			}
		}
		
		private function setHoverStyle(color:Number):ColorTransform {
			var i:ColorTransform = new ColorTransform();
			i.color = color;
			//i.alphaOffset = 60;
			return i;
		}
		
		private function setUpStyle(color:Number):ColorTransform {
			var i:ColorTransform = new ColorTransform();
			i.color = color;
			return i;
		}

		// Create the text field to display the text of the button
		public function set labelText(s:String):void {
			_label.text = s;
		}
		
		public function set statusText(s:String):void {
			_statustext = s;
			if (_statustext == null || _statustext == '') {
				_status.text = _showtext;
			} else {
				_status.text = _statustext;
			}
		}
		
		public function set show(s:String):void {
			//trace("state:",s);
			_showtext = s;
			if (_statustext == null || _statustext == '') {
				_status.text = _showtext;
			} else {
				_status.text = _statustext;
			}
			_show.mode = s;
		}
		
		public function get index():int{
			return _index;
		}
		
		public function set index(i:int):void {
			_index = i;
		}
		
		public override function get height():Number {
			return _h;
		}
		
		public function set avatar(a:BitmapData):void {
			_avatar.bitmapData = a;
		}
		
		public function get avatar():BitmapData {
			return _avatar.bitmapData;
		}
		
		public function clone():ContactListItem {
			return new ContactListItem(_index, _label.text, _showtext, _statustext);
		}
		
	}
}