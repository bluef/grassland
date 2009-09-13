package grassland.core.interfaces {
	import grassland.core.roster.RosterItem;
	public interface ISorter {
		function sort(x:RosterItem, y:RosterItem):int;
	}
}