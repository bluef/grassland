package grassland.ui.utils {
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import grassland.ui.utils.DefaultTextFormat;
	public class InputField extends TextField {
		public function InputField(w:uint = 0,h:uint = 0,pw:Boolean = false){
			width = w;
			height = h;
			displayAsPassword = pw;
			type = TextFieldType.INPUT;
			defaultTextFormat = new DefaultTextFormat();
			border = true;
			borderColor = 0x666666;
			background = true;
			backgroundColor = 0xffffff;
		}
		
		public function set w(s:uint):void{
			width = s;
		}
		
		public function get w():uint{
			return width;
		}
		
		public function set h(s:uint):void{
			height = s;
		}
		
		public function get h():uint{
			return height;
		}
	}
}