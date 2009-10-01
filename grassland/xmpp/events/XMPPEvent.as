﻿package grassland.xmpp.events {
	import flash.events.Event;
	public class XMPPEvent extends Event {
		public static const RAW:String = "xmpp_raw_data";
		private var _data:Object;
		public function XMPPEvent(t:String, s:Object = null) {
			super(t, true, false);
			_data = s;
		}
		
		public function set data(value:Object):void{
			_data = value;
		}
		
		public function get data():Object{
			return _data;
		}
	}
}