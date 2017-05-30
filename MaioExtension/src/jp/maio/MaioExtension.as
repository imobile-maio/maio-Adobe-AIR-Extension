package jp.maio
{
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
	public class MaioExtension
	{
		private static var _instance:MaioExtension;
		private static var _listener: IMaioListener;
		private var _context: ExtensionContext;
		
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
		public function MaioExtension(enforcer:SingletonEnforcer)
		{
			_context = ExtensionContext.createExtensionContext("jp.maio", "");
			if(!_context)
			{
				throw new Error("air: context initialize error");
			}
			_context.addEventListener(StatusEvent.STATUS, onStatusChanged);
		}
		
		private function onStatusChanged(event:StatusEvent):void
		{
			// StatusEvent has two properties: code/level
			// in this extension,
			//      code: event name
			//     level: data
			var funcName:String = event.code;
			var args:Array;
			var zoneId:String;
			switch(funcName)
			{
				case "onInitialized":
					onInitialized();
					break;
				case "onChangedCanShow":
					args = getArgs(event);
					onChangedCanShow(args[0], Boolean(args[1]));
					break;
				case "onStartAd":
					onStartAd(event.code);
					break;
				case "onFinishedAd":
					args = getArgs(event);
					zoneId = args[0];
					var playtime:int = int(args[1]);
					var skipped:Boolean = Boolean(args[2]);
					var rewardParam:String = args[3];
					onFinishedAd(zoneId, playtime, skipped, rewardParam);
					break;
				case "onClickedAd":
					onClickedAd(event.code);
					break;
				case "onFailed":
					args = getArgs(event);
					zoneId = args[0];
					var reason:String = args[1];
					onFailed(zoneId, reason);
					break;
				default:
					trace("unexpected status");
					break;
			}
		}
		
		private static function getArgs(event:StatusEvent): Array
		{
			return event.level.split(":");
		}
		
		// =============================================================================
		// public
		// =============================================================================
		
		public static function getSdkVersion():String
		{
			trace("getSdkVersion");
			var result:String = instance._context.call("generalFunction", "getSdkVersion") as String;
			return result;
		}
		
		public static function setAdTestMode(isAdTestMode:Boolean):void
		{
			instance._context.call("generalFunction", "setAdTestMode", isAdTestMode);
		}
		
		public static function start(mediaId:String, listener:IMaioListener):void
		{
			_listener = listener;
			instance._context.call("generalFunction", "start", mediaId);
		}
		
		public static function canShow(zoneId:String = ""):Boolean
		{
			var result:Boolean = false;
			if(zoneId == "")
			{
				result = instance._context.call("generalFunction", "canShow");	
			}
			else
			{
				result = instance._context.call("generalFunction", "canShow", zoneId);
			}
			return result;
		}
		
		public static function show(zoneId:String = ""):void
		{
			if(zoneId == "")
			{
				instance._context.call("generalFunction", "show");
			}
			else
			{
				instance._context.call("generalFunction", "show", zoneId);
			}
		}
		
		public static function setListener(listener:IMaioListener):void
		{
			_listener = listener;
		}
		
		public static function removeListener():void
		{
			_listener = null;
		}
		
		// =============================================================================
		// events
		// =============================================================================
		
		internal static function onInitialized():void
		{
			if(!_listener) return;
			_listener.onInitialized();
		}
		
		internal static function onChangedCanShow(mediaId:String, newValue:Boolean):void
		{
			if(!_listener) return;
			_listener.onChangedCanShow(mediaId, newValue);
		}
		
		internal static function onStartAd(zoneId:String):void
		{
			if(!_listener) return;
			_listener.onStartAd(zoneId);
		}
		
		internal function onFinishedAd(zoneId:String, playtime:int, skipped:Boolean, rewardParam:String):void
		{
			if(!_listener) return;
			_listener.onFinishedAd(zoneId, playtime, skipped, rewardParam);
		}
		
		internal function onClickedAd(zoneId:String):void
		{
			if(!_listener) return;
			_listener.onClickedAd(zoneId);
		}
		
		internal function onFailed(zoneId:String, reason:int):void
		{
			if(!_listener) return;
			_listener.onFailed(zoneId, reason);
		}
		
	}
}

class SingletonEnforcer {}