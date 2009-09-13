package grassland.test {
	import flash.display.Sprite;
	import grassland.ui.windows.MainWindow;
	import grassland.core.commands.*;
	
	public class MainWindowTest extends Sprite {
		private var _w:MainWindow;
		public function MainWindowTest(){
			_w = new MainWindow();
			_w.activate();
		}
	}
}