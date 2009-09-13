package grassland.core.commands {
	import grassland.core.interfaces.ICommand;
	
	public class HideOfflineContactCommand implements ICommand {
		
		private var _command:Function;
		private var _args:Array;
		
		public function HideOfflineContactCommand():void {
			init();
		}
		
		private function init():void {
			_command = function(){
				
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