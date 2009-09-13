package grassland.ui.utils.contact {
	import flash.display.Sprite;
	public class GroupIcon extends Sprite {
		private var _folded:Boolean;
		public function GroupIcon(){
			_folded = true;
			with(this.graphics){
				lineStyle(0,0x333333,0);
				beginFill(0x333333);
				moveTo(-3,-4);
				lineTo(4,0);
				lineTo(-3,4);
				lineTo(-3,-4);
				endFill();
			}
		}
		
		public function set fold(s:Boolean):void{
			if(s){
				if(!_folded){
					this.rotation = 0;
					_folded = true;
				}
			}else{
				if(_folded){
					this.rotation = 90;
					_folded = false;
				}
			}
		}
	}
}