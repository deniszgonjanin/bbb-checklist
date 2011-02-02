package checkers
{
	import flash.external.ExternalInterface;

	public class JavaCheck
	{
		public static function createWebStartLaunchButton(jnlp:String, minimumVersion:String):void{
			var response:Object = ExternalInterface.call("createWebStartLaunchButton", jnlp, minimumVersion);
			
			if (response == null) throw new Error("Javascript files not found.");
		}
		
		public static function createWebStartLaunchButtonEx(jnlp:String, minimumVersion:String):void{
			var response:Object = ExternalInterface.call("createWebStartLaunchButtonEx", jnlp, minimumVersion);
			
			if (response == null) throw new Error("Javascript files not found.");
		}
		
		public static function getBrowser():String{
			var browser:String = ExternalInterface.call("getBrowser");
			
			if (browser == null) throw new Error("Javascript files not found.");
			
			return browser;
		}
		
		public static function getJREs():Array{
			var installedJREs:Array = ExternalInterface.call("getJREs");
			
			if (installedJREs == null) throw new Error("Javascript files not found.");
			
			return installedJREs;
		}
		
		public static function installJRE(requestVersion:String):void{
			var response:Object = ExternalInterface.call("installJRE", requestVersion);
			
			if (response == null) throw new Error("Javascript files not found.");
		}
		
		public static function installLatestJRE():void{
			var response:Object = ExternalInterface.call("installLatestJRE");
			
			if (response == null) throw new Error("Javascript files not found.");
		}
		
		public static function isPlugin2():Boolean{
			var plugin2:Boolean = ExternalInterface.call("isPlugin2");
			
			if (plugin2 == null) throw new Error("Javascript files not found.");
			
			return plugin2;
		}
		
		public static function isWebStartInstalled(minimumVersion:String):void{
			var webstartInstalled:Boolean = ExternalInterface.call("isWebStartInstalled", minimumVersion);
			
			if (webstartInstalled == null) throw new Error("Javascript files not found.");
			
			return webstartInstalled;
		}
		
		public static function runApplet(attributes:Object, parameters:Object, minimumVersion:String):void{
			var response:Object = ExternalInterface.call("runApplet", attributes, parameters, minimumVersion);
			
			if (response == null) throw new Error("Javascript files not found.");
		}
		
		public static function setAdditionalPackages(packageList:Object):void{
			var response:Object = ExternalInterface.call("setAdditionalPackages", packageList);
			
			if (response == null) throw new Error("Javascript files not found.");
		}
		
		public static function setInstallerType(type:String):void{
			var response:Object = ExternalInterface.call("setInstallerType", type);
			
			if (response == null) throw new Error("Javascript files not found.");
		}
		
		public static function versionCheck(version:String):void{
			var version:String = ExternalInterface.call("versionCheck", version);
			
			if (version == null) throw new Error("Javascript files not found.");
			
			return version;
		}
		
		public static function writeAppletTag(attributes:Object, parameters:Object = null):void{
			var response:Object = ExternalInterface.call("writeAppletTag", attributes, parameters);
			
			if (response == null) throw new Error("Javascript files not found.");
		}
	}
}