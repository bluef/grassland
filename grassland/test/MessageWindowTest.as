package grassland.test {
	import flash.display.Sprite;
	import grassland.ui.windows.MessageWindow;
	import grassland.ui.managers.MsgWindowConfig;
	import grassland.core.utils.JID;
	import grassland.core.roster.RosterItem;
	
	public class MessageWindowTest extends Sprite {
		private var _w:MessageWindow;
		public function MessageWindowTest(){
			trace("aaa");
			var jid:JID = new JID("a@a.com/nut");
			var config:MsgWindowConfig = new MsgWindowConfig(new RosterItem(jid));
			_w = new MessageWindow(config);
			_w.activate();
		}
	}
}