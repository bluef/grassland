package grassland.test {
	import grassland.xmpp.XMPPStream;
	import flash.display.Sprite;
	
	public class XMPPTest extends Sprite {
		public function XMPPTest(){
			XMPPStream.getInstance().init();
		}
	}
}