package grassland.ui.base {
	import flash.text.StyleSheet;
	import grassland.ui.interfaces.IDialogTemple;
	
	public class BaseDialogTemple implements IDialogTemple {
		protected var _css:StyleSheet;
		private var _temple:String;
		
		public function BaseDialogTemple():void {
			_css = new StyleSheet();
			_temple = '';
		};
		
		public function process(header:String, text:String):String {
			_temple = "<div class='dialog-item'><p class='dialog-header'>" + header + "</p><p class='dialog-text'>" + text + "</p></div>";
			return _temple;
		};
		
		public function get styleSheet():StyleSheet {
			return _css;
		};
	}
}