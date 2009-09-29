package grassland.core.commands {
	import grassland.core.interfaces.ICommand;
	import grassland.ui.managers.UtilWindowManager;
	
	public class ShowAboutCommand implements ICommand {
		
		private var _command:Function;
		private var _args:Array;
		
		public function ShowAboutCommand():void {
			init();
		}
		
		private function init():void {
			_command = function() {
				UtilWindowManager.getInstance().newWindow(UtilWindowManager.ABOUT);
			}
		}
		
		public function exec():void {
			_command.apply(null,_args);
		}
		
		public function setArgs(... args):void {
			//_args = args.concat();
		}
	}
}