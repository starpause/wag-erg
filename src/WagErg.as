/*
 * A simple "Hello, World" example that demonstrates use of an
 * application-modal dialog to prompt for the user's name and
 * echo it in a greeting.
 * 
 * If you're having trouble compiling, follow the steps at
 * http://blog.formatlos.de/2010/12/13/playbook-development-with-fdt-and-ant/
 */
package {
	import flash.display.Shape;
	import com.junkbyte.console.Cc;
	import view.components.DrumHead;
	import qnx.dialog.DialogButtonProperty;
	import qnx.dialog.PromptDialog;
	import qnx.display.IowWindow;
	import qnx.ui.buttons.LabelButton;
	import qnx.ui.text.Label;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	[SWF(height="600", width="1024", frameRate="30", backgroundColor="#010101")]
	public class WagErg extends Sprite
	{
		private var helloLabel : Label;
		private var helloButton : LabelButton;
		private var nameDialog : PromptDialog;
		
		private var drums:Vector.<DrumHead> = new Vector.<DrumHead>();
		//private var baseParams:Object = new Object();
		//private var drumPads:Object = new Object();
		private var drumCounter:int = 0;
		
		//private var navWidth:Number;
		private var navHeight : Number;
		private var redrawDrumsCallback : Function;
		private var bgShape : Shape = new Shape;
		
		public function WagErg()
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			//???
			//new IowWindow();
		}
		
		private function init(e:Event=null):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			navHeight = stage.stageHeight/3;
			
			drawAddDrumButton();
			
			Cc.startOnStage(this, "");
			Cc.y = stage.stageHeight-Cc.height;
			Cc.x = (stage.stageWidth-Cc.width)/2;
			
			//drawDrum(0,0,stage.stageWidth-heightThird,heightThird,"one");
			//drawDrum(stage.stageWidth/2,0,stage.stageWidth-heightThird,heightThird,"two");
			
			stage.nativeWindow.visible = true;
		}

		private function drawAddDrumButton() : void {
			/* A button to request a greeting. */
			helloButton = new LabelButton();
			helloButton.label = "ADD SOUND";
			helloButton.x = (stage.stageWidth - helloButton.width)/2;
			helloButton.y = stage.stageHeight/2;
			/* A label in which to show the hello greeting. */
			helloLabel = new Label();
			helloLabel.width = helloButton.width;
			helloLabel.height = helloButton.height;
			helloLabel.x = (stage.stageWidth - helloLabel.width) / 2;
			helloLabel.y = helloButton.y - 60;
			var format : TextFormat = new TextFormat();
			format = new TextFormat();
			format.align = TextFormatAlign.CENTER;
			format.font = "Arial";
			format.color = 0x103f10;
			format.size = 24;
			helloLabel.format = format;
			addChild(helloLabel);
			/* Listen for a touch on the dialog. */
			helloButton.addEventListener(MouseEvent.CLICK, onAddDrum);
			addChild(helloButton);
		}

		private function onAddDrum(event : MouseEvent) : void {
			//if we're not at 12 seconds already

			//new instance
			drumCounter++;
			var tempName:String = "drum"+drumCounter.toString();
			var tempDrum:DrumHead = new DrumHead(tempName, navHeight);
			tempDrum.x = tempDrum.y = 0;
			drums.push(tempDrum);
			addChild(tempDrum);
			
			//re arange all the drums
			redrawDrums();
		}

		private function redrawDrums() : void {
			//start stacking left to right
			var lastX:Number = 0;
			
			//reserve a square in the right hand corner for the sequencer circle/main screen
			var newWidth:Number = stage.stageWidth - navHeight;
			
			//give each sound the same width in the remaining space
			newWidth = newWidth / drums.length;
			
			for each (var drum:DrumHead in drums){
				//Cc.log(drum.name+" "+newWidth+" "+lastX);
				drum.redraw(newWidth);
				drum.y = 0;
				drum.x = lastX;
				lastX = lastX + newWidth;
			}
		}
		
		private function RemoveDrum(_name : String) : void {
			//clean out of vector
			var temp:Vector.<DrumHead> = new Vector.<DrumHead>();
			for each (var drum:DrumHead in drums) {
				if (drum.name != _name) {
					temp.push(drum);
				}
			}
			drums = temp;
			
			//clean up listeners

			//clean off stage
			this.removeChild(this.getChildByName(_name));
			
			//clean up related screen			
		}
		
		private function onDialogButton(event : Event) : void
		{
			if(nameDialog)
			{
				trace("[Hello World]", "dialog dismissed");
				/* Respond to the user's input. */
				if("sayHello" == nameDialog.getButtonPropertyAt(DialogButtonProperty.CONTEXT, nameDialog.selectedIndex))
				{
					helloLabel.text = "Hello, " + nameDialog.text;
				}
				else
				{
					helloLabel.text = "Maybe later, then.";
				}
				/* Clean up the dialog and re-enable the button. */
				nameDialog.removeEventListener(Event.SELECT, onDialogButton);
				nameDialog = null;
				helloButton.enabled = true;
			}
		}
	}
}