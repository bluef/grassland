package grassland.core.commands {
	import grassland.core.interfaces.ICommand;
	
	public class MoveContactCommand implements ICommand {
		
		private var _command:Function;
		private var _args:Array;
		
		public function MoveContactCommand():void {
			init();
		}
		
		private function init():void {
			_command = function(... args){
				//Env.getInstance().moveItem(e.mouseTarget, e.data);
				var item:ContactListItem = ContactListItem(args[0]);
				Env.getInstance().moveItem(item.group, item.index, args[1]);
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