package grassland.core.commands {
	import grassland.core.interfaces.ICommand;
	import grassland.ui.managers.UtilWindowManager;
	import grassland.ui.windows.SubscribeWindow;
	import grassland.ui.events.UtilWindowType;
	
	public class ShowSubscribeCommand implements ICommand {
		private var _type:String;
		
		private var _command:Function;
		private var _args:Array;
		
		public function ShowSubscribeCommand():void {
			_type = SubscribeWindow.SUBSCRIBE_MODE;
			
			init();
		}
		
		private function init():void {
			_command = function() {
				UtilWindowManager.getInstance().newWindow(UtilWindowType.SUBSCRIBE, _type);
			}
		}
		
		public function exec():void {
			_command.apply(null, _args);
		}
		
		public function setArgs(... args):void {
			//_args = args.concat();
		}
	}
}