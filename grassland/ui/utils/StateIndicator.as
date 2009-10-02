package grassland.ui.utils {
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class StateIndicator extends Sprite {
		private var s1:Shape;
		private var s2:Shape;
		private var s3:Shape;
		private var s4:Shape;
		private var s:Sprite;
		private var m:Shape;
		
		public function StateIndicator() {
			init();
		}
		
		private function init():void {
			s = new Sprite();
			m = new Shape();
			m.graphics.lineStyle(0, 0, 0);
			m.graphics.beginFill(0x26a908);
			m.graphics.drawRect(0, 0, 6, 6);
			m.graphics.endFill();
			addChild(m);
			s.mask = m;
			s.x = 0
			s.y = 0;
			m.x = -3;
			m.y = -3;
			
			
			s1 = new Shape();
			s1.graphics.lineStyle(0, 0, 0);
			s1.graphics.beginFill(0x26a908);
			s1.graphics.drawCircle(0, 0, 3);
			s1.graphics.endFill();
			s1.x = 0;
			s1.y = 0;
			s.addChild(s1);
			
			s2 = new Shape();
			s2.graphics.lineStyle(0, 0, 0);
			s2.graphics.beginFill(0xe65c46);
			s2.graphics.drawCircle(0, 0, 3);
			s2.graphics.endFill();
			s2.x = 6;
			s2.y = 0;
			s.addChild(s2);
			
			s3 = new Shape();
			s3.graphics.lineStyle(0, 0, 0);
			s3.graphics.beginFill(0xff8600);
			s3.graphics.drawCircle(0, 0, 3);
			s3.graphics.endFill();
			s3.x = 12;
			s3.y = 0;
			s.addChild(s3);
			
			s4 = new Shape();
			s4.graphics.lineStyle(0, 0, 0);
			s4.graphics.beginFill(0x9c9c9c);
			s4.graphics.drawCircle(0, 0, 3);
			s4.graphics.endFill();
			s4.x = 18;
			s4.y = 0;
			s.addChild(s4);
			
			addChild(s);
		};
		
		public function set mode(ss:String):void {
			switch (ss) {
				case "online":
					s.x = 0;
					break
					
				case "dnd":
					s.x = -6;
					break;
					
				case "away":
					s.x = -12;
					break;
					
				case "offline":
					s.x = -18;
					break;
			}
		}
	}
}