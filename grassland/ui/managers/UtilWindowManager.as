package grassland.ui.managers {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	import grassland.ui.windows.AboutWindow;
	import grassland.ui.base.BasicWindow;
	
	public class UtilWindowManager extends EventDispatcher {
		public static const ABOUT:String = "grassland.ui.windows::AboutWindow";
		private static var _instance:UtilWindowManager;
		private var _winArr:Array;
		
		public function UtilWindowManager(singlentonEnforcer:SingletonEnforcer) {
			_windows = [];
		}
		
		public static function getInstance():UtilWindowManager {
			if(UtilWindowManager._instance == null){
				UtilWindowManager._instance = new UtilWindowManager(new SingletonEnforcer());
			}
			return UtilWindowManager._instance;
		}
		
		private function searchWin(type:String):void {
			var l:uint = _winArr.length;
			for(var i:uint = 0;i<l;i++){
				if(getQualifiedClassName(_winArr[i]) == type){
					return i;
				}
			}
			return -1;
		}
		
		public function newWindow(type:String):void {
			var pos:int = searchWin(type);
			if (pos != -1) {
				_winArr[pos].activate();
			}else{
				var win:BasicWindow;
				switch (type) {
					case ABOUT :
						win = new AboutWindow();
						_winArr.push(win);
						_winArr[_winArr.length - 1].addEventListener(Event.CLOSING, onWinClosing);
						_winArr[_winArr.length - 1].activate();
						break;
				}
			}
		}
		
		private function onWinClosing(e:Event):void {
			e.preventDefault();
			
			var pos:int = searchWin(getQualifiedClassName(e.target));
			if (pos != -1) {
				_winArr[pos].removeEventListener(Event.CLOSING, onWinClose);
				_winArr.splice(pos,1)[0].close();
			}
		}
	}
}
class SingletonEnforcer {}