package grassland.ui.managers {
	import grassland.core.roster.RosterItem;
	
	public class MsgWindowConfig {
		private var _guest:RosterItem;
		
		public function MsgWindowConfig(wguest:RosterItem){
			_guest = wguest.clone();
		}
		
		public function get guest():RosterItem {
			return _guest.clone();
		}
		
		public function clone():MsgWindowConfig{
			return new MsgWindowConfig(_guest.clone())
		}
	}
}