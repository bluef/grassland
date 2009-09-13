package grassland.core.sorters {
	import grassland.core.interfaces.ISorter;
	import grassland.core.roster.RosterItem;
	
	public class StatusSorter implements ISorter {
		private var _order:Array;
		public function StatusSorter() {
			//create show state order array.online state should place in the top of contact list and offline comes last
			_order = ["online","dnd","away","offline"];
		}
		
		//sort roster item with mergeSort algorithm
		public function sort(x:RosterItem, y:RosterItem):int {
			var re:int = 0;
			if (_order.indexOf(RosterItem(x).show) > _order.indexOf(RosterItem(y).show)) {
				re = 1;
			}
			
			if (_order.indexOf(RosterItem(x).show) < _order.indexOf(RosterItem(y).show)) {
				re = -1;
			}
			
			if (_order.indexOf(RosterItem(x).show) == _order.indexOf(RosterItem(y).show)) {
				re = 0;
			}
			
			return re;
		};
		
		/*
		public function sort(arr:Vector.<RosterItem>):Vector.<RosterItem>{
			var i:int;
			var j:int;
			var k:int;
			if(arr.length>1){
				var elementsInA1:int = arr.length/2;
				var elementsInA2:int = elementsInA1;
				if((arr.length % 2) == 1){
					elementsInA2 += 1;
				}
				var arr1:Vector.<RosterItem> = new Vector.<RosterItem>();
				var arr2:Vector.<RosterItem> = new Vector.<RosterItem>();
				for(i=0;i<elementsInA1;i++){
					arr1[i] = arr[i];
				}
				for(i=elementsInA1;i<elementsInA1+elementsInA2;i++){
					arr2[i-elementsInA1] = arr[i];
				}
				arr1 = sort(arr1);
				arr2 = sort(arr2);
				
				i=0;j=0;k=0;
				while(arr1.length != j && arr2.length != k){
					if(_order.indexOf(RosterItem(arr1[j]).show) < _order.indexOf(RosterItem(arr2[k]).show)){
						arr[i] = arr1[j];
						i++;j++;
					}else{
						arr[i] = arr2[k];
						i++;k++;
					}
				}
				while(arr1.length != j){
					arr[i] = arr1[j];
					i++;
					j++;
				}
				while(arr2.length != k){
					arr[i] = arr2[k];
					i++;
					k++;
				}
			}
			return arr;
		}
		*/
	}
}