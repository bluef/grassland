﻿package grassland.xmpp.events {
	import flash.events.Event;
	import grassland.xmpp.packets.MessagePacket;
	
	public class MessageEvent extends Event {
		public static var RECEIVED:String = "Message_Received";
		private var _data:MessagePacket;
		
		public function MessageEvent(s:MessagePacket) {
			super(MessageEvent.RECEIVED, true, false);
			_data = s;
		}
		
		public function get data():MessagePacket {
			return _data;
		}
		
		public function set data(s:MessagePacket):void {
			_data = s;
		}
	}
}