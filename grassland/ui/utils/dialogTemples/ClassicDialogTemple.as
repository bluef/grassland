package grassland.ui.utils.dialogTemples {
	import flash.text.StyleSheet;
	
	import grassland.ui.interfaces.IDialogTemple;
	import grassland.ui.base.BaseDialogTemple;
	
	public class ClassicDialogTemple extends BaseDialogTemple implements IDialogTemple {
		public function ClassicDialogTemple():void {
			super();
			
			var header:Object = {};
			header.fontSize = 12;
			header.color = "#0000FF";
			header.fontWeight = 'bold';
			
			var text:Object = {};
			text.color = "#000000";
			text.fontSize = 12;
			text.marginLeft = 16;
			text.marginRight = 10;
			
			var item:Object = {};
			item.marginLeft = 10;
			item.marginRight = 10;
			
			StyleSheet(_css).setStyle('.dialog-header', header);
			StyleSheet(_css).setStyle('.dialog-text', text);
			StyleSheet(_css).setStyle('.dialog-item', item);
		};
	}
}