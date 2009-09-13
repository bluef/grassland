package grassland.test {
	import flash.display.Sprite;
	import grassland.ui.windows.MainWindow;
	public class MWtest extends Sprite {
		private var _w:MainWindow;
		public function MWtest(){
			trace("aaa");
			_w = new MainWindow();
			_w.activate();
		}
	}
}