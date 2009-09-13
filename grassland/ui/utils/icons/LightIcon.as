package grassland.ui.utils.icons {
    import flash.desktop.Icon;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.net.URLRequest;
      
    public class LightIcon extends Icon{		
		private var imageURLs:Array = ['images/icons/light16x16.png'];
										
        public function LightIcon():void{
            super();
            bitmaps = new Array();
        }
        
        public function loadImages(event:Event = null):void{
        	if(event != null){
        		bitmaps.push(event.target.content.bitmapData);
        	}
        	if(imageURLs.length > 0){
        		var urlString:String = imageURLs.pop();
        		var loader:Loader = new Loader();
        		loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadImages,false,0,true);
				loader.load(new URLRequest(urlString));
        	} else {
        		var complete:Event = new Event(Event.COMPLETE,false,false);
        		dispatchEvent(complete);
        	}
        }
    }
}