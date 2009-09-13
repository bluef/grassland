package grassland.core.utils {
	import grassland.core.interfaces.ICommand;
	public class MenuCommand implements ICommand{
		private var _command:Function;
		public function MenuCommand():void {
			
		}
		
		public function exec():void{
			_command.call(null);
		}
		
		public function set command(s:Function):void {
			_command = s;
		}
	}
}