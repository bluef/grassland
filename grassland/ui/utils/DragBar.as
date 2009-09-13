package grassland.ui.utils {
	import flash.display.Sprite;
	public class DragBar extends Sprite {
		public function DragBar(w:uint,h:uint,color:uint = 0x009CFE){
			super();
			this.graphics.lineStyle(0,0x000000,0);
			this.graphics.beginFill(color,0);
			this.graphics.drawRect(0, 0, w, h);
			this.graphics.endFill();
		}
	}
}