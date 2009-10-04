package grassland.ui.windows {
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	import grassland.ui.base.BasicWindow;
	import grassland.ui.utils.LabelText;
	
	import grassland.ui.interfaces.IUtilWindow;
	
	public class AlertWindow extends BasicWindow implements IUtilWindow {
		private var _msg:LabelText;
		private var _id:String = "grassland.ui.windows::AlertWindow";
		
		public function AlertWindow():void {
			super(380, 220, false);
			title = "Alert";
			
			init();
		}
		
		private function init():void {			
			_msg = new LabelText("", 290);
			_msg.height = 200;
			
			_msg.x = 40;
			_msg.y = 12;
			_panel.addChild(_msg);
		}
		
		public function appendMsg(value:String):void {
			_msg.appendText(value + "\n");
		};
		
		public function get id():String {
			return _id;
		};
		
		override protected function closeWin(e:MouseEvent):void {
			dispatchEvent(new Event(Event.CLOSING)); //Event.CLOSING
		}
	}
}