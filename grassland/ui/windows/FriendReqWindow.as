package grassland.ui.windows {
	import grassland.ui.base.BasicWindow;
	
	public class FriendReqWindow extends BasicWindow {
		private var _acceptBtn:CmdBtn;
		private var _ignoreBtn:CmdBtn;
		private var _avatar:Bitmap;
		private var _jid:JID;
		private var _txt:LabelText;
		public function FriendReqWindow(jid:JID){
			super(300,100);
			_jid = jid.clone();
			title = "处理好友请求";
			
			_avatar = new Bitmap();
			stage.addChild(_avatar);
			
			_acceptBtn = new CmdBtn("接受",60,30);
			_acceptBtn.x = 30;
			_acceptBtn.y = 60;
			stage.addChild(_acceptBtn);
			
			_ignoreBtn = new CmdBtn("忽略",60,30);
			_ignoreBtn.x = 80;
			_ignoreBtn.y = 60;
			stage.addChild(_ignoreBtn);
			
			_txt = new LabelText();
			_txt.text = _jid.valueOf()+"希望成为你的好友,你决定";
			stage.addChild(_txt);
		}
	}
}