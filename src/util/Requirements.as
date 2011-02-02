package util
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;

	public class Requirements
	{
		public static const DEFAULT_CONFIG:String = "util/requirements.xml";
		
		public var bbb_apps_url:String;
		public var bbb_voice_url:String;
		public var bbb_video_url:String;
		public var flash_required_version:String;
		public var java_required_version:String;
		
		private var loader:URLLoader;
		
		private var parseCompleteCallback:Function;
		
		public function Requirements(parseCompleteCallback:Function)
		{
			this.parseCompleteCallback = parseCompleteCallback;
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, handleFileLoaded);
			
			var request:URLRequest = new URLRequest(DEFAULT_CONFIG);
			request.method = URLRequestMethod.GET;
			loader.load(request);
		}
		
		private function handleFileLoaded(e:Event):void{
			var xml:XML = new XML(e.target.data);
			trace(xml);
			
			bbb_apps_url = xml.bigbluebutton_apps.@url;
			bbb_video_url = xml.bigbluebutton_video.@url;
			bbb_voice_url = xml.bigbluebutton_voice.@url;
			
			flash_required_version = xml.flash.@version;
			java_required_version = xml.java.@version;
			
			parseCompleteCallback();
		}
	}
}