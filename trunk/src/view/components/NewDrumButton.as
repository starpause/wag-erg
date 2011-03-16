package view.components {
	import flash.text.TextFieldAutoSize;
	import events.pVent;
	import events.EventCentral;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.display.Sprite;
	/**
	 * @author jgray
	 */
	public class NewDrumButton extends Sprite{
		private var helloButton : Sprite;
		private var addDrumField:TextField = new TextField();		
		private var passedWidth : Number;
		
		public function NewDrumButton(_width:Number){
			//store
			passedWidth = _width;
			
			//wait
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);			
		}
		
		private function init(e:Event=null) : void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//bg on stage
			helloButton = new Sprite();
			addChild(helloButton);			
			
			//tf on stage, tf properties
			addChild(addDrumField);
			addDrumField.embedFonts = true;
			addDrumField.autoSize = TextFieldAutoSize.LEFT;
			addDrumField.antiAliasType = flash.text.AntiAliasType.ADVANCED;
			
			addDrumField.defaultTextFormat = new TextFormat("nokia", 32, 0x000000);
			addDrumField.border = false;
			addDrumField.selectable = false;
			//addDrumField.wordWrap = true;
			addDrumField.text = ' add sound';
			
			//bg properties after tf is done
			helloButton.graphics.beginFill(0xFFFFFF);
			helloButton.graphics.drawRect(0, 0, passedWidth, addDrumField.height);
			helloButton.graphics.endFill();
			
			/* Listen for a touch on the dialog. */
			//helloButton.x = (stage.stageWidth - helloButton.width)/2;
			//helloButton.y = stage.stageHeight/2;
			this.buttonMode = true;
			this.mouseChildren = false;
			this.useHandCursor = true;
			this.addEventListener(MouseEvent.CLICK, onAddDrum);
		}

		private function onAddDrum(event : MouseEvent) : void {
			EventCentral.getInstance().dispatchEvent(new pVent(pVent.ADD_DRUM));
		}
		



	}	
}
