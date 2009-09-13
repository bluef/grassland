package grassland.ui.windows {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowType;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.StageScaleMode;
	import grassland.core.utils.JID;
	import grassland.ui.events.NotifyEvent;
	import grassland.ui.managers.NotifyManager;
	
	public class Notify extends NativeWindow {
		public static const TYPE_MSG:String = "type_msg";
		public static const TYPE_SHOW:String = "type_show";
		
		private var _manager:NotifyManager;
		private var _wid:String;
		private var _from:JID;
		private var _type:String;
		private var _msgText:TextField;
		
		private var _life:uint = 5;
		
		public function Notify(wid:String,from:JID,ptype:String,t:String,manager:NotifyManager){
			var options:NativeWindowInitOptions = new NativeWindowInitOptions();
			options.type = NativeWindowType.LIGHTWEIGHT;
			options.systemChrome = NativeWindowSystemChrome.NONE;
			options.transparent = true;
			super(options);
			
			_manager = manager;
			
			_type = ptype;
			_wid = wid;
			_from = from;
			_msgText = new TextField();
			_msgText.x = 3;
			_msgText.y = 3;
			switch(_type){
				case TYPE_MSG:
					_msgText.text = _from.node+" says\n"+t;
					break;
				case TYPE_SHOW:
					_msgText.text = _from.node+" is "+t+" right now.";
					break;
			}
			stage.addChild(_msgText);
			
			alwaysInFront = true;
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN,onClick);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_manager.addEventListener(NotifyManager.LIFE_TICK,onTick,false,0,true);
		}
		
		private function onClick(e:MouseEvent):void{
			var ee:NotifyEvent = new NotifyEvent(NotifyEvent.CLICK,_wid,_from,_type);
			dispatchEvent(ee);
		}
		
		private function onTick(e:Event):void{
			//trace(_life);
			_life--;
			if(_life < 1){
				_manager.removeEventListener(NotifyManager.LIFE_TICK,onTick);
				var ee:NotifyEvent = new NotifyEvent(NotifyEvent.TIMEUP,_wid,_from,_type);
				dispatchEvent(ee);
			}
		}
		
		public function animateY(endY:int):void{
			var dY:Number;
			var animate:Function = function(event:Event):void{
				dY = (endY - y)/4
				y += dY;
				if( y <= endY){
					y = endY;
					stage.removeEventListener(Event.ENTER_FRAME,animate);
				}
			}
			stage.addEventListener(Event.ENTER_FRAME,animate);
		}
	}
}