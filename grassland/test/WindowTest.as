package grassland.test {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	import grassland.ui.windows.SubscribeWindow;
	
	public class WindowTest extends Sprite {
		private var _w:SubscribeWindow;
		public function WindowTest(){
			_w = new SubscribeWindow();
			var data:Vector.<String> = new Vector.<String>();
			data.push("aaaaaaaaaaaa");
			data.push("bbbbbbbbbbbb");
			_w.groupsData = data;
			
			_w.activate();
			EventDispatcher(_w).addEventListener(Event.CLOSING, onWinClosing);
			trace(getQualifiedClassName(_w));
		}
		
		private function onWinClosing(e:Event):void {
			e.preventDefault();
			
			e.target.close();
		}
	}
}