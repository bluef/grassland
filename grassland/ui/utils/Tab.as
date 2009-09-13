package grassland.ui.utils {
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.geom.ColorTransform;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	//import flash.geom.Point;
	//import grassland.ui.utils.Tooltips;
	import grassland.ui.utils.TabGroup;
	
	public class Tab extends Sprite {
		private var _group:TabGroup;
		private var _triggled:Boolean;
		
		private static var hoverStyle:ColorTransform;
		private static var upStyle:ColorTransform;
		private static var triggledStyle:ColorTransform;
		private var _bg:Sprite;
		private var _icon:Loader;
		private var _iconRequest:URLRequest;
		private var _tips:String;
		private var _hovered:Boolean;
		private var _data:Object;
		
		public function Tab(url):void {
			_iconRequest = new URLRequest(url);
			init();
		}
		
		private function init():void {
			_triggled = false;
			
			if(upStyle == null) {
				upStyle = setUpStyle(0xf4f4f4);
			}
			
			if(hoverStyle == null) {
				hoverStyle = setHoverStyle(0xEDFCFF);
			}
			
			if(triggledStyle == null) {
				triggledStyle = setTriggledStyle(0xEDFCFF);
			}
			
			_tips = tips;
			
			_hovered = false;
			
			drawBG();
			
			_bg.transform.colorTransform = upStyle;
			
			addEventListener(MouseEvent.MOUSE_OVER,onHover);
			addEventListener(MouseEvent.MOUSE_OUT,onOut);
			addEventListener(MouseEvent.MOUSE_OVER,onShowTips);
			addEventListener(MouseEvent.MOUSE_OUT,onHideTips);
			addEventListener(MouseEvent.CLICK,onClick);
			useHandCursor = true;
			buttonMode = true;
		}
		
		public function set group(s:TabGroup):void  {
			_group = s;
		}
		
		public function get group():TabGroup {
			return _group;
		}
		
		public function set data(s:Object):void {
			_data = s;
		}
		
		public function get data():Object {
			return _data;
		}
		
		public function set triggled(s:Boolean):void {
			_triggled = s;
			if(_triggled){
				_bg.transform.colorTransform = triggledStyle;
			}else{
				_bg.transform.colorTransform = upStyle;
			}
		}
		
		public function get triggled():Boolean {
			return _triggled;
			
		}
		
		private function drawBG():void {
			
			_icon = new Loader();
			_icon.load(_iconRequest);
			_icon.mouseEnabled = false;
			_icon.x = 5;
			_icon.y = 2;
			addChild(_icon);
			
			_bg = new Sprite();
			with(_bg.graphics) {
				lineStyle(0,0xFFFFFF);
				beginFill(0xEDFCFF);
				drawRoundRect(0,0,32,28,6,6);
				endFill();
			}
			addChildAt(_bg,0);
		}
		
		private function onHover(e:MouseEvent):void {
			if(!_hovered) {
				_bg.transform.colorTransform = hoverStyle;
				_hovered = true;
			}
		}
		
		private function onOut(e:MouseEvent):void {
			if(_hovered) {
          		_bg.transform.colorTransform = upStyle;
          		_hovered = false;
			}
		}
		
		private function onShowTips(e:MouseEvent):void {
			//Tooltips.getInstance().show(_tips,new Point(e.stageX,e.stageY));
		}
		
		private function onHideTips(e:MouseEvent):void {
			//Tooltips.getInstance().hide();
		}
		
		private function onClick(e:MouseEvent):void {
			if(_group != null){
				_group.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true));
				_group.setThis(e.target);
			}else{
				return;
			}
		}
		
		private function setTriggledStyle(color:Number):ColorTransform {
			var i:ColorTransform = new ColorTransform();
			i.color = color;
			//i.alphaOffset = 60;
			return i;
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
		
		public function get tips():String {
			return _tips;
		}
	}
}