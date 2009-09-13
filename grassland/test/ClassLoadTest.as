package grassland.test {
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	import grassland.core.commands.NullCommand;
	
	public class ClassLoadTest extends Sprite {
		private var bgColor:uint = 0xFFCC00;
        private var size:uint = 80;

        public function ClassLoadTest():void {
            
            var ClassReference:Class = getDefinitionByName("grassland.core.commands.NullCommand") as Class;
            var instance:Object = new ClassReference();
            instance.exec();
            
            
            /*
            var instance:Object = new NullCommand();
            instance.exec();
            */
        }
	}
}