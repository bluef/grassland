package grassland.core {
	import flash.events.EventDispatcher;
	public class PluginHub extends EventDispatcher {
		private var _appPath:File;
		public function PluginHub(){
			_appPath = File.applicationDirectory;
			_appPath.resolvePath("plugins").createDirectory();
		}
		
		public function initPlugins():void{
			var pl:XML = downloadPluginList();
			//download the plugin list and check all the essential plugins is available on disk
			for each
		}
		
		public function downloadPluginList():XML{
			var r:URLRequest = new URLRequest(PLUGIN_LIST_URL);
			var l:URLLoader = new URLLoader(r);
			
		}
		
		public function downloadPlugin():ByteArray{
			var r:URLRequest = new URLRequest();
			var l:
		}
		
		public function installPlugin(p:Plugin,ba:ByteArray):void{
			var f:File = _appPath.resolvePath("plugins").resolvePath(p.filename);
			var fs:FileStream = new FileStream();
			fs.open(f,FileMode.WRITE);
			fs.writeBytes(ba,0,ba.length);
		}
		
		public function startPlugin(name:String,...args):void{
			
		}
	}
}