/*
 * A simple "Hello, World" example that demonstrates use of an
 * application-modal dialog to prompt for the user's name and
 * echo it in a greeting.
 * 
 * If you're having trouble compiling, follow the steps at
 * http://blog.formatlos.de/2010/12/13/playbook-development-with-fdt-and-ant/
 */
package {
	import model.Platform;
	import flash.display.StageAlign;

	import flash.display.StageScaleMode;
	import flash.display.StageQuality;
	import model.Data;
	import flash.display.Sprite;


	[SWF(heightPercent="100%", widthPercent="100%", frameRate="60", backgroundColor="#010101")]
	public class WagErgApplePhone extends Sprite
	{
		public function WagErgApplePhone(){
			//no anti aliasing suit required
			stage.quality=StageQuality.LOW;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			Data.platform=Platform.IOS;
			Data.touchScreen=true;
			var main:Main = new Main();
			addChild(main);
		}
		
	}
}