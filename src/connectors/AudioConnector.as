package connectors
{
	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Microphone;
	import flash.media.SoundCodec;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import mx.controls.Alert;
	
	public class AudioConnector
	{
		public static const CONNECT_SUCCESS:String = "NetConnection.Connect.Success";
		public static const CONNECT_FAILED:String = "NetConnection.Connect.Failed";
		public static const CONNECT_CLOSED:String = "NetConnection.Connect.Closed";
		public static const INVALID_APP:String = "NetConnection.Connect.InvalidApp";
		public static const APP_SHUTDOWN:String = "NetConnection.Connect.AppShutDown";
		public static const CONNECT_REJECTED:String = "NetConnection.Connect.Rejected";
		
		public static const AUDIO_APP:String = "rtmp://ec2-184-73-150-80.compute-1.amazonaws.com/video";
		
		private var audioCodec:String = "SPEEX";
		
		private var connection:NetConnection;
		private var outgoingStream:NetStream;
		private var incomingStream:NetStream;
		
		private var mic:Microphone;
		
		public function AudioConnector(mic:Microphone)
		{
			this.mic = mic;
			
			connection = new NetConnection();
			connection.client = this;
			connection.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			connection.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			connection.connect(AUDIO_APP);
		}
		
		private function onNetStatus(e:NetStatusEvent):void{
			switch(e.info.code){
				case CONNECT_SUCCESS:
					connectAudio();
					break;
				case CONNECT_FAILED:
					trace("AudioConnector::onNetStatus - connection to Audio App failed");
					break;
				case CONNECT_CLOSED:
					trace("AudioConnector::onNetStatus - connection to Audio App closed");
					break;
				case CONNECT_REJECTED:
					trace("AudioConnector::onNetStatus - connection to Audio App rejected");
					break;
				default:
					trace("AudioConnector::onNetStatus - something else happened: " + e.info.code);
					break;
			}
		}
		
		private function onAsyncError(e:AsyncErrorEvent):void{
			trace("AudioConnector::onAsyncError - an async error occured on the audio connection");
		}
		
		private function onSecurityError(e:SecurityErrorEvent):void{
			trace("AudioConnector::onSecurityError - a security error occured on the audio connection");
		}
		
		private function onIOError(e:IOErrorEvent):void{
			trace("AudioConnector::onIOError - an IO error occured on the audio connection");
		}
		
		private function connectAudio():void{
			outgoingStream = new NetStream(connection);
			outgoingStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			
			setupMicrophone();
			outgoingStream.attachAudio(mic);
			outgoingStream.publish("echoStream", "live");
		}
		
		public function changeMic(mic:Microphone):void{
			this.mic = mic;
			setupMicrophone();
			outgoingStream.attachAudio(mic);
		}
		
		private function setupMicrophone():void {
			mic.setUseEchoSuppression(true);
			//TODO Set loopBack to false once this is connected to the Asterisk/Freeswitch echo application
			mic.setLoopBack(true);
			mic.setSilenceLevel(0,20000);
			if (audioCodec == "SPEEX") {
				mic.encodeQuality = 6;
				mic.codec = SoundCodec.SPEEX;
				mic.framesPerPacket = 1;
				mic.rate = 16; 
			} else {
				mic.codec = SoundCodec.NELLYMOSER;
				mic.rate = 8;
			}			
			mic.gain = 60;			
		}
	}
}