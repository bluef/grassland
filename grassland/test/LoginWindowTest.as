package grassland.test {
	import flash.display.Sprite;
	import grassland.ui.windows.LoginWindow;
	public class LoginWindowTest extends Sprite {
		private var _w:LoginWindow;
		public function LoginWindowTest(){
			_w = new LoginWindow();
			_w.activate();
		}
	}
}