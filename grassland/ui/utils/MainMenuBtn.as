package grassland.ui.utils {
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.geom.ColorTransform;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import grassland.ui.utils.LabelText;
	
	public class MainMenuBtn extends Sprite {
		private static var hoverStyle:ColorTransform;
		private static var upStyle:ColorTransform;
		private var _bg:Sprite;
		private var _label:LabelText;
		private var _icon:Loader;
		private var _iconRequest:URLRequest;
		private var _hovered:Boolean;
		public function MainMenuBtn(){
			if(upStyle == null){
				upStyle = setUpStyle(0xf4f4f4);
			}
			
			if(hoverStyle == null){
				hoverStyle = setHoverStyle(0xEDFCFF);
			}
			_hovered = false;

			
			drawBG();
			
			_bg.transform.colorTransform = upStyle;
			
			addEventListener(MouseEvent.MOUSE_OVER,onHover);
			addEventListener(MouseEvent.MOUSE_OUT,onOut);
			useHandCursor = true;
			buttonMode = true;
			
		}
		
		private function drawBG():void{
			_iconRequest = new URLRequest("images/mainMenu.png");
			_icon = new Loader();
			_icon.load(_iconRequest);
			_icon.mouseEnabled = false;
			_icon.x = 5;
			_icon.y = 5;
			addChild(_icon);
			
			_bg = new Sprite();
			with(_bg.graphics){
				lineStyle(0,0xFFFFFF);
				beginFill(0xEDFCFF);
				drawRoundRect(0,0,20,20,6,6);
				endFill();
			}
			addChildAt(_bg,0);
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
	}
}