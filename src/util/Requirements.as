package util
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	
	import mx.collections.ArrayCollection;

	public class Requirements
	{
		public static const DEFAULT_CONFIG:String = "resources/requirements.xml";
		
		public static var bbb_apps_url:String;
		public static var bbb_voice_url:String;
		public static var bbb_video_url:String;
		public static var bbb_deskshare_url:String;
		public static var flash_required_version:String;
		public static var java_required_version:String;
		
		private static var loader:URLLoader;
		private static var isLoaded:Boolean = false;
		private static var loadingStarted:Boolean = false;
		private static var pendingCallbacks:ArrayCollection = new ArrayCollection();
		
		/**
		 * Will call the parseCompleteCallback function once the requirements are available.
		 */
		public static function loadRequirements(parseCompleteCallback:Function):void{
			//First time called? If yes, procedd. If no, call callback, which can use the cached version.
			if (isLoaded) {
				parseCompleteCallback();
				return;
			}
			
			//Add callback. When requirements are done loading the callback will be called.
			Requirements.pendingCallbacks.addItem(parseCompleteCallback);
			//If we already started loading the file, just return. There's no reason to load the file twice. The callback will be called.
			if (loadingStarted) return;
			//Load the requirements magic happens here
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, handleFileLoaded);
			var request:URLRequest = new URLRequest(DEFAULT_CONFIG);
			request.method = URLRequestMethod.GET;
			loader.load(request);
			//Set the flag so that subsequent calls to loadRequirements don't load the file again. Asynchronous goodness..
			loadingStarted = true;
		}
		
		private static function handleFileLoaded(e:Event):void{
			isLoaded = true;
			
			var xml:XML = new XML(e.target.data);
			trace(xml);
			
			bbb_apps_url = xml.bigbluebutton_apps.@url;
			bbb_video_url = xml.bigbluebutton_video.@url;
			bbb_voice_url = xml.bigbluebutton_voice.@url;
			bbb_deskshare_url = xml.bigbluebutton_deskshare.@url;
			
			flash_required_version = xml.flash.@version;
			java_required_version = xml.java.@version;
			
			callPendingCallbacks();
		}
		
		private static function callPendingCallbacks():void{
			for each (var callback:Function in pendingCallbacks){
				callback();
			}
		}
	}
}