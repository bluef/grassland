package grassland.ui.windows {
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.desktop.NativeApplication;
	import flash.system.System;
	import flash.system.Capabilities;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	import grassland.core.Version;
	import grassland.ui.base.BasicWindow;
	import grassland.ui.utils.LabelText;
	
	import grassland.ui.interfaces.IUtilWindow;
	
	public class AboutWindow extends BasicWindow implements IUtilWindow {
		private static const AIR_NS:Namespace = new Namespace("http://ns.adobe.com/air/application/1.5");
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
			_logo.load(new URLRequest("http://202.115.22.207/grassland/logo.png"));
			_logo.x = 10;
			_logo.y = 30;
			_panel.addChild(_logo);
			
			_msg = new LabelText("", 290);
			_msg.height = 200;
			_msg.appendText("Grassland " + Version.VERSION + " " + XML(NativeApplication.nativeApplication.applicationDescriptor).AIR_NS::version.toString() + "\n");
			_msg.appendText("Copyright (C) 2008-2009, Terrence Lee\n");
			_msg.appendText("Icons copyright (C) 2009, Yin Xin\n");
			_msg.appendText("Runtime Version: " + NativeApplication.nativeApplication.runtimeVersion + "\n");
			_msg.appendText("OS: " + Capabilities.os + "\n");
			_msg.appendText("Memory: " + System.totalMemory / 1024 + " KB");
			_msg.x = 90;
			_msg.y = 12;
			_panel.addChild(_msg);
		}
		
		public function get id():String {
			return _id;
		};
		
		override protected function closeWin(e:MouseEvent):void {
			_logo.unload();
			dispatchEvent(new Event(Event.CLOSING)); //Event.CLOSING
			
		}
	}
}