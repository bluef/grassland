package grassland.ui.utils {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	import grassland.ui.utils.DefaultTextFormat;
	
	public class CmdBtn extends SimpleButton {
		private var _text:String;
		// Save the width and height of the rectangle
		private var _width:Number;
		private var _height:Number;
		private var txtFormat:DefaultTextFormat;

		public function CmdBtn (text:String,width:Number,height:Number):void {
			// Save the values to use them to create the button states
			_text = text;
			_width = width;
			_height = height;
			
			txtFormat = new DefaultTextFormat();
			txtFormat.align = TextFormatAlign.CENTER;
			
			// Create the button states based on width, height, and text value
			upState = createUpState();
			overState = createOverState();
			downState = createDownState();
			hitTestState = upState;
		}
		
		// Create the display object for the button's up state
		private function createUpState():Sprite {
			var sprite:Sprite = new Sprite();

			var background:Shape = createdColoredRectangle(0xefefef);
			var textField:TextField = createTextField();
			textField.defaultTextFormat= txtFormat;

			sprite.addChild(background);
			sprite.addChild(textField);

			return sprite;
		}
		
		private function createDisabledState():Sprite {
			var sprite:Sprite = new Sprite();

			var background:Shape = createdColoredRectangle(0xefefef);
			var textField:TextField = createTextField();
			textField.defaultTextFormat= txtFormat;

			sprite.addChild(background);
			sprite.addChild(textField);

			return sprite;
		}
		
		// Create the display object for the button's up state
		private function createOverState():Sprite {
			var sprite:Sprite = new Sprite();

			var background:Shape = createdColoredRectangle(0x99ccee);
			var textField:TextField = createTextField();
			textField.defaultTextFormat= txtFormat ;

			sprite.addChild(background);
			sprite.addChild(textField);

			return sprite;
		}
		
		// Create the display object for the button's down state
		private function createDownState():Sprite {
			var sprite:Sprite = new Sprite();

			var background:Shape = createdColoredRectangle(0x00CCFF);
			var textField:TextField = createTextField();
			textField.defaultTextFormat= txtFormat ;

			sprite.addChild(background);
			sprite.addChild(textField);

			return sprite;
		}
		
		// Create a rounded rectangle with a specific fill color
		private function createdColoredRectangle(color:uint):Shape {
			var rect:Shape = new Shape();
			rect.graphics.lineStyle(1,0x333333);
			rect.graphics.beginFill(color);
			rect.graphics.drawRoundRect(0, 0, _width, _height, 7, 7);
			rect.graphics.endFill();
			rect.width = _width;
			rect.height = _height;
			return rect;
		}
		
		// Create the text field to display the text of the button
		private function createTextField():TextField {			
			var textField:TextField = new TextField();
			textField.defaultTextFormat = txtFormat ;
			
			textField.text = _text;
			textField.width = _width;
			textField.height = 30;
			
			// Center the text vertically
			textField.y = (_height - textField.textHeight) / 2;
			textField.y -= 2;// Subtract 2 pixels to adjust for offset

			return textField;
		}
		
		override public function set enabled(value:Boolean):void{
			if(!value){
				upState = createDisabledState();
			}
			super.enabled = value;
		}
	}
}