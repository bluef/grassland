package grassland.ui.windows {
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.desktop.NativeApplication;
	import flash.system.System;
	import flash.system.Capabilities;
	
	import grassland.core.Version;
	import grassland.ui.base.BasicWindow;
	import grassland.ui.utils.LabelText;
	
	import grassland.ui.interfaces.IUtilWindow;
	
	public class AboutWindow extends BasicWindow implements IUtilWindow {
		private var _logo:Loader;
		private var _msg:LabelText;
		private var _id:String = "grassland.ui.windows::AboutWindow";
		public function AboutWindow():void {
			super(380, 220, false);
			title = "About Grassland";
			
			init();
		}
		
		private function init():void {
			_logo = new Loader();
			//_logo.load(new URLRequest(""));
			_logo.x = 10;
			_logo.y = 30;
			_panel.addChild(_logo);
			
			_msg = new LabelText("", 290);
			_msg.appendText("Grassland " + Version.VERSION +"\n");
			_msg.appendText("          " + XML(NativeApplication.nativeApplication.applicationDescriptor).version.toString() +"\n");
			_msg.appendText("Author: Terrence Lee\n");
			_msg.appendText("Runtime Version: " + NativeApplication.nativeApplication.runtimeVersion + "\n");
			_msg.appendText("OS: " + Capabilities.os + "\n");
			_msg.appendText("Memory: " + System.totalMemory / 1024+ " KB");
			_msg.x = 90;
			_msg.y = 12;
			_panel.addChild(_msg);
		}
		
		public function get id():String {
			return _id;
		};
	}
}