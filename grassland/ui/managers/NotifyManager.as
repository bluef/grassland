package grassland.ui.managers {
	import flash.display.NativeWindow;
	import flash.desktop.NativeApplication;
	import flash.display.Screen;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import grassland.core.utils.JID;
	import grassland.xmpp.utils.RandomString;
	import grassland.ui.windows.Notify;
	import grassland.ui.events.NotifyEvent;
	import grassland.ui.events.NotifyManagerEvent;
	
	public class NotifyManager extends EventDispatcher {
		public static const LIFE_TICK:String = "life_tick";
		
		private static var _instance:NotifyManager;
		
		private var _winArr:Vector.<Notify>;
		private var _handleArr:Vector.<String>;
		private var currentScreen:Screen;
		private const timeToLive:uint = 10;
		private const gutter:int = 10;
		private var lifeTimer:Timer = new Timer(1000);
		
		public function NotifyManager(singlentonEnforcer:SingletonEnforcer){
			_winArr = new Vector.<Notify>();
			_handleArr = new Vector.<String>();
			lifeTimer.addEventListener(TimerEvent.TIMER, addTick);
			lifeTimer.start();
		}
		
		//singleton mode
		public static function getInstance():NotifyManager{
			if(NotifyManager._instance == null){
				NotifyManager._instance = new NotifyManager(new SingletonEnforcer());
			}
			return NotifyManager._instance;
		}
		
		//popup new notify windos
		public function newNotify(from:JID,type:String,t:String):void{
			var widd:String = RandomString.generateRandomString(4);
			while(_handleArr.indexOf(widd) != -1){
				widd = RandomString.generateRandomString(4);
			}
			_handleArr.push(widd);
			var win:Notify = new Notify(widd,from,type,t,_instance);
			_winArr.push(win);
			_winArr[_winArr.length-1].addEventListener(NotifyEvent.CLICK,onClick,false,0,true);
			_winArr[_winArr.length-1].addEventListener(NotifyEvent.TIMEUP,onTimeUp,false,0,true);
			
			var position:Point = findSpotForMessage(_winArr[_winArr.length-1].bounds);
			_winArr[_winArr.length-1].x = position.x;
			_winArr[_winArr.length-1].y = 0
			
			_winArr[_winArr.length-1].visible = true;
			_winArr[_winArr.length-1].animateY(position.y);
		}
		
		//close the notify window and tell the bus to open up a new msg window to show incoming msg or sth
		private function onClick(e:NotifyEvent):void{
			trace("clicked");
			var pos:int = _handleArr.indexOf(e.wid);
			_winArr[pos].removeEventListener(NotifyEvent.CLICK,onClick);
			_winArr[pos].removeEventListener(NotifyEvent.TIMEUP,onTimeUp);
			var winToClose:Notify = _winArr.splice(pos,1)[0];
			winToClose.close();
			_handleArr.splice(pos,1);
			var ee:NotifyManagerEvent = new NotifyManagerEvent(e.from,e.wtype);
			dispatchEvent(ee);
		}
		
		private function onTimeUp(e:NotifyEvent):void{
			var pos:int = _handleArr.indexOf(e.wid);
			_winArr[pos].removeEventListener(NotifyEvent.CLICK,onClick);
			_winArr[pos].removeEventListener(NotifyEvent.TIMEUP,onTimeUp);
			_winArr[pos].close();
			_winArr.splice(pos,1);
			_handleArr.splice(pos,1);
		}
		
		//close the notify win after 5 seconds' up,which is notify window's lifetime
		private function addTick(e:TimerEvent):void{
			dispatchEvent(new Event(LIFE_TICK,true));
		}
		
		//find the available position on the screen to show avoiding position composition
		private function findSpotForMessage(size:Rectangle):Point{
			var spot:Point = new Point();
			var done:Boolean = false;
			for each(var screen:Screen in Screen.screens){
				currentScreen = screen;
				//x-direction loop
				for(var x:int = screen.visibleBounds.x + screen.visibleBounds.width - size.width - gutter; 
						x >= screen.visibleBounds.x; 
						x -= (size.width + gutter)){
							//y-direction loop
					for(var y:int = screen.visibleBounds.y + screen.visibleBounds.height - size.height - gutter;
							y >= screen.visibleBounds.y;  
							y -= 10){
						var testRect:Rectangle = new Rectangle(x, y, size.width + gutter, size.height + gutter);
						if(!isOccupied(testRect)){
							spot.x = x;
							spot.y = y;
							done = true;
							break;
						}
					}
					if(done){break;}
				}
				if(done){break;}
			}
			return spot;
		}
		
		//Checks to see if any opened message windows are in a particular spot on screen
		private function isOccupied(testRect:Rectangle):Boolean{
			var occupied:Boolean = false;
			for each (var window:NativeWindow in NativeApplication.nativeApplication.openedWindows){
				occupied = occupied || window.bounds.intersects(testRect);
			}
			return occupied;
		}
		
	}
}
class SingletonEnforcer {}