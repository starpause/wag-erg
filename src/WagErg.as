/*
 * A simple "Hello, World" example that demonstrates use of an
 * application-modal dialog to prompt for the user's name and
 * echo it in a greeting.
 * 
 * If you're having trouble compiling, follow the steps at
 * http://blog.formatlos.de/2010/12/13/playbook-development-with-fdt-and-ant/
 */
package
{
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

	[SWF(height="600", width="1024", frameRate="30", backgroundColor="#BBBBBB")]
	public class WagErg extends Sprite
	{
		private var helloLabel : Label;
		private var helloButton : LabelButton;
		private var nameDialog : PromptDialog;

		public function WagErg()
		{
			trace("HELLO");
			/* A button to request a greeting. */
			helloButton = new LabelButton();
			helloButton.label = "Pushe Moi";
			helloButton.x = (stage.stageWidth - helloButton.width) / 2;
			helloButton.y = (stage.stageHeight - helloButton.height) / 2;
			/* A label in which to show the hello greeting. */
			helloLabel = new Label();
			helloLabel.width = 800;
			helloLabel.height = 30;
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
			helloButton.addEventListener(MouseEvent.CLICK, sayHello);
			addChild(helloButton);
			stage.nativeWindow.visible = true;

			new IowWindow();
		}

		private function sayHello(event : MouseEvent) : void
		{
			if(nameDialog)
			{
				trace("[Hello World]", "name dialog already showing");
			}
			else
			{
				/* Disable the button while the dialog is showing. */
				helloButton.enabled = false;
				trace("[Hello World]", "showing dialog");
				nameDialog = new PromptDialog();
				nameDialog.message = "What is your name?";
				nameDialog.prompt = "your name";
				// add buttons and associate semantic context tags to them
				nameDialog.addButton("OK");
				nameDialog.setButtonPropertyAt(DialogButtonProperty.CONTEXT, "sayHello", 0);
				nameDialog.addButton("Later");
				nameDialog.setButtonPropertyAt(DialogButtonProperty.CONTEXT, "cancel", 1);
				/* Register a listener for the dialog buttons. */
				nameDialog.addEventListener(Event.SELECT, onDialogButton);
				/*
				 * Assign my group ID to the dialog so that it is modal to my application
				 * only, not system-wide.  This ensures that the user can switch to and
				 * interact with other applications while the dialog is open.
				 */
				nameDialog.show(IowWindow.getAirWindow().group);
			}
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