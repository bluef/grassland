package grassland.core.interfaces {
	public interface ICommand {
		function exec():void;
		function setArgs(... args):void;
	}
}