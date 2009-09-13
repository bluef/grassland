package grassland.test {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	import com.adobe.crypto.MD5;
	import grassland.xmpp.utils.Base64;
	import grassland.xmpp.utils.RandomString;
	public class base64Test extends Sprite{
		private var ba:ByteArray;
		private function hex2digest(md5:String):ByteArray{
			ba = new ByteArray();
			ba.endian = "littleEndian";
			var raw_bytes:String = '';
			var char_hex:String = '';
			for(var i:int = 0;i<32;i+=2){
				char_hex = md5.substr(i,2);
				//trace(int("0x"+char_hex));
				//raw_bytes += String.fromCharCode(int("0x"+char_hex));
				ba.writeByte(int("0x"+char_hex));
			}
			//ba.position = 0;
			//trace(ba.bytesAvailable);
			//trace("ba",ba.toString());
			//ba.position = 0;
			//trace(ba.readUTFBytes(16));
			trace(MD5.hashBinary(ba));
			return ba;
		}
		
		public function base64Test(){
			trace(Base64.decode(s));
			var dedata:String = Base64.decode(s);
			var arr:Array = dedata.split(",");
			var realmP:RegExp = /realm="(.+)"$/;
			var realmO:Object = realmP.exec(arr[0]);
			var realmS:String = realmO[1];
			var nonceP:RegExp = /nonce="(.+)"$/;
			var nonceO:Object = nonceP.exec(arr[1]);
			var nonceS:String = nonceO[1];
			var cnonce:String = RandomString.generateRandomString(64);
			cnonce = "3202c32ca06f0daf74fc250edf7d60eea914840fbe22357825688b6c5f5254a9";
			var user_pw_hash:String = MD5.hash("bluef"+":"+realmS+":"+"080372303");
			//trace(user_pw_hash);
			var ba:ByteArray = hex2digest(user_pw_hash);
			ba.writeUTFBytes(":"+nonceS+":"+cnonce);
			var ha1:String = MD5.hashBinary(ba);
			//var ha1:String = MD5.hash(hex2digest(user_pw_hash)+":"+nonceS+":"+cnonce);
			//trace("hex",hex2digest(user_pw_hash));
			trace("ha1",ha1);
			//trace("md5",MD5.hash(hex2digest(user_pw_hash)));
			var ha2:String = MD5.hash("AUTHENTICATE:xmpp/dormforce.net");
			
			var response:String = MD5.hash(ha1+":"+nonceS+":00000001:"+cnonce+":auth:"+ha2);
			trace('username="'+"bluef"+'",realm="dormforce.net",nonce="'+nonceS+'",cnonce="'+cnonce+'",nc=00000001,qop=auth,digest-uri="xmpp/dormforce.net",charset=utf-8,response='+response);
			var responseBody:String = Base64.encode('username="'+"bluef"+'",realm="dormforce.net",nonce="'+nonceS+'",cnonce="'+cnonce+'",nc=00000001,qop=auth,digest-uri="xmpp/dormforce.net",charset=utf-8,response='+response);
			var resultxml:XML = <response xmlns="urn:ietf:params:xml:ns:xmpp-sasl"/>;
			resultxml.appendChild(responseBody);
			var rr:String = "dXNlcm5hbWU9ImJsdWVmIixyZWFsbT0iZG9ybWZvcmNlLm5ldCIsbm9uY2U9IkppZzBCdmFJZ1VzQ2M2Zkw4K21sa09oS2ZWeGRjYVU1Y1hxY2pqTmEiLGNub25jZT0iMzIwMmMzMmNhMDZmMGRhZjc0ZmMyNTBlZGY3ZDYwZWVhOTE0ODQwZmJlMjIzNTc4MjU2ODhiNmM1ZjUyNTRhOSIsbmM9MDAwMDAwMDEscW9wPWF1dGgsZGlnZXN0LXVyaT0ieG1wcC9kb3JtZm9yY2UubmV0IixjaGFyc2V0PXV0Zi04LHJlc3BvbnNlPWRiYTFkNGM1OTU5NDkyODAyYjk4YjVkZWExYjQ3OTcw";
			trace(Base64.decode(rr));
			trace(responseBody == rr);
			//
		}
	}
}