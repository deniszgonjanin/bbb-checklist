package util
{
	import flash.net.SharedObject;

	public class PersistUserPreferences
	{
		private static var sharedObject:SharedObject = SharedObject.getLocal("userProperties", "/bigbluebutton/");
		
		public static function storeData(preference:String, data:String):void{
			sharedObject.data[preference] = data;
			try{
				sharedObject.flush(1000);
			} catch(err:Error){
				trace("Could not flush shared object");
			}
		}
	}
}