/*
 * A simple "Hello, World" example that demonstrates use of an
 * application-modal dialog to prompt for the user's name and
 * echo it in a greeting.
 * 
 * If you're having trouble compiling, follow the steps at
 * http://blog.formatlos.de/2010/12/13/playbook-development-with-fdt-and-ant/
 */
package {
	import flash.display.StageQuality;
	import model.Data;
	import flash.display.Sprite;
	import flash.events.Event;

	[SWF(height="600", width="1024", frameRate="64", scriptTimeLimit='255', backgroundColor="#010101")]
	public class WagErgWeb extends Sprite
	{
		public function WagErgWeb(){
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);			
		}
		
		private function init(e:Event=null):void{
			//no anti aliasing suit required
			stage.quality=StageQuality.LOW;
			
			var main:Main = new Main();
			addChild(main);
			Data.touchScreen=false;
		}

		
	}
}