package grassland.ui.utils {
	import flash.display.Sprite;
	import flash.html.HTMLLoader;
	
	import grassland.ui.interfaces.IScrollable;
	
	public class WEBLoader extends Sprite implements IScrollable {
		private var _html:HTMLLoader;
		public function WEBLoader():void {
			_html = new HTMLLoader();
			_html.width = 270;
			_html.height = 410;
			addChild(_html);
		}
		
		public function load(url:String):void {
			_html.load(url);
		}
		
		public function scroll(scrollPosition:Number):void {
			scrollV = scrollPosition;
		}
	}
}