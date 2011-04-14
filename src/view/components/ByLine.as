package view.components {
	import flash.events.MouseEvent;
	import events.Brain;
	import events.Thought;
	import flash.display.DisplayObject;
	import model.Data;
	import flash.text.TextFieldAutoSize;
	import flash.events.Event;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.display.Sprite;
	/**
	 * @author jgray
	 */
	public class ByLine extends Sprite{
		private var holder:Sprite = new Sprite;
		private var bg : Sprite = new Sprite;
		private var addDrumField:TextField = new TextField();		
		private var passedHeight : Number;
		private var bgLight : Sprite = new Sprite;
		
		public function ByLine(_height:Number){
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
			holder.addChild(bgLight);
			holder.addChild(addDrumField);

			holder.buttonMode = true;
			holder.useHandCursor = true;
			holder.mouseChildren = false;
			holder.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			holder.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			holder.addEventListener(MouseEvent.MOUSE_UP, onUp);
			holder.addEventListener(MouseEvent.MOUSE_OUT, onUp);
			
			//textfield properties
			addDrumField.embedFonts = true;
			addDrumField.autoSize = TextFieldAutoSize.LEFT;
			addDrumField.antiAliasType = flash.text.AntiAliasType.NORMAL;			
			addDrumField.defaultTextFormat = new TextFormat("nokia", Data.fontSize, 0xFFFFFF);
			addDrumField.border = false;
			addDrumField.selectable = false;
			addDrumField.text = ' wag ERG by k9d';
			
			//bg properties after tf is done
			bg.graphics.beginFill(0x000000);
			bg.graphics.drawRect(0, 0, passedHeight, addDrumField.height);
			bg.graphics.endFill();
			
			//bg properties after tf is done
			bgLight.graphics.beginFill(0xFFFFFF);
			bgLight.graphics.drawRect(0, 0, passedHeight, addDrumField.height);
			bgLight.graphics.endFill();
			bgLight.alpha = Data.alphaHeadUp;
			
			/* Listen for a touch on the dialog. */
			//helloButton.x = (stage.stageWidth - helloButton.width)/2;
			//helloButton.y = stage.stageHeight/2;
			/*
			holder.buttonMode = true;
			holder.mouseChildren = false;
			holder.useHandCursor = true;
			holder.addEventListener(MouseEvent.CLICK, onAddDrum);
			*/
			//rotating inside the button so the layout class doesn't have to do funny width/heigt 
			holder.rotation = -90;
		}

		private function onUp(event : MouseEvent) : void {
			bgLight.alpha = Data.alphaHeadUp;
		}

		private function onDown(event : MouseEvent) : void {
			//which should be first here for most responsive feel?
			Brain.send(new Thought(Thought.BY_LINE_HIT));
			bgLight.alpha = Data.alphaHeadDown;
		}

		private function onMove(event : MouseEvent) : void {
			if(Data.touchScreen == true){
				bgLight.alpha = Data.alphaHeadDown;
			}
		}


		
		public function highOn():void{
			bg.alpha=Data.alphaHeadDown;
		}

		public function highOff():void{
			bg.alpha=Data.alphaHeadUp;;
		}

	}
}
