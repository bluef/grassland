package grassland.core {
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.data.EncryptedLocalStore;
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.data.SQLResult;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.events.EventDispatcher;
	import grassland.core.utils.UserProfile;
	
	public class LocalStroage extends EventDispatcher {
		
		private const ROW_PER_PAGE:uint = 20;
		private static var _instance:LocalStroage;
		private var _docPath:File;
		private var _appPath:File;
		private var _dbFile:File;
		private var _conn:SQLConnection;
		private var _stmt:SQLStatement;
		private var _inited:Boolean;
		
		public function LocalStroage(singletonEnforcer:SingletonEnforcer){
			_inited = false;
			_docPath = File.documentsDirectory.resolvePath("NUT");
			_docPath.createDirectory();
			
			//_appPath = File.applicationDirectory;
			//_appPath.resolvePath("plugins").createDirectory();
		}
		
		public static function getInstance():LocalStroage{
			if(LocalStroage._instance == null){
				LocalStroage._instance = new LocalStroage(new SingletonEnforcer());
			}
			return LocalStroage._instance;
		}
		
		public function storeUserProfile(u:UserProfile):void{
			var ba:ByteArray = new ByteArray();
			//ba.writeUTFBytes(u.user.valueOf()+","+u.password+","+u.show+","+u.status);
			ba.writeObject({user:u.user.node,pw:u.password,show:u.show,status:u.status});
			trace("stroed:",u.show);
			//ba.writeObject(u.clone());
			EncryptedLocalStore.setItem("UserProfile", ba);
		}
		
		public function retriveUserProfile():UserProfile{
			var s:String;
			var u:UserProfile;
			var ba:ByteArray = EncryptedLocalStore.getItem("UserProfile");
			if(ba != null){
				ba.position = 0;
				var o:Object = ba.readObject();
				/*var p:RegExp = /(.+?),(.+?),(.+?),(.+)/i;
				var o:Object = p.exec(s);
				u = new UserProfile(o[1],o[2]);
				u.show = o[3];
				trace("get:",u.show);
				u.status = o[4];
				*/
				u = new UserProfile(o.user,o.pw);
				u.show = o.show;
				trace("get:",u.show);
				u.status = o.status;
				return u;
			}else{
				return null;
			}
			
		}
		
		public function clearUserProfile():void{
			EncryptedLocalStore.reset();
		}
		
		private function onSQLConnect(e:SQLEvent):void{
			initSQL();
		}
		
		private function execSQL(s:String,... args):void{
			var stmt:SQLStatement = new SQLStatement();
			var i:int = 0;
			stmt.sqlConnection = _conn;
			stmt.text = s;
			if(args.length > 0){
				while(i <= args.length){
					stmt.parameters[i] = args[i];
					i++;
				}
			}
			stmt.execute();
		}
		
		private function initSQL():void{ 
			_dbFile = _docPath.resolvePath("chatLog.nut");
			_conn = new SQLConnection();
			_conn.addEventListener(SQLEvent.OPEN,onSQLConnect);
			_conn.open(_dbFile);
			
			var sql:String =  
				"CREATE TABLE IF NOT EXISTS chatlog (" +  
				"    ID INTEGER PRIMARY KEY AUTOINCREMENT, " +  
				"    username TEXT, " +  
				"    time DATE, " +  
				"    content TEXT" +  
				")"; 
			_stmt = new SQLStatement();
			_stmt.sqlConnection = _conn;
			_stmt.text = sql;
			_stmt.addEventListener(SQLEvent.RESULT,onInit);
			_stmt.execute();

		}
		
		private function onInit(e:SQLEvent):void{
			_stmt.removeEventListener(SQLEvent.RESULT,onInit);
			_inited = true;
		}
		
		private function insertLog(username:String,content:String):void{
			var t:Date = new Date();
			var sql:String =
				"INSERT INTO chatlog (" +
				"	username," +
				"	time," +
				"	content )" +
				"VALUES" +
				"(?,?)";
			execSQL(sql,username,t,content);
		}
		
		private function showLog(p:uint):void{
			var sql:String = 
				"SELECT * FROM chatlog ORDER BY ID DESC LIMIT "+(p-1)*ROW_PER_PAGE+","+ROW_PER_PAGE;
			_stmt = new SQLStatement();
			_stmt.sqlConnection = _conn;
			_stmt.text = sql;
			_stmt.addEventListener(SQLEvent.RESULT,onResult);
			_stmt.execute();
		}
		
		private function onResult(e:SQLEvent):void{
			var result:SQLResult = _stmt.getResult();
			var numRows:int = result.data.length;
			for(var i:uint = 0;i<numRows;i++){
				for (var columnName:String in result.data[i]){
					trace(columnName+":"+result.data[i][columnName]);
				}
			}
			_stmt.removeEventListener(SQLEvent.RESULT,onResult);
		}
		
		/*
		public function installPlugin(p:Plugin,ba:ByteArray):void{
			var f:File = _appPath.resolvePath("plugins").resolvePath(p.filename);
			var fs:FileStream = new FileStream();
			fs.open(f,FileMode.WRITE);
			fs.writeBytes(ba,0,ba.length);
		}
		*/
		
		public function existSettingFile():Boolean{
			var s:Boolean;
			_appPath.resolvePath("Setting.cfg").exists ? s = true : s = false;
			return s;
		}
		
		public function createSettingFile():void{
			var f:File = _appPath.resolvePath("Setting.cfg");
			var fs:FileStream = new FileStream();
			fs.open(f,FileMode.WRITE);
			fs.writeUTFBytes(" ");
		}
		
		/*
		public function loadSettingFile():XML{
			
		}
		*/
		
	}
}

class SingletonEnforcer {}