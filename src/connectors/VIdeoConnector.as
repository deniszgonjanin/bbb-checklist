package connectors
{
	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import util.Requirements;

	public class VideoConnector
	{
		public static const CONNECT_SUCCESS:String = "NetConnection.Connect.Success";
		public static const CONNECT_FAILED:String = "NetConnection.Connect.Failed";
		public static const CONNECT_CLOSED:String = "NetConnection.Connect.Closed";
		public static const INVALID_APP:String = "NetConnection.Connect.InvalidApp";
		public static const APP_SHUTDOWN:String = "NetConnection.Connect.AppShutDown";
		public static const CONNECT_REJECTED:String = "NetConnection.Connect.Rejected";
		public static const NETSTREAM_PUBLISH:String = "NetStream.Publish.Start";
				
		public var connection:NetConnection;
		private var outgoingStream:NetStream;
		private var incomingStream:NetStream;
		
		private var camera:Camera;
		private var streamListener:Function;
		
		public function VideoConnector(connectionListener:Function)
		{	
			connection = new NetConnection();
			connection.client = this;
			connection.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			connection.addEventListener(NetStatusEvent.NET_STATUS, connectionListener);
			connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			connection.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			Requirements.loadRequirements(connectToServer);
		}
		
		public function connectToServer():void{
			connection.connect(Requirements.bbb_video_url);
		}
		
		private function onNetStatus(e:NetStatusEvent):void{
			switch(e.info.code){
				case CONNECT_SUCCESS:
					//connectVideo();
					break;
				case CONNECT_FAILED:
					trace("VideoConnector::onNetStatus - connection to Video App failed");
					break;
				case CONNECT_CLOSED:
					trace("VideoConnector::onNetStatus - connection to Video App closed");
					break;
				case CONNECT_REJECTED:
					trace("VideoConnector::onNetStatus - connection to Video App rejected");
					break;
				case NETSTREAM_PUBLISH:
					
					break;
				default:
					trace("VideoConnector::onNetStatus - something else happened: " + e.info.code);
					break;
			}
		}
		
		private function onAsyncError(e:AsyncErrorEvent):void{
			trace("VideoConnector::onAsyncError - an async error occured on the video connection");
		}
		
		private function onSecurityError(e:SecurityErrorEvent):void{
			trace("VideoConnector::onSecurityError - a security error occured on the video connection");
		}
		
		private function onIOError(e:IOErrorEvent):void{
			trace("VideoConnector::onIOError - an IO error occured on the video connection");
		}
		
		public function connectVideo(camera:Camera, streamListener:Function):void{
			outgoingStream = new NetStream(connection);
			outgoingStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			outgoingStream.addEventListener(NetStatusEvent.NET_STATUS, streamListener);
			
			outgoingStream.attachCamera(camera);
			outgoingStream.publish("testStream");
		}
		
		public function changeCamera(camera:Camera):void{
			this.camera = camera;
			outgoingStream.attachCamera(camera);
		}
	}
}