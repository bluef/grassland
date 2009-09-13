package grassland.xmpp {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import grassland.xmpp.events.ResolverEvent;
	import grassland.xmpp.events.DataEvent;
	public class XMPPDataResolver extends EventDispatcher{
		public static const NOTRUNNING:String = "not_running";
		private var _xmlPattern:RegExp = /^(null)*?<([A-Za-z0-9\:]+)[^>]*?((>.*?<\/\2>)|(\/>))/i;
		public function XMPPDataResolver(){
			
		}
		
		public function paste(s:String):void{
			var o:Object = _xmlPattern.exec(s);
			trace("\n<<TEXT>>",s,"\n\n")
			while(o != null){
				//trace("got it");
				alertDataPaste(o[0]);
				var l:uint = o[0].length;
				s = s.substring(o.index+l);
				o = _xmlPattern.exec(s);
			}
			alertDataTail(s);
		}
		
		private function alertDataPaste(s:String):void{
			dispatchEvent(new DataEvent(DataEvent.DATA,s));
		}
		
		private function alertDataTail(s:String):void{
			dispatchEvent(new ResolverEvent(s));
		} 
		
		private function notRunning():void{
			dispatchEvent(new Event(NOTRUNNING,true));
		}
	}
}