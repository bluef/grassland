package grassland.ui.utils {
	import flash.text.TextField;
	import flash.text.AntiAliasType;
	import grassland.ui.utils.DefaultTextFormat;
	public class LabelText extends TextField {
		private var _format:DefaultTextFormat;
		public function LabelText(t:String = '', w:uint = 50, bold:Boolean = false, color:Number = 0x000000, italic:Boolean = false, size:uint = 12) {
			_format = new DefaultTextFormat();
			_format.font = "Arial";
			_format.bold = bold;
			_format.color = color;
			_format.italic = italic;
			_format.size = size;
			defaultTextFormat = _format;
			selectable = false;
			mouseEnabled = false;
			antiAliasType = AntiAliasType.ADVANCED;
			text = t;
			width = w;
		}
		
		public function set bold(s:Boolean):void {
			_format.bold = s;
			
		}
		
		public function set color(s:Number):void {
			_format.color = s;
			this.setTextFormat(_format);
		}
		
		public function set italic(s:Boolean):void {
			_format.italic = s;
			setTextFormat(_format);
		}
		
		public function set size(s:uint):void {
			_format.size = s;
			setTextFormat(_format);
		}
	}
}