package grassland.test {
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;
	import grassland.ui.windows.AboutWindow;
	public class AboutWindowTest extends Sprite {
		private var _w:AboutWindow;
		public function AboutWindowTest(){
			_w = new AboutWindow();
			_w.activate();
			trace(getQualifiedClassName(_w));
		}
	}
}