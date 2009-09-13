package grassland.ui.windows {
	import flash.net.URLRequest;
	import flash.html.HTMLLoader;
	import grassland.ui.base.BaseWindow;
	public class HTMLWindow extends BasicWindow {
		private var _html:HTMLLoader;
		private var _url:String;
		
		public function HTMLWindow(url:String):void {
			_url = url;
			super(800,600);
			init();
		}
		
		private function init():void{
			_html = new HTMLLoader();
			_html.height = 600;
			_html.width = 800;
			stage.addChild(_html);
			_html.load(new URLRequest(_url));
		}
		
		public function load(url:String):void{
			_url = url;
			_html.load(new URLRequest(_url));
		}
		
	}
}