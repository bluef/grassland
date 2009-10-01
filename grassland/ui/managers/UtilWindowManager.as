package grassland.ui.managers {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import grassland.ui.windows.AboutWindow;
	import grassland.ui.windows.DebugWindow;
	import grassland.ui.base.BasicWindow;
	import grassland.ui.events.UtilWindowType;
	import grassland.ui.events.UtilWinMgrEvent;
	import grassland.ui.events.UtilWinEvent;
	
	import grassland.ui.interfaces.IUtilWindow;
	
	import grassland.xmpp.events.XMPPEvent;
	
	
	public class UtilWindowManager extends EventDispatcher {
		
		private static var _instance:UtilWindowManager;
		
		private var _winArr:Dictionary;
		
		private var _debug:Boolean = false;
		
		public function UtilWindowManager(singlentonEnforcer:SingletonEnforcer) {
			_winArr = new Dictionary();
		}
		
		public static function getInstance():UtilWindowManager {
			if (UtilWindowManager._instance == null) {
				UtilWindowManager._instance = new UtilWindowManager(new SingletonEnforcer());
			}
			return UtilWindowManager._instance;
		}
		
		public function forwardData(type:String, data:Object):void {
			switch (type) {
				case XMPPEvent.RAW :
					if (_debug && _winArr[UtilWindowType.DEBUG] != null) {
						_winArr[UtilWindowType.DEBUG].log(String(data));
					}
					break;
			}
		};
		
		public function newWindow(type:String):void {
			if (_winArr[type] != null) {
				BasicWindow(_winArr[type]).activate();
			} else {
				var win:BasicWindow;
				switch (type) {
					case UtilWindowType.ABOUT :
						win = new AboutWindow();
						_debug = true;
						break;
						
					case UtilWindowType.DEBUG :
						win = new DebugWindow();
						break;
				}
				
				_winArr[type] = win;
				win.addEventListener(Event.CLOSING, onWinClosing);
				win.addEventListener(UtilWinEvent.DATA, onWinData);
				win.activate();
			}
		}
		
		private function onWinClosing(e:Event):void {
			e.preventDefault();
			
			if (_winArr[IUtilWindow(e.target).id] != null) {
				_winArr[IUtilWindow(e.target).id].removeEventListener(Event.CLOSING, onWinClosing);
				_winArr[IUtilWindow(e.target).id].removeEventListener(UtilWinEvent.DATA, onWinData);
				BasicWindow(_winArr[IUtilWindow(e.target).id]).close();
				delete _winArr[IUtilWindow(e.target).id];
			}
		}
		
		private function onWinData(e:UtilWinEvent):void {
			switch ( e.data.type ) {
				case 'debug_raw_input' :
					dispatchEvent(new UtilWinMgrEvent(UtilWinMgrEvent.DEBUG_RAW_INPUT, e.data.data)); //RAW_INPUT_DATA
					break;
			}
		};
	}
}
class SingletonEnforcer {}