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

	public class VIdeoConnector
	{
		public static const CONNECT_SUCCESS:String = "NetConnection.Connect.Success";
		public static const CONNECT_FAILED:String = "NetConnection.Connect.Failed";
		public static const CONNECT_CLOSED:String = "NetConnection.Connect.Closed";
		public static const INVALID_APP:String = "NetConnection.Connect.InvalidApp";
		public static const APP_SHUTDOWN:String = "NetConnection.Connect.AppShutDown";
		public static const CONNECT_REJECTED:String = "NetConnection.Connect.Rejected";
		
		public static const VIDEO_APP:String = "rtmp://ec2-184-73-150-80.compute-1.amazonaws.com/video";
		
		private var connection:NetConnection;
		private var outgoingStream:NetStream;
		private var incomingStream:NetStream;
		
		private var camera:Camera;
		
		public function VIdeoConnector(camera:Camera)
		{
			this.camera = camera;
			
			connection = new NetConnection();
			connection.client = this;
			connection.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			connection.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			connection.connect(VIDEO_APP);
		}
		
		private function onNetStatus(e:NetStatusEvent):void{
			switch(e.info.code){
				case CONNECT_SUCCESS:
					connectVideo();
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
		
		private function connectVideo():void{
			outgoingStream = new NetStream(connection);
			outgoingStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			
			outgoingStream.attachCamera(camera);
			outgoingStream.publish("testStream");
		}
		
		public function changeCamera(camera:Camera):void{
			this.camera = camera;
			outgoingStream.attachCamera(camera);
		}
	}
}