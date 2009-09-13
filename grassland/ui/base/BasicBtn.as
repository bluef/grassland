package grassland.ui.base {
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.events.MouseEvent;
	public class BasicBtn extends Sprite {
		public static var hoverStyle:ColorTransform;
		public static var upStyle:ColorTransform;
		protected var _bg:Sprite;
		protected var _w:uint;
		protected var _h:uint;
		protected var _hovered:Boolean;
		public function BasicBtn(w:uint,h:uint,upcolor:Number = 0xFFFFFF,hovercolor:Number = 0xEDFCFF){
			if(upStyle == null){
				upStyle = setUpStyle(upcolor);
			}
			
			if(hoverStyle == null){
				hoverStyle = setHoverStyle(hovercolor);
			}
			
			_w = w;
			_h = h;
			_hovered = false;
			
			drawBG();
			addEventListener(MouseEvent.MOUSE_OVER,onHover);
			addEventListener(MouseEvent.MOUSE_OUT,onOut);
		}
		
		protected function drawBG():void{
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
		
		protected function onHover(e:MouseEvent):void{
			if(!_hovered){
				_bg.transform.colorTransform = hoverStyle;
				_hovered = true;
			}
		}
		
		protected function onOut(e:MouseEvent):void{
			if(_hovered){
          		_bg.transform.colorTransform = upStyle;
          		_hovered = false;
			}
		}
		
		protected function setHoverStyle(color:Number):ColorTransform{
			var i:ColorTransform = new ColorTransform();
			i.color = color;
			//i.alphaOffset = 60;
			return i;
		}
		
		protected function setUpStyle(color:Number):ColorTransform{
			var i:ColorTransform = new ColorTransform();
			i.color = color;
			return i;
		}
	}
}