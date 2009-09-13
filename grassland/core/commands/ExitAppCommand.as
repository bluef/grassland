package grassland.core.commands {
	import flash.desktop.NativeApplication;
	import grassland.core.interfaces.ICommand;
	
	public class ExitAppCommand implements ICommand {
		
		private var _command:Function;
		private var _args:Array;
		
		public function ExitAppCommand():void {
			init();
		}
		
		private function init():void {
			_command = function(){
				NativeApplication.nativeApplication.exit();
			}
		}
		
		public function exec():void{
			_command.apply(null,_args);
		}
		
		public function setArgs(... args):void{
			_args = args.concat();
		}
	}
}