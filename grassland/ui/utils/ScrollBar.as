package grassland.ui.utils {
	import fl.events.ScrollEvent;
	import fl.controls.UIScrollBar;
	import grassland.ui.interfaces.IScrollable;
	import grassland.ui.interfaces.IResizable;
	
	public class ScrollBar extends UIScrollBar implements IResizable{
		private var _host:IScrollable;
		
		public function ScrollBar():void {
			super();
			this.addEventListener(ScrollEvent.SCROLL,onScroll);
		}
		
		public function set host(s:IScrollable):void {
			_host = s;
		}
		
		private function onScroll(e:ScrollEvent):void {
			if (_host == null) {
				return;
			}
			
			IScrollable(_host).scroll(e.target.scrollPosition);
		}
		
		public function resize(width:Number, height:Number):void {
			this.height = height;
		}
	}
}