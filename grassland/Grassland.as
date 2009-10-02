package grassland {
	import flash.desktop.DockIcon;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemTrayIcon;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.Sprite;
	import flash.display.Screen;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import flash.filesystem.File;
	import air.update.ApplicationUpdater;
	import air.update.events.StatusUpdateEvent;
	import air.update.events.UpdateEvent;
	
	import grassland.core.Env;
	import grassland.core.LocalStroage;
	import grassland.core.utils.*;
	import grassland.core.events.RosterUpdateEvent;
	import grassland.core.roster.RosterItem;
	import grassland.core.roster.RosterGroup;
	import grassland.core.Version;
	import grassland.xmpp.XMPPStream;
	import grassland.xmpp.packets.*;
	import grassland.xmpp.events.*;
	import grassland.ui.managers.*;
	import grassland.ui.windows.MainWindow;
	import grassland.ui.windows.Notify;
	import grassland.ui.windows.LoginWindow;
	import grassland.ui.events.*;
	import grassland.ui.utils.icons.LightIcon;
	import grassland.ui.utils.icons.DarkIcon;
	
	//document class
	public class Grassland extends Sprite {
		private var _loginWindow:LoginWindow;
		private var _mainWindow:MainWindow;
		private var _iconMenu:NativeMenu;
		private var _lightIcon:LightIcon;
		private var _darkIcon:DarkIcon;
		private var _sysTray:SystemTrayIcon;
		private var _updater:ApplicationUpdater;
		
		private var _iconState:String;
		private var _i:int;
		private var _flashing:Boolean;
		
		private var _logined:Boolean;
		private var _rosterFilled:Boolean;
		private var _profileInited:Boolean;
		
		public function Grassland(){
			trace("session start");
			_logined = false;
			_rosterFilled = false;
			
			
			init();
			//checkUpdate();
		}
		
		private function checkUpdate():void{
			trace("going to update Grassland");
			_updater = new ApplicationUpdater();
			_updater.configurationFile = new File("app:/updateConfig.xml");
			_updater.isNewerVersionFunction = checkNewerVersion;
			_updater.addEventListener(UpdateEvent.INITIALIZED,goingtoupdate);
			_updater.addEventListener(UpdateEvent.BEFORE_INSTALL,beforeInstallUpdate);
			_updater.addEventListener(StatusUpdateEvent.UPDATE_STATUS,onUpdateAvailable);
			_updater.initialize();
		}
		
		private function goingtoupdate(e:UpdateEvent):void{
			_loginWindow.updating = true;
		}
		
		private function beforeInstallUpdate(e:UpdateEvent):void{
			_loginWindow.updating = true;
		}
		
		private function onUpdateAvailable(e:StatusUpdateEvent):void{
			if(!e.available){
				_loginWindow.updating = false;
			}
		}
		
		private function checkNewerVersion(currentVersion:String, updateVersion:String):Boolean{
			return currentVersion != updateVersion;
		}
		
		private function configureListener():void{
			NativeApplication.nativeApplication.addEventListener(Event.EXITING,onExit,false,0,true);
			_loginWindow.addEventListener(LoginEvent.LOGIN,onlogin,false,0,true);
			_loginWindow.addEventListener(Event.CLOSE,onLoginWinClose,false,0,true);
			_loginWindow.addEventListener(LoginWindow.CANCEL_UPDATE,onCancelUpdate,false,0,true);
			XMPPStream.getInstance().addEventListener(XMPPStream.CONNECT,onConnect);
			XMPPStream.getInstance().addEventListener(XMPPStream.DISCONNECT,onDisconnect);
			XMPPStream.getInstance().addEventListener(XMPPStream.AUTH_SUCCESS,preparing);
			XMPPStream.getInstance().addEventListener(XMPPStream.AUTH_FAILURE,onAuthFailed);
			XMPPStream.getInstance().addEventListener(MessageEvent.RECEIVED,onMessage);
			XMPPStream.getInstance().addEventListener(XMPPEvent.RAW,onRawXMPP);
			XMPPStream.getInstance().addEventListener(XMPPEvent.ERROR,onErrorXMPP);
			
			XMPPStream.getInstance().addEventListener(TypingEvent.TYPING,onTyping);
			XMPPStream.getInstance().addEventListener(TypingEvent.PAUSED,onTyping);
			XMPPStream.getInstance().addEventListener(IQEvent.RECEIVED,onIQ);
			XMPPStream.getInstance().addEventListener(PresenceEvent.RECEIVED,onPresence);
			
			Env.getInstance().addEventListener(RosterUpdateEvent.UPDATED,onRosterUpdated);
			Env.getInstance().addEventListener(Env.MSG_BUFFER_CLEAN,onMsgBufferClean);
			Env.getInstance().addEventListener(Env.ROSTER_FILLED,prepared);
			Env.getInstance().addEventListener(Env.AVATAR_UPDATED,onAvatarUpdated);			
			//Env.getInstance().addEventListener(Env.PRESECNCE_BUFFER_CLEAN,prepared);
			NotifyManager.getInstance().addEventListener(NotifyManagerEvent.CLICK,onNotifyClicked);
			MsgWindowManager.getInstance().addEventListener(MsgWinManagerEvent.MSG,sendMsg);
			MsgWindowManager.getInstance().addEventListener(MsgWinManagerEvent.TYPING,isTyping);
			UtilWindowManager.getInstance().addEventListener(UtilWinMgrEvent.DEBUG_RAW_INPUT, onDebugRawInput);
			NativeApplication.nativeApplication.addEventListener(Event.USER_IDLE, onUserIdle);
			NativeApplication.nativeApplication.addEventListener(Event.USER_PRESENT,onUserPresence);
		}
		
		private function init():void{
			_profileInited = true;
			//if(LocalStroage.getInstance().existSettingFile()){
				//pop up the login window;
				var u:UserProfile = UserProfile(LocalStroage.getInstance().retriveUserProfile());
				//var u:UserProfile
				_loginWindow = new LoginWindow();
				_loginWindow.x = Screen.mainScreen.visibleBounds.width/2 - _loginWindow.width/2;
				_loginWindow.y = Screen.mainScreen.visibleBounds.height/2 - _loginWindow.height/2;
				if(u != null){
					Env.getInstance().myProfile = u.clone();
					trace("Env =",Env.getInstance().myProfile.show);
					_loginWindow.username = JID(u.user).node;
					_loginWindow.password = u.password;
				}
				
				_loginWindow.activate();
			
				initIcon();
				configureListener();
			//}else{
				//setup();
			//}
		}
		
		/*private function setup():void{
			//init all the essential plugins
			PluginHub.initPlugins();
			//create a Setting.cfg as a mark of the program been setup correctly
			LocalStroage.getInstance().createSettingFile();
		}
		*/
		
		private function exitApp(e:Event):void{
			NativeApplication.nativeApplication.exit();
		}
		
		private function onCancelUpdate(e:Event):void {
			_updater.cancelUpdate();
		}
		
		private function onlogin(e:LoginEvent):void{
			//init environment
			if(Env.getInstance().user == null || e.user != Env.getInstance().user.node){
				Env.getInstance().loadConfig(e.user, e.password);
			}
			Env.getInstance().remember = e.checked;
			
			//init xmpp stream,including loading user profile from Env
			if (e.server != '' && e.port != 0) {
				XMPPStream.getInstance().init(Env.getInstance().user, Env.getInstance().password, e.server, e.port, e.domain, e.resource);
			} else {
				XMPPStream.getInstance().init(Env.getInstance().user, Env.getInstance().password);
			}
			
			
		}
		
		private function preparing(e:Event):void{
			trace("preparing");
			//LocalStroage.getInstance().storeUserProfile(Env.getInstance().myProfile);
			_logined = true;
			_loginWindow.authed();
			_mainWindow = new MainWindow();
			_mainWindow.x = Screen.mainScreen.visibleBounds.width*0.15;
			_mainWindow.y = Screen.mainScreen.visibleBounds.height*0.15;
			
			_mainWindow.addEventListener(ContactListEvent.ITEM_CLICKED, openNewMsgWin);
			_mainWindow.addEventListener(ChangeStateEvent.CHANGED,onStateChanged);
			_mainWindow.addEventListener(Event.CLOSE, onMainWinClose);
			_mainWindow.addEventListener(MainWindow.PROFILE_INITED, onProfileBlockInited)			
			XMPPStream.getInstance().goOn();
			
		}
		
		private function onExit(e:Event):void{
			trace("going to exit");
			LocalStroage.getInstance().storeUserProfile(Env.getInstance().myProfile);
		}
		
		private function onConnect(e:Event):void{
			_loginWindow.setState("连接成功");
		}
		
		private function onDisconnect(e:Event):void{
			_mainWindow.visible = false;
			_loginWindow.activate();
		}
		
		private function onAuthFailed(e:Event):void{
			_logined = false;
			_loginWindow.authFailed();
		}
		
		private function prepared(e:Event):void{
			trace("prepared");
			_loginWindow.close();
			ContextMenuManager.getInstance().load(Env.getInstance().contextMenuXML);
			_mainWindow.activate();
			NativeApplication.nativeApplication.icon.bitmaps = _lightIcon.bitmaps;
			_iconState = "light";
			Env.getInstance().startUpdateRoster();
			setInitState();
		}
		
		private function setInitState():void{
			var status:String = Env.getInstance().myProfile.status;
			//trace("2 =",Env.getInstance().myProfile.show);
			switch(Env.getInstance().myProfile.show){
				case "online":
					XMPPStream.getInstance().setOnline(status);
					break;
				case "dnd":
					XMPPStream.getInstance().setBusy(status);
					break;
				case "away":
					XMPPStream.getInstance().setAway(status);
					break;
			}
			
			if(Env.getInstance().remember){
				
				LocalStroage.getInstance().storeUserProfile(Env.getInstance().myProfile);
			}else{
				LocalStroage.getInstance().clearUserProfile();
			}
			_mainWindow.updateState(Env.getInstance().myProfile.show,Env.getInstance().myProfile.status);
		}
		
		private function onRawXMPP(e:XMPPEvent):void {
			UtilWindowManager.getInstance().forwardData(e.type, e.data);
		};
		
		private function onErrorXMPP(e:XMPPEvent):void {
			UtilWindowManager.getInstance().forwardData(e.type, e.data);
		};
		
		private function onDebugRawInput(e:UtilWinMgrEvent):void {
			XMPPStream.getInstance().sendData(String(e.data));
		};
		
		//handle msg received
		private function onMessage(e:MessageEvent):void{
			var packet:MessagePacket = MessagePacket(e.data);
			//push msg into msgBuffer stack
			Env.getInstance().pushMsgBuffer(packet);
			//add menuitem to trayicon menu for user to read incoming msg
			//var n:NativeMenuItem = new NativeMenuItem(Env.getInstance().getRosterItemByJID(packet.from).nick);
			
			var config:MsgWindowConfig = new MsgWindowConfig(Env.getInstance().getRosterItemByJID(packet.from));
			if(MsgWindowManager.getInstance().isWinActived(config)){
				//create a new msg window to show the incoming msg
				MsgWindowManager.getInstance().newMsgWindow(config);
				
				while(packet = Env.getInstance().popMsgBuffer(packet.from)){
					trace(packet.from.toString());
					MsgWindowManager.getInstance().appendMsg(config,packet);
				}
			}else{
				//NotifyManager.getInstance().newNotify(packet.from,Notify.TYPE_MSG,packet.body);
				addMsgIndicator(packet.from);
			}
		}
		
		//handle IQ packet received
		private function onIQ(e:IQEvent):void{
			var packet:IQPacket = IQPacket(e.data);
			trace("IQPacket :",packet.content[0].name().uri);
			switch(packet.content[0].name().uri){
				//if the IQ packet received is roster list
				case "jabber:iq:roster":
					gotRoster(packet.content[0]);
					break;
			}
		}
		
		//handle roster list received
		private function gotRoster(pxml:XML):void{
			trace("got roster");
			var arr:Vector.<RosterItem> = new Vector.<RosterItem>();
			var ns:Namespace = pxml.namespace();
			for each(var r:XML in pxml.ns::item){
				var j:JID = new JID(r.@jid);
				var i:RosterItem = new RosterItem(j);
				i.group = r.ns::group.toString();
				if(r.@name == null){
					i.nick = j.node;
				}else{
					i.nick = r.@name;
				}
				i.show = "offline";
				arr.push(i);
			}
			//add roster item into Env
			Env.getInstance().fillRoster(arr);
		}
		
		//handle presence packet
		private function onPresence(e:PresenceEvent):void {
			//trace("PRESENCE PACKET:", e.data.from.valueOf(), "TYPE:", e.data.type, "SHOW:", e.data.show);
			if (e.data.from.node != '' && e.data.from.node != null) {
				var packet:PresencePacket = PresencePacket(e.data);
				switch (packet.type) {
					case PresencePacket.TYPE_SUBSCRIBE :						
					case PresencePacket.TYPE_SUBSCRIBED :
					case PresencePacket.TYPE_UNSUBSCRIBED :
						onSubscribe(packet, packet.type);
						break;
						
					default:
						onShowPresence(packet);
						break;
				}
			}
		}
		
		private function onSubscribe(p:PresencePacket, type:String):void {
			UtilWindowManager.getInstance().forwardData(type, JID(p.from).toString());
			if (type == PresencePacket.TYPE_SUBSCRIBED) {
				XMPPStream.getInstance().handleSubReq(JID(p.from), true);
			}
			
			if (type == PresencePacket.TYPE_UNSUBSCRIBED) {
				XMPPStream.getInstance().handleSubReq(JID(p.from), false);
			}
		}
		
		private function onApproveSubscribe(e:UtilWinMgrEvent):void {
			XMPPStream.getInstance().handleSubReq(new JID(e.data.uid), true, e.data.group);
		};
		
		private function onDenySubscribe(e:UtilWinMgrEvent):void {
			XMPPStream.getInstance().handleSubReq(new JID(e.data.uid), false);
		};
		
		private function onUnsubscribe(e:UtilWinMgrEvent):void {
			XMPPStream.getInstance().unsubscribe(new JID(e.data.uid));
		};
		
		private function onShowPresence(packet:PresencePacket):void{
			trace("ON SHOW PRESENCE", packet.toXMLString());
			if (PresencePacket(packet).type == "unavailable") {
				PresencePacket(packet).show = "offline";
			} else {
				//trace(packet.show == undefined);
				//trace(packet.show);
				switch (PresencePacket(packet).show) {
					case "xa":
						PresencePacket(packet).show = "away";
						break;
						
					case "dnd":
						break;
						
					default:
						PresencePacket(packet).show = "online";
						break;
				}
			}
				
			//update roster status
			Env.getInstance().pushPresenceBuffer(PresencePacket(packet));
			//NotifyManager.getInstance().newNotify(packet.from,Notify.TYPE_SHOW,packet.show);
		}
		
		//handle roster updated event.this only occur when roster list is updated and sort
		private function onRosterUpdated(e:RosterUpdateEvent):void{
			//update display order of items in contact list in main window
			_mainWindow.updateLayout(Env.getInstance().roster[e.pos]);
		}
		
		private function onAvatarUpdated(e:Event):void{
			if(_profileInited){
				_mainWindow.updateProfile(
					Env.getInstance().myProfile.user.node,
					Env.getInstance().myProfile.show,
					Env.getInstance().myProfile.status,
					Env.getInstance().myProfile.avatar
					);
			}
		}
		
		//restore trayicon menu while msg buffer in Env is clean
		private function onMsgBufferClean(e:Event):void{
			
		}
		
		private function onLoginWinClose(e:Event):void{
			if(!_logined){
				NativeApplication.nativeApplication.exit();
			}else{
				if(!_mainWindow.active){
					NativeApplication.nativeApplication.exit();
				}
			}
		}
		
		private function onMainWinClose(e:Event):void{
			trace("CLOSE MAIN WINDOW");
			//_mainWindow.stage.nativeWindow.minimize();
			//NativeApplication.nativeApplication.exit();
		}
		
		private function onProfileBlockInited(e:Event):void{
			_profileInited = true;
			trace("profile inited");
			_mainWindow.updateProfile(
					Env.getInstance().myProfile.user.node,
					Env.getInstance().myProfile.show,
					Env.getInstance().myProfile.status,
					Env.getInstance().myProfile.avatar
					);
		}
		
		private function onStateChanged(e:ChangeStateEvent):void{
			switch(e.show){
				case "online":
					XMPPStream.getInstance().setOnline(e.status);
					break;
				case "busy":
					XMPPStream.getInstance().setBusy(e.status);
					break;
				case "away":
					XMPPStream.getInstance().setAway(e.status);
					break;
			}
			
			if(e.show == "busy"){
				e.show = "dnd";
			}
			
			Env.getInstance().myProfile.show = e.show;
			Env.getInstance().myProfile.status = e.status;
			_mainWindow.updateState(Env.getInstance().myProfile.show,Env.getInstance().myProfile.status);
			if(Env.getInstance().remember){
				
				LocalStroage.getInstance().storeUserProfile(Env.getInstance().myProfile);
			}else{
				LocalStroage.getInstance().clearUserProfile();
			}
		}
		
		//pop up msg window when notify window is clicked
		private function onNotifyClicked(e:NotifyManagerEvent):void{
			trace("notify clicked:",e.wtype);
			switch(e.wtype){
				case NotifyEvent.TYPE_MSG:
					var packet:MessagePacket;
					var config:MsgWindowConfig = new MsgWindowConfig(Env.getInstance().getRosterItemByJID(e.from));
					//get the position that will be remove after the msg window show up
					//var p:NativeMenuItem = _iconMenu.getItemByName(Env.getInstance().getRosterItemByJID(e.from).nick);
					for (var i:int = 0;i<_iconMenu.numItems;i++){
						if(_iconMenu.getItemAt(i).label == Env.getInstance().getRosterItemByJID(e.from).nick){
							break;
						}
					}
					//create a new msg window to show the incoming msg
					MsgWindowManager.getInstance().newMsgWindow(config);
					while(packet = Env.getInstance().popMsgBuffer(e.from)){
						MsgWindowManager.getInstance().appendMsg(config,packet);
					}
					_iconMenu.removeItemAt(i);
					if(_iconMenu.numItems == 1){
						_iconMenu.getItemAt(0).enabled = true;
						clearInterval(_i);
						_flashing = false;
						NativeApplication.nativeApplication.icon.bitmaps = _lightIcon.bitmaps;
						_iconState = "normal";
					}
					break;
				case NotifyEvent.TYPE_SHOW:
					break;
			}
			
		}
		
		//show up new msg window with chat log panel blank
		private function openNewMsgWin(e:ContactListEvent):void{
			var r:RosterItem = RosterGroup(Env.getInstance().getRosterGroupObjByName(e.group)).getRosterItemAt(e.index);
			var config:MsgWindowConfig = new MsgWindowConfig(r);
			MsgWindowManager.getInstance().newMsgWindow(config);
		}
		
		private function onTyping(e:TypingEvent):void{
			var config:MsgWindowConfig = new MsgWindowConfig(Env.getInstance().getRosterItemByJID(e.jid));
			switch (e.type){
				case TypingEvent.TYPING:
					MsgWindowManager.getInstance().guestTyping(config,true);
					break;
				case TypingEvent.PAUSED:
					MsgWindowManager.getInstance().guestTyping(config,false);
					break;
			}
		}
		
		private function isTyping(e:MsgWinManagerEvent):void{
			XMPPStream.getInstance().typingTo(e.to.clone());
		}
		
		//change the online status to away when user is idle
		private function onUserIdle(e:Event):void {
			if(Env.getInstance().myProfile.show == "online"){
				XMPPStream.getInstance().setAway(Env.getInstance().myProfile.status);
				_mainWindow.updateState(Env.getInstance().myProfile.show,Env.getInstance().myProfile.status);
			
			}
		}
		
		//change the online status to online when user is present
		private function onUserPresence(e:Event):void {
			if(Env.getInstance().myProfile.show == "away"){
				XMPPStream.getInstance().setOnline(Env.getInstance().myProfile.status);
				_mainWindow.updateState(Env.getInstance().myProfile.show,Env.getInstance().myProfile.status);
			}
		}
		
		//use XMPPStream to send msg packet containing in the request(event) from msgWindowManager
		private function sendMsg(e:MsgWinManagerEvent):void{
			XMPPStream.getInstance().newMessage(e.to,e.msg);
		}
		
		//init trayicon
		private function initIcon():void{
			NativeApplication.nativeApplication.icon.addEventListener(MouseEvent.CLICK,onIconClick);
			
			
			_darkIcon = new DarkIcon();
			_darkIcon.addEventListener(Event.COMPLETE,function():void{
				_iconState = "dark";
				_flashing = false;
				NativeApplication.nativeApplication.icon.bitmaps = _darkIcon.bitmaps;
			});
			_darkIcon.loadImages();
			
			_lightIcon = new LightIcon();
			_lightIcon.loadImages();
			
			_iconMenu = new NativeMenu();
			
			if(NativeApplication.supportsSystemTrayIcon){
				_sysTray= NativeApplication.nativeApplication.icon as SystemTrayIcon;
				_sysTray.tooltip = "NUT";
				var exitCommand:NativeMenuItem = 
					_iconMenu.addItem(new NativeMenuItem("Exit"));
				exitCommand.addEventListener(Event.SELECT,function(event:Event):void{
					NativeApplication.nativeApplication.exit();
				});
				_sysTray.menu = _iconMenu;
			}
			if(NativeApplication.supportsDockIcon){
				DockIcon(NativeApplication.nativeApplication.icon).menu = _iconMenu;
			}
		}
		
		//add unread msg item to trayicon menu
		public function addMsgIndicator(r:JID):void{
			flashTrayIcon();
			_iconMenu.getItemAt(_iconMenu.numItems - 1).enabled = false;
			var i:NativeMenuItem = new NativeMenuItem(r.node);
			//associate the menuitem with specified roster
			i.data = r.clone();
			var pos:int = -1;
			for (var j:int = 0;j<_iconMenu.numItems;j++){
				if(_iconMenu.getItemAt(j).label == i.label){
					pos = j;
					break;
				}
			}
			//add item i to trayicon menu if it did not exist
			if(pos < 0){
				_iconMenu.addItemAt(i,0);
				trace(_iconMenu.numItems);
				_iconMenu.getItemAt(0).addEventListener(Event.SELECT,onIconMsgClicked);
			}
			//get the unread msg count of a specified roster item
			//var msgNum:int = Env.getInstance().getMsgCountByRoster(r.uid);
				
			//todo:display the unread msg count from specified roster item
			//}
		}
		
		//when menu item of unread msg in trayicon menu is clicked.compare to function onNotifyClicked
		private function onIconMsgClicked(e:Event):void{
			var packet:MessagePacket;
			var menuitem:NativeMenuItem = NativeMenuItem(e.target);
			var config:MsgWindowConfig = new MsgWindowConfig(Env.getInstance().getRosterItemByJID(JID(menuitem.data)));
			for (var i:int = 0;i<_iconMenu.numItems;i++){
				if(_iconMenu.getItemAt(i).label == e.target.label){
					break;
				}
			}
			MsgWindowManager.getInstance().newMsgWindow(config);
			
			while(packet = Env.getInstance().popMsgBuffer(JID(menuitem.data))){
				MsgWindowManager.getInstance().appendMsg(config,packet);
			}
			_iconMenu.removeItemAt(i);
			if(_iconMenu.numItems == 1){
				_iconMenu.getItemAt(0).enabled = true;
				clearInterval(_i);
				_flashing = false;
				NativeApplication.nativeApplication.icon.bitmaps = _lightIcon.bitmaps;
				//_iconState = "dark";
			}
		}
		
		private function onIconClick(e:MouseEvent):void{
			if(_loginWindow.closed){
				if(Env.getInstance().msgBufferLength > 0){
					var p:MessagePacket = Env.getInstance().popMsgBufferTail();
					var config:MsgWindowConfig = new MsgWindowConfig(Env.getInstance().getRosterItemByJID(p.from));
					MsgWindowManager.getInstance().newMsgWindow(config);
					MsgWindowManager.getInstance().appendMsg(config,p);
					while(p = Env.getInstance().popMsgBuffer(p.from)){
						MsgWindowManager.getInstance().appendMsg(config,p);
					}
					_iconMenu.removeItemAt(0);
					if(_iconMenu.numItems == 1){
						_iconMenu.getItemAt(0).enabled = true;
						clearInterval(_i);
						_flashing = false;
						NativeApplication.nativeApplication.icon.bitmaps = _lightIcon.bitmaps;
						_iconState = "light";
					}
				}else{
					_mainWindow.activate();
				}
			}else{
				_loginWindow.activate();
			}
		}
		
		private function flashTrayIcon():void{
			if(!_flashing){
				_i = setInterval(changeIcon,500);
			}
			_flashing = true;
		}
		
		private function changeIcon():void{
			switch(_iconState){
				case "light":
					NativeApplication.nativeApplication.icon.bitmaps = _darkIcon.bitmaps;
					_iconState = "dark";
					break;
				case "dark":
					NativeApplication.nativeApplication.icon.bitmaps = _lightIcon.bitmaps;
					_iconState = "light";
					break;
			}
		}
		
	}
}