package jp.maio
{
	public class IMaioListener
	{
		public function onInitialized():void {}
		public function onChangedCanShow(mediaId:String, newValue:Boolean):void {}
		public function onStartAd(zoneId:String):void {}
		public function onFinishedAd(zoneId:String, playtime:int, skipped:Boolean, rewardParam:String):void {}
		public function onClickedAd(zoneId:String):void {}
		public function onFailed(zoneId:String, reason:String):void {}
	}
}