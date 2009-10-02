package grassland.ui.windows {
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import fl.events.ScrollEvent;
	
	import grassland.ui.base.BasicWindow;
	import grassland.ui.utils.DefaultTextFormat;
	import grassland.ui.utils.InputField;
	import grassland.ui.utils.ScrollBar;
	
	import grassland.ui.events.UtilWinEvent;
	
	import grassland.ui.interfaces.IUtilWindow;
	
	public class DebugWindow extends BasicWindow implements IUtilWindow {
		public static const RAW_INPUT:String = "debug_window_raw_input";
		private var _disArea:TextField;
		private var _inputArea:TextField;
		private var _scrollBar:ScrollBar;
		
		private var _id:String = "grassland.ui.windows::DebugWindow";
		
		private var txtFormat:DefaultTextFormat;
		
		public function DebugWindow():void {
			super(500, 460, false);
			title = "Debug";
			init();
		};
		
		private function init():void {
			txtFormat = new DefaultTextFormat();
			txtFormat.leftMargin = 5;
			txtFormat.rightMargin = 10;
			
			_disArea = new TextField();
			_disArea.multiline = true;
			_disArea.wordWrap = true;
			_disArea.defaultTextFormat = txtFormat;
			_disArea.width = width - 20;
			
			_disArea.height = 305;
			_disArea.x = 0;
			_disArea.y = 5;
			
			_panel.addChild(_disArea);
			
			_inputArea = new InputField(290, 20);
			_inputArea.wordWrap = true;
			_inputArea.defaultTextFormat = txtFormat;
			_inputArea.height = 50;
			_inputArea.width = width - 2;
			_inputArea.x = 0;
			_inputArea.y = height - 155;

			_panel.addChild(_inputArea);
			stage.focus = _inputArea;
			
			_scrollBar = new ScrollBar();
			_scrollBar.drawFocus(false);
			_scrollBar.x = width - 16;
			_scrollBar.y = 0;
			_scrollBar.height = height - 155;
			_scrollBar.pageScrollSize = 5;
			_scrollBar.addEventListener(ScrollEvent.SCROLL, onScroll);
			_panel.addChild(_scrollBar);
			
			configureListener();
		};
		
		public function get id():String {
			return _id;
		};
		
		private function configureListener():void {
			_scrollBar.addEventListener(ScrollEvent.SCROLL, onScroll);
			_inputArea.addEventListener(KeyboardEvent.KEY_DOWN, onEnter);
		};
		
		public function log(text:String):void {
			_disArea.appendText(text + "\n\n");
			
			_disArea.scrollV = _disArea.maxScrollV;
			_scrollBar.maxScrollPosition = _disArea.maxScrollV / 5;
			_scrollBar.scrollPosition = _scrollBar.maxScrollPosition;
		};
		
		override protected function closeWin(e:MouseEvent):void {
			dispatchEvent(new Event(Event.CLOSING)); //Event.CLOSING
			
		}
		
		private function onScroll(e:ScrollEvent):void {
			//_disArea.scrollV = e.target.scrollPosition;
			_disArea.scrollV = ScrollBar(e.target).scrollPosition * 5;
		}
		
		private function onEnter(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.ENTER) {
				dispatchEvent(new UtilWinEvent(UtilWinEvent.DATA, {type:"debug_raw_input", data:_inputArea.text}));
				_inputArea.text = '';
			}
		}
	}
}