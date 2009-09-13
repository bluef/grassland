package grassland.ui.base {
	import flash.events.MouseEvent;
	import flash.events.NativeWindowBoundsEvent;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowType;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowResize;
	import flash.net.URLRequest;
	import flash.filters.GlowFilter;
	import grassland.ui.utils.LabelText;
	import grassland.ui.utils.DragBar;
	
	public class BasicWindow extends NativeWindow {
		private static var _headerBitmap:HeaderPNG;
		private var _minW:uint;
		private var _minH:uint;
		private var _closeBtn:CloseBtn;
		private var _minBtn:MinBtn;
		private var _bar:DragBar;
		protected var _panel:Sprite;
		private var _bg:Sprite;
		private var _resizeBlock:Sprite;
		private var _header:Sprite;
		private var _title:LabelText;
		
		public function BasicWindow(w:uint, h:uint, resize:Boolean = true, minW:uint = 0, minH:uint = 0) {
			var options:NativeWindowInitOptions = new NativeWindowInitOptions();
			options.type = NativeWindowType.NORMAL;
			options.resizable = resize;
			options.maximizable = false;
			options.systemChrome = NativeWindowSystemChrome.NONE;
			options.transparent = true;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.stageFocusRect = false;
			super(options);
			width = w;
			height = h;
			_minW = minW;
			_minH = minH;
			drawFramework();
			configureListener();
		}
		
		private function drawFramework():void {
			if(_headerBitmap == null) {
				_headerBitmap = new HeaderPNG(280, 85);
			}
			
			_header = new Sprite();
			with(_header.graphics) {
				lineStyle(0);
				//beginFill(0xFFFFFF);
				beginBitmapFill(_headerBitmap, null, false);
				//drawRoundRect(0, 0, _w-2, 85, 15, 15);
				moveTo(0,  85);
				lineTo(0,  11);
				curveTo(0,  0,  11,  0);
				lineTo(width - 11,  0);
				curveTo(width,  0,  width,  11);
				lineTo(width,  85);
				lineTo(0,  85);
				endFill();
			}
			stage.addChildAt(_header, 0);
			
			_title = new LabelText("", 200, false, 0x666666);
			//_title.color = 0x666666;
			_title.x = 15;
			_title.y = 3;
			stage.addChild(_title);
			
			_bar = new DragBar(width, 30);
			stage.addChild(_bar);
			
			_closeBtn = new CloseBtn();
			_closeBtn.x = width - _closeBtn.width - 18;
			_closeBtn.y = 8;
			stage.addChild(_closeBtn);
			
			_minBtn = new MinBtn();
			_minBtn.x = width - _closeBtn.width - _minBtn.width - 28;
			_minBtn.y = 8;
			stage.addChild(_minBtn);
			
			_bg = new Sprite();
			_bg.graphics.lineStyle(1);
			_bg.graphics.beginFill(0xFFFFFF);
			_bg.graphics.drawRoundRect(0, 0, width - 1, height - 2, 15, 15);
			_bg.graphics.endFill();
			stage.addChildAt(_bg, 0);
			
			//var filter:GlowFilter = new GlowFilter(0x99ccee, 0.6, 10, 10, 2, 1, false);
			
			_panel = new Sprite();
			_panel.y = 85;
			//_panel.x = 10;
			//_panel.filters = [filter];
			_bg.addChild(_panel);
			
			if(this.resizable){
				_resizeBlock = new Sprite();
				with(_resizeBlock.graphics) {
					lineStyle(0, 0xefefef);
					beginFill(0x99ccee);
					moveTo(13, 0);
					lineTo(13, 4);
					curveTo(12, 12, 4, 13);
					lineTo(0, 13);
					lineTo(13, 0);
					endFill();
				}
				
				_resizeBlock.x = width - 15.5;
				_resizeBlock.y = height - 15.5;
				stage.addChild(_resizeBlock);
				_resizeBlock.addEventListener(MouseEvent.MOUSE_DOWN, resizeWin);
			}
		}
		
		private function configureListener():void {
			_closeBtn.addEventListener(MouseEvent.CLICK, closeWin);
			_minBtn.addEventListener(MouseEvent.CLICK, minWin);
			_bar.addEventListener(MouseEvent.MOUSE_DOWN, dragWin);
			this.addEventListener(NativeWindowBoundsEvent.RESIZING, onResizeWin);
		}
		
		public override function set title(s:String):void {
			super.title = s;
			_title.text = s;
		}
		
		protected function closeWin(e:MouseEvent):void {
			this.stage.nativeWindow.close();
		}
		
		private function minWin(e:MouseEvent):void {
			this.stage.nativeWindow.minimize();
		}
		
		private function dragWin(e:MouseEvent):void {
			this.stage.nativeWindow.startMove();
		}
		
		private function resizeWin(e:MouseEvent):void {
			this.stage.nativeWindow.startResize(NativeWindowResize.BOTTOM_RIGHT);
		}
		
		private function onResizeWin(e:NativeWindowBoundsEvent):void {
			if(!this.resizable) {
				return;
			}
			
			if(e.afterBounds.width < _minW || e.afterBounds.height < _minH) {
				e.preventDefault();
				return;
			}
			
			_bg.graphics.clear();
			_bg.graphics.lineStyle(1);
			_bg.graphics.beginFill(0xFFFFFF);
			_bg.graphics.drawRoundRect(0, 0, width - 2, height - 2, 15, 15);
			_bg.graphics.endFill();
			
			with(_header.graphics) {
				clear();
				lineStyle(0);
				beginBitmapFill(_headerBitmap, null, false);
				moveTo(0,  85);
				lineTo(0,  11);
				curveTo(0,  0,  11,  0);
				lineTo(width - 11,  0);
				curveTo(width,  0,  width,  11);
				lineTo(width,  85);
				lineTo(0,  85);
				endFill();
			}
			
			_bar.width = width
			_closeBtn.x = width - _closeBtn.width - 18;
			_minBtn.x = width - _closeBtn.width - _minBtn.width - 28;
			_resizeBlock.x = width - 15.5;
			_resizeBlock.y = height - 15.5;
			
			//trace(e);
		}
		
	}
}