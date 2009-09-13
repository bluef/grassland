package grassland.ui.utils {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import grassland.ui.utils.LabelText;
	import grassland.ui.utils.StateIndicator;
	import grassland.ui.events.ProfileEvent;
	
	public class OwnProfile extends Sprite {
		private var _show:String;
		private var _status:String;
		private var _label:LabelText;
		private var _state:StateIndicator;
		private var _statusT:TextField;
		private var _avatar:Bitmap;
		public function OwnProfile(){
			_label = new LabelText();
			var t:TextFormat = new TextFormat();
			t.color = 0xFFFFFF;
			t.font = "微软雅黑";
			t.size = 14;
			t.bold = true;
			_label.defaultTextFormat = t;
			_label.width = 300;
			_label.x = 68;
			_label.y = 22;
			_label.text = "";
			addChild(_label);
			
			_statusT = new TextField();
			var t2:TextFormat = new TextFormat();
			t2.color = 0xFFFFFF;
			t2.font = "微软雅黑";
			t2.size = 12;
			t2.italic = true;
			_statusT.defaultTextFormat = t2;
			_statusT.width = 300;
			_statusT.x = 68;
			_statusT.y = 40;
			addChild(_statusT);
			
			_state = new StateIndicator();
			_state.x = 60;
			_state.y = 33;
			_state.mode = "dnd";
			addChild(_state);
			
			_avatar = new Bitmap();
			_avatar.y = 10;
			addChild(_avatar);
		}
		
		public function set nick(s:String):void{
			_label.text = s;
		}
		
		public function set status(s:String):void{
			_statusT.text = s;
			var e:ProfileEvent = new ProfileEvent(_show,_status);
			dispatchEvent(e);
		}
		
		public function set show(s:String):void{
			_show = s;
			_state.mode = s;
		}
		
		public function set avatar(b:BitmapData):void{
			_avatar.bitmapData = b;
		}
	}
}