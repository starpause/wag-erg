/*
 * A simple "Hello, World" example that demonstrates use of an
 * application-modal dialog to prompt for the user's name and
 * echo it in a greeting.
 * 
 * If you're having trouble compiling, follow the steps at
 * http://blog.formatlos.de/2010/12/13/playbook-development-with-fdt-and-ant/
 */
package {
	import model.Data;
	import flash.display.Sprite;
	import flash.events.Event;

	[SWF(height="320", width="480", frameRate="40", backgroundColor="#010101")]
	public class WagErgApplePhone extends Sprite
	{		
		public function WagErgApplePhone(){
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);			
		}
		
		private function init(e:Event=null):void{
			Data.touchScreen=true;
			Data.fontSize=20;
			var main:Main = new Main();
			addChild(main);
		}

		
	}
}