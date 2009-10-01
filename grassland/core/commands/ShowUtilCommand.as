package grassland.core.commands {
	import grassland.core.interfaces.ICommand;
	import grassland.ui.managers.UtilWindowManager;
	
	public class ShowUtilCommand implements ICommand {
		private var _type:String;
		
		private var _command:Function;
		private var _args:Array;
		
		public function ShowUtilCommand(type:String):void {
			_type = type;
			init();
		}
		
		private function init():void {
			_command = function() {
				UtilWindowManager.getInstance().newWindow(_type);
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