package grassland.ui.utils {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.geom.Point;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Tooltips extends Sprite {
		private static var _instance:Tooltips;
		
		private var _bg:Sprite;
		private var _text:TextField;
		private var _tf:TextFormat;
		
		private var lifeTimer:Timer = new Timer(2000);
		
		public function Tooltips(singlentonEnforcer:SingletonEnforcer):void{
			init();
		}
		
		public static function getInstance():Tooltips{
			if(Tooltips._instance == null){
				Tooltips._instance = new Tooltips(new SingletonEnforcer());
			}
			return Tooltips._instance;
		}
		
		private function init():void{
			
			this.visible = false;
			
			_bg = new Sprite();
			addChild(_bg);
			
			_tf = new TextFormat();
			_tf.font = "Arial";
			_tf.size = 12;
			
			_text = new TextField();
			_text.antiAliasType = AntiAliasType.ADVANCED;
			_text.defaultTextFormat = _tf;
			_text.autoSize = TextFieldAutoSize.LEFT;
			_text.x = 10;
			_text.y = 3;
			addChild(_text);
			
			lifeTimer.addEventListener(TimerEvent.TIMER, addTick);
			
		}
		
		public function show(s:String,pos:Point):void {
			var ltr:Boolean = true;
			_text.text = s;
			_bg.graphics.clear();
			with(_bg.graphics){
				lineStyle(1,0x000000);
				beginFill(0xFFFFFF,0.9);
				drawRect(0, 0, _text.width + 20, 26);
				endFill();
			}
			
			if ((this.x + this.width) >= this.stage.stageWidth - 10) {
				ltr = false;
			}
			if ( ltr ) {
				this.x = pos.x + 3;
			} else {
				this.x = this.stage.stageWidth - this.width - 10;
			}
			
			this.y = pos.y + 10;
			this.visible = true;
			lifeTimer.stop();
			lifeTimer.start();
		}
		
		public function hide():void{
			this.visible = false;
		}
		
		private function addTick(e:TimerEvent):void{
			hide();
		}
	}
}

class SingletonEnforcer {}