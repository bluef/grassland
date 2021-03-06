﻿package grassland.core {
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import grassland.core.Setting;
	import grassland.core.events.RosterUpdateEvent;
	import grassland.core.interfaces.ISorter;
	import grassland.core.roster.RosterItem;
	import grassland.core.roster.RosterGroup;
	import grassland.core.utils.JID;
	import grassland.core.utils.UserProfile;
	import grassland.core.sorters.StatusSorter;
	import grassland.core.sorters.AlphabetSorter;
	import grassland.xmpp.packets.MessagePacket;
	import grassland.xmpp.packets.PresencePacket;
	
	public class Env extends EventDispatcher {
		public static const STATUS:String = "status";
		public static const ALPHABET:String = "alphabet";
		public static const MSG_BUFFER_CLEAN:String = "msg_buffer_clean";
		public static const ROSTER_FILLED:String = "roster_filled";
		public static const PRESECNCE_BUFFER_CLEAN:String = "presence_buffer_clean";
		public static const AVATAR_UPDATED:String = "avatar_updated";

		
		//singleton class.store instance in _instance
		private static var _instance:Env;
		
		private var _settingObj:Setting;
		private var _msgBuffer:Vector.<MessagePacket>;
		private var _presenceBuffer:Vector.<PresencePacket>;
		private var _rostered:Boolean;
		
		private var _firstRostered:Boolean;
		
		//store user info
		private var _myProfile:UserProfile;
		private var _user:JID;
		private var _password:String;
		private var _remember:Boolean;
		
		//store roster list
		private var _roster:Vector.<RosterGroup>;
		private var _group:Vector.<String>;
		
		private var _sorter:ISorter;
		
		private var _searchMsgBufferByJIDCd:JID;
		
		public function Env(singlentonEnforcer:SingletonEnforcer) {
			init();
		}
		
		private function init():void {
			_roster = new Vector.<RosterGroup>();
			_group = new Vector.<String>();
			_msgBuffer = new Vector.<MessagePacket>();
			_presenceBuffer = new Vector.<PresencePacket>();
			_rostered = false;
			_firstRostered = true;
			_remember = true;
			setSorter(STATUS);
		};
		
		public static function getInstance():Env {
			if (Env._instance == null) {
				Env._instance = new Env(new SingletonEnforcer());
			}
			return Env._instance;
		}
		
		//load local config xml file;
		public function loadConfig(user:String, pw:String):void {
			trace("config loaded");
			_myProfile = new UserProfile(user, pw);
			
		}
		
		public function set myProfile(s:UserProfile):void {
			_myProfile = s.clone();
		}
		
		public function get myProfile():UserProfile {
			//trace("_myProfile =", _myProfile.show)
			return _myProfile;
		}
		
		public function get user():JID {
			if (_myProfile == null) {
				return null;
			} else {
				return _myProfile.user;
			}
		}
		
		public function set password(p:String):void {
			_myProfile.password = p;
		}
		
		public function get password():String {
			return _myProfile.password;
		}
		
		public function get remember():Boolean {
			return _remember;
		}
		
		public function set remember(s:Boolean):void {
			_remember = s;
		}
		
		private function loadMyAvatar():void {
			var r:URLRequest = new URLRequest("http://www2.dormforce.net/cache/imgc.php?a=get&m=uid&u=" + _myProfile.user.node);
			var l:Loader = new Loader();
			l.contentLoaderInfo.addEventListener(Event.COMPLETE, onMyAvatarLoaded);
			l.load(r);
		}
		
		private function onMyAvatarLoaded(e:Event):void {
			_myProfile.avatar = Bitmap(e.target.content).bitmapData;
			dispatchEvent(new Event(AVATAR_UPDATED,true));
			trace("going to update profile");
		}
		
		//store roster list and sort for initiate environment
		public function fillRoster(s:Vector.<RosterItem>):void {
			var l:int = s.length;
			var i:int;
			var tmpRoster:RosterItem;
			var existGroup:RosterGroup;
			var tmpGroup:RosterGroup;
			
			for (i = 0; i < l; ++i) {
				tmpRoster = RosterItem(s[i]);
				if (RosterItem(tmpRoster).nick == null || RosterItem(tmpRoster).nick == '') {
					RosterItem(tmpRoster).nick = JID(RosterItem(tmpRoster).uid).node;
				}
				
				if (RosterItem(tmpRoster).group == null || RosterItem(tmpRoster).group == '') {
					RosterItem(tmpRoster).group = "好友";
				}
				//trace("ROSTER GROUP FOUND: ", s[i].group);
				
				existGroup = getRosterGroupObjByName(String(RosterItem(tmpRoster).group));
				if (existGroup == null) {
					_group.push(String(RosterItem(tmpRoster).group));
					tmpGroup = new RosterGroup(String(RosterItem(tmpRoster).group));
					_roster.push(tmpGroup);
					if (_firstRostered) {
						RosterGroup(_roster[_roster.length - 1]).addItem(RosterItem(tmpRoster));
					} else {
						if (RosterGroup(_roster[_roster.length - 1]).getRosterItemByJID(RosterItem(tmpRoster).uid) != null) {
							RosterGroup(_roster[_roster.length - 1]).addItem(RosterItem(tmpRoster));
						}
					}
					//pos = _roster.length-1;
				} else {
					RosterGroup(existGroup).addItem(tmpRoster);
				}
			}
				
			l = _roster.length;
			for (i = 0;i < l; ++i) {
				dispatchEvent(new RosterUpdateEvent(i));
			}
			
			if (_firstRostered) {
				_firstRostered = false;
			}
			dispatchEvent(new Event(ROSTER_FILLED, true));
		}
		
		public function moveRosterItem(groupName:String, itemIndex:int, targetGroup:String):void {
			var item:RosterItem = getRosterGroupObjByName(groupName).removeItemAt(itemIndex);
			RosterGroup(getRosterGroupObjByName(targetGroup)).addItem(item);
			
			dispatchEvent(new RosterUpdateEvent(getRosterGroupByName(groupName)));
			dispatchEvent(new RosterUpdateEvent(getRosterGroupByName(targetGroup)));
		}
		
		public function getRosterGroupByName(s:String):int {
			var found:int = -1;
			for (var i:int = 0; i < _roster.length; ++i) {
				if (RosterGroup(_roster[i]).name == s) {
					found = i;
					break;
				}
			}
			return found;
		}
		
		public function getRosterGroupObjByName(s:String):RosterGroup {			
			_rosterGroupNameForSearch = s;
			
			var filterItems:Vector.<RosterGroup> = _roster.filter(searchRosterGroupObjByName, null);
			
			if (filterItems.length == 0) {
				return null;
			} else {
				return filterItems[0];
			}
			
		}
		
		private var _rosterGroupNameForSearch:String;
		
		private function searchRosterGroupObjByName(item:RosterGroup, index:int, vector:Vector.<RosterGroup>):Boolean {
			return (RosterGroup(item).name == _rosterGroupNameForSearch);
		}
		
		public function setSorter(s:String):void {
			switch (s) {
				case STATUS:
					_sorter = new StatusSorter();
					break;
					
				case ALPHABET:
					_sorter = new AlphabetSorter();
					break;
					
				default	:
					throw new Error("unknown sorter type");
					break;
			}
		}
		
		public function getRosterItemByJID(s:JID):RosterItem {
			var j:int = 0;
			var i:int = 0;
			var found:Boolean = false;
			var l:int;
			var tmpItem:RosterItem;
			while (!found) {
				/*
				l = _roster[j].length;
				for (i = 0; i < l; ++i) {
					if (_roster[j].getRosterItemAt(i).uid.toString() == s.toString()){
						
					}
				}
				*/
				tmpItem = RosterGroup(_roster[j]).getRosterItemByJID(s);
				
				if (tmpItem != null) {
					found = true;
					break;
				}
				
				++j;
			}
			return tmpItem;
		}
		
		public function updateRoster(s:RosterItem):void {
			//trace("update roster", JID(RosterItem(s).uid).valueOf());
			var j:int = 0;
			var found:Boolean = false;
			var needToUpdate:Boolean = false;
			
			var tmpItem:RosterItem;
			while (!found) {
				tmpItem = RosterGroup(_roster[j]).getRosterItemByJID(JID(RosterItem(s).uid));
					
				if (tmpItem != null) {
					if (s.show != "offline") {
						if (JID(RosterItem(tmpItem).uid).domain == "dormforce.net" && RosterItem(tmpItem).avatar != null) {
							loadAvatar(JID(tmpItem.uid).node);
						}
					} else {
						BitmapData(RosterItem(tmpItem).avatar).dispose();
					}
					
					tmpItem.show = s.show;
					tmpItem.status = s.status;
					found = true;
					needToUpdate = true;
					break;
				}
				++j;
			}
			
			if (needToUpdate) {
				RosterGroup(_roster[j]).sort(_sorter);
				//RosterGroup(_roster[j]).countOnline();
				dispatchEvent(new RosterUpdateEvent(j));
			}
		}
		
		public function get roster():Vector.<RosterGroup> {
			return _roster;
		}
		
		//return roster count
		public function get rosterNum():int {
			return _roster.length;
		}
		
		public function getRosterCache(s:int):void {
			
		}
		
		private function loadAvatar(u:String):void {
			var r:URLRequest = new URLRequest("http://www2.dormforce.net/talk/avatar.php?uid=" + u);
			var l:Loader = new Loader();
			l.contentLoaderInfo.addEventListener(Event.COMPLETE, onAvatarLoaded);
			l.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR , onAvatarIOError);
			l.load(r);
		}
		
		private function onAvatarLoaded(e:Event):void {
			var u:String = e.target.url.substring(46);
			updateAvatar(u, Bitmap(e.target.content).bitmapData);
			//dispatchEvent(new Event(ROSTER_UPDATED,true));
		}
		
		private function onAvatarIOError(e:IOErrorEvent):void {
			trace("ERROR LOADING AVATER");
			EventDispatcher(e.target).removeEventListener(Event.COMPLETE, onAvatarLoaded);
			EventDispatcher(e.target).removeEventListener(IOErrorEvent.IO_ERROR , onAvatarIOError);
		};
		
		public function updateAvatar(ss:String, bmp:BitmapData):void {
			var s:JID = new JID(ss + "@dormforce.net");
			trace(s.toString());
			var j:int = 0;
			var i:int = 0;
			var found:Boolean = false;
			var needToUpdate:Boolean = false;
			
			var tmpItem:RosterItem;
			 
			while (!found) {
				var l:int = _roster[j].length;
				tmpItem = RosterGroup(_roster[j]).getRosterItemByJID(JID(s));
				
				if (tmpItem != null) {
					tmpItem.avatar = bmp;
					found = true;
					break;
				}
				++j;
			}
			dispatchEvent(new RosterUpdateEvent(j));
		}
		
		//add a msg packet into buffer and wait for beening showing
		public function pushMsgBuffer(packet:MessagePacket):void {
			trace("msg pushed");
			_msgBuffer.push(packet.clone());
		}
		
		//return a msg packet stored in buffer from a specified JID
		public function popMsgBuffer(pfrom:JID):MessagePacket {
			
			//get the first index of msg packet associated with pfrom found and delete the packet at that index
			trace("pfrom =",pfrom.toString());
			var packet:MessagePacket = getMsgBufferByJID(pfrom);
			//trace("pos =",pos)
			_msgBuffer.splice(_msgBuffer.indexOf(packet), 1);
			//var packet:MessagePacket = new MessagePacket();
			//trace(_msgBuffer.splice(pos,1));
			//check msgBuffer is empty or not
			if (_msgBuffer.length == 0) {
				dispatchEvent(new Event(MSG_BUFFER_CLEAN,true))
			}
			return packet;
		}
		
		public function popMsgBufferTail():MessagePacket {
			return _msgBuffer.pop();
		}
		
		//get the first index of msg packet associated with pfrom found
		public function getMsgBufferByJID(pfrom:JID):MessagePacket {		
			_searchMsgBufferByJIDCd = pfrom;
			
			var filterItems:Vector.<MessagePacket> = _msgBuffer.filter(searchMsgBufferByJIDFunc, null);
			
			if (filterItems.length == 0) {
				return null;
			} else {
				return filterItems[0];
			}
		}
		
		private function searchMsgBufferByJIDFunc(item:MessagePacket, index:int, vector:Vector.<MessagePacket>):Boolean {
			return (MessagePacket(item).from.toString() == _searchMsgBufferByJIDCd.toString());
		};
		
		//get the number of unread msg associated with specified contact 
		public function getMsgCountByRoster(pfrom:JID):int {			
			var searchFunc:Function = function (item:MessagePacket, index:int, vector:Vector.<MessagePacket>):Boolean {
				return (MessagePacket(item).from == pfrom);
			}
			
			var filterItems:Vector.<MessagePacket> = _msgBuffer.filter(searchFunc, null);
			return filterItems.length;
		}
		
		//get the length of msg buffer
		public function get msgBufferLength():int {
			return _msgBuffer.length;
		}
		
		public function pushPresenceBuffer(packet:PresencePacket):void {
			//trace("presence pushed");
			var r:RosterItem;
			var p:PresencePacket;
			var l:int = _presenceBuffer.length;
			
			if (_firstRostered == false) {
				//trace(_presenceBuffer.length);
				if (_presenceBuffer.length == 0) {
					r = new RosterItem(packet.from, packet.show, packet.status);
					updateRoster(r);
				} else {			
					for (var j:int = 0; j < l; ++j) {
						if (PresencePacket(_presenceBuffer[j]).from.toString() == packet.from.toString()) {
							_presenceBuffer.splice(j, 1, packet);
						} else {
							_presenceBuffer.push(packet.clone());
						}
					}
					startUpdateRoster();
				}
			} else {
				_presenceBuffer.push(packet.clone());
			}
		}
		
		public function startUpdateRoster():void {
			loadMyAvatar();
			var r:RosterItem;
			var p:PresencePacket; 
			trace("start update");
			trace(_presenceBuffer.length);
			while (_presenceBuffer.length > 0) {
				p = _presenceBuffer.pop();
				r = new RosterItem(p.from, p.show, p.status);
				updateRoster(r);
			}
			//trace(_presenceBuffer.length);
		}
		
		public function get contextMenuXML():XML {
			var s:XML = 
			<list>
				<item label="移动此联系人至" cmd="NullCommand" />
				<item label="查看聊天记录" cmd="CheckLogCommand"/>
			</list>
			
			for each (var groupItem:String in _group) {
				s.item.(@label == "移动此联系人至").appendChild(<item label={groupItem} cmd="MoveContactCommand"/>);
			}
			return s;
		}
		
		public function get groupsData():Vector.<String> {
			return _group;
		};
	}
}
class SingletonEnforcer {}