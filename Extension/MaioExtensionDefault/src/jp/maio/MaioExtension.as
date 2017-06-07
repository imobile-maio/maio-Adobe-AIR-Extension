package jp.maio
{
	
	public class MaioExtension
	{
		private static var _instance:MaioExtension;
		private static var _listener: Object;
		
		// =============================================================================
		// private
		// =============================================================================
		
		/**
		 * Returns a singleton of MaioExtension.
		 * Ensures only one ExtensionContext instance is created.
		 */
		private static function get instance(): MaioExtension
		{
			if(!_instance)
			{
				_instance = new MaioExtension(new SingletonEnforcer());
			}
			
			return _instance;
		}
		
		private function init(): void
		{
			
		}
		
		// enforcer is used to force a singleton. SingletonEnforcer is private.
		public function MaioExtension(enforcer:SingletonEnforcer){}
		
		// =============================================================================
		// public
		// =============================================================================
		
		public static function getSdkVersion():String { return "default"; }
		
		public static function setAdTestMode(isAdTestMode:Boolean):void{}
		
		public static function start(mediaId:String, listener:Object):void{}
		
		public static function canShow(zoneId:String = ""):Boolean {return false;}
		
		public static function show(zoneId:String = ""):void{}
		
		public static function setListener(listener:Object):void{}
		
		public static function removeListener():void{}
		
	}
}

class SingletonEnforcer {}