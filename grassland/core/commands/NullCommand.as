package grassland.core.commands {
	import grassland.core.interfaces.ICommand;
	
	public class NullCommand implements ICommand {
		
		private var _command:Function;
		private var _args:Array;
		
		public function NullCommand():void {
			init();
		}
		
		private function init():void {
			_command = function(){
				trace("null command");
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