package grassland.ui.utils.contact {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.events.MouseEvent;
	import grassland.ui.utils.LabelText;
	import grassland.ui.utils.contact.GroupIcon;
	
	public class FoldCtrl extends Sprite {
		private var _text:String;
		// Save the width and height of the rectangle
		private var _width:Number;
		private var _height:Number;
		private var _label:LabelText;
		public static var hoverStyle:ColorTransform;
		public static var upStyle:ColorTransform;
		private var _bg:Sprite;
		private var _w:uint;
		private var _h:uint;
		private var _hovered:Boolean;
		private var _seprateLine:Shape;
		private var _icon:GroupIcon;

		public function FoldCtrl (label:String):void {
			if(upStyle == null){
				upStyle = setUpStyle(0xf4f4f4);
			}
			
			if(hoverStyle == null){
				hoverStyle = setHoverStyle(0xEDFCFF);
			}
			
			_w = 270;
			_h = 30;
			_hovered = false;
			
			drawBG();
			addEventListener(MouseEvent.MOUSE_OVER,onHover);
			addEventListener(MouseEvent.MOUSE_OUT,onOut);
			useHandCursor = true;
			buttonMode = true;
			_text = label;
			_width = 270;
			_height = 30;
			_label = new LabelText(_text,270);
			_label.x = 30;
			_label.y = (_height - _label.textHeight) / 2;
			_label.y -= 2;
			addChild(_label);
			
			_icon = new GroupIcon();
			_icon.x = 17;
			_icon.y = 12;
			addChild(_icon);
		}
		
		public function set label(s:String):void{
			_text = s;
			if(_text != null){
				_label.text = _text;
			}else{
				_label.text = '';
			}
		}
		
		public function get label():String{
			return _text;
		}
		
		private function drawBG():void{
			_seprateLine = new Shape();
			with(_seprateLine.graphics){
				lineStyle(0,0xe6e6e6);
				moveTo(0,_h-2);
				lineTo(_w,_h-2);
			}
			addChild(_seprateLine);
			_bg = new Sprite();
			with(_bg.graphics){
				lineStyle(0,0x999999,0);
				beginFill(upStyle.color);
					drawRect(0,0,_w,_h);
				endFill();
			}
			_bg.mouseEnabled = false;
			addChildAt(_bg, 0);
			hitArea = _bg;
		}
		
		private function onHover(e:MouseEvent):void{
			if(!_hovered){
				_bg.transform.colorTransform = hoverStyle;
				_hovered = true;
			}
		}
		
		private function onOut(e:MouseEvent):void{
			if(_hovered){
          		_bg.transform.colorTransform = upStyle;
          		_hovered = false;
			}
		}
		
		private function setHoverStyle(color:Number):ColorTransform{
			var i:ColorTransform = new ColorTransform();
			i.color = color;
			//i.alphaOffset = 60;
			return i;
		}
		
		private function setUpStyle(color:Number):ColorTransform{
			var i:ColorTransform = new ColorTransform();
			i.color = color;
			return i;
		}
		
		public function set fold(s:Boolean):void{
			if(s){
				_icon.fold = true;
			}else{
				_icon.fold = false;
			}
		}
	}
}