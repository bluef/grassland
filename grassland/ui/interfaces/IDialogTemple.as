package grassland.ui.interfaces {
	import flash.text.StyleSheet;
	
	public interface IDialogTemple {		
		function process(header:String, value:String):String;
		
		function get styleSheet():StyleSheet;
	}
}