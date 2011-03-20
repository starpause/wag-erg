package view.components {
	import model.Data;
	import flash.text.TextFieldAutoSize;
	import events.Thought;
	import events.Brain;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.display.Sprite;
	/**
	 * @author jgray
	 */
	public class NewDrumButton extends Sprite{
		private var holder:Sprite = new Sprite;
		private var bg : Sprite = new Sprite;
		private var addDrumField:TextField = new TextField();		
		private var passedHeight : Number;
		
		public function NewDrumButton(_height:Number){
			//store
			passedHeight = _height;
			
			//wait
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);			
		}
		
		private function init(e:Event=null) : void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addChild(holder);
			holder.addChild(bg);
			holder.addChild(addDrumField);
			
			//textfield properties
			addDrumField.embedFonts = true;
			addDrumField.autoSize = TextFieldAutoSize.LEFT;
			addDrumField.antiAliasType = flash.text.AntiAliasType.ADVANCED;			
			addDrumField.defaultTextFormat = new TextFormat("nokia", 32, 0x000000);
			addDrumField.border = false;
			addDrumField.selectable = false;
			addDrumField.text = ' add sound';
			
			//bg properties after tf is done
			bg.graphics.beginFill(0xFFFFFF);
			bg.graphics.drawRect(0, 0, passedHeight, addDrumField.height);
			bg.graphics.endFill();
			
			/* Listen for a touch on the dialog. */
			//helloButton.x = (stage.stageWidth - helloButton.width)/2;
			//helloButton.y = stage.stageHeight/2;
			holder.buttonMode = true;
			holder.mouseChildren = false;
			holder.useHandCursor = true;
			holder.addEventListener(MouseEvent.CLICK, onAddDrum);
			holder.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			holder.addEventListener(MouseEvent.MOUSE_UP, onUp);
			holder.addEventListener(MouseEvent.MOUSE_OUT, onUp);
			
			//rotating inside the button so the layout class doesn't have to do funny width/heigt 
			holder.rotation = -90;
			this.alpha = Data.alphaUp;
		}

		private function onUp(event : MouseEvent) : void {
			this.alpha = Data.alphaUp;
		}

		private function onDown(event : MouseEvent) : void {
			this.alpha = Data.alphaDown;
		}


		private function onAddDrum(event : MouseEvent) : void {
			Brain.send(new Thought(Thought.ADD_DRUM));
		}
		



	}	
}
