package view.components {
	import events.pVent;
	import events.EventCentral;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextField;
	import flash.display.Sprite;
	/**
	 * @author jgray
	 */
	public class NewDrumButton extends Sprite{
		private var helloLabel : TextField;
		private var helloButton : Sprite;
		
		public function NewDrumButton(){
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);			
		}
		
		private function init(e:Event=null) : void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			/* A button to request a greeting. */
			helloButton = new Sprite();
			helloButton.graphics.beginFill(0xFF00FF);
			helloButton.graphics.drawRect(0, 0, 100, 10);
			helloButton.graphics.endFill();
			
			/* A label in which to show the hello greeting. */
			helloLabel = new TextField();
			helloLabel.text = "add drum";
			helloLabel.width = 10;
			helloLabel.height = 10;
			//helloLabel.x = (stage.stageWidth - helloLabel.width) / 2;
			//helloLabel.y = helloButton.y - 60;
			var format : TextFormat = new TextFormat();
			format = new TextFormat();
			format.align = TextFormatAlign.CENTER;
			format.font = "Arial";
			format.color = 0xFF00FF;
			format.size = 24;
			helloLabel.setTextFormat(format);
			helloButton.addChild(helloLabel);
			
			/* Listen for a touch on the dialog. */
			//helloButton.x = (stage.stageWidth - helloButton.width)/2;
			//helloButton.y = stage.stageHeight/2;
			helloButton.buttonMode = true;
			helloButton.mouseChildren = false;
			helloButton.useHandCursor = true;
			helloButton.addEventListener(MouseEvent.CLICK, onAddDrum);
			addChild(helloButton);			
		}

		private function onAddDrum(event : MouseEvent) : void {
			EventCentral.getInstance().dispatchEvent(new pVent(pVent.ADD_DRUM));
		}
		



	}	
}
