package {
	import model.Platform;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.StageQuality;
	import flash.events.Event;

	import model.Data;
	/**
	 * @author frankw
	 */
	[SWF(heightPercent="100%", widthPercent="100%", frameRate="32", backgroundColor="#010101")]
	public class WagErgAndroidPhone extends Sprite {
		public function WagErgAndroidPhone(){
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);			
		}
		
		private function init(e:Event=null):void{
			//no anti aliasing suit required
			stage.quality=StageQuality.LOW;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			Data.platform=Platform.ANDROID;
			Data.touchScreen=true;
			var main:Main = new Main();
			addChild(main);
		}
	}
}
