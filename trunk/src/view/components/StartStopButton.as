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
	public class StartStopButton extends Sprite{
		private var holder:Sprite = new Sprite;
		private var bg : Sprite = new Sprite;
		private var startField:TextField = new TextField();		
		private var stopField:TextField = new TextField();		
		private var passedHeight : Number;
		
		public function StartStopButton(_height:Number){
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
			holder.addChild(startField);
			holder.addChild(stopField);
			
			//textfield properties
			startField.embedFonts = true;
			startField.autoSize = TextFieldAutoSize.LEFT;
			startField.antiAliasType = flash.text.AntiAliasType.ADVANCED;			
			startField.defaultTextFormat = new TextFormat("nokia", Data.fontSize, 0x000000);
			startField.border = false;
			startField.selectable = false;
			startField.text = ' start sequencer';
			
			//textfield properties
			stopField.embedFonts = true;
			stopField.autoSize = TextFieldAutoSize.LEFT;
			stopField.antiAliasType = flash.text.AntiAliasType.ADVANCED;			
			stopField.defaultTextFormat = new TextFormat("nokia", Data.fontSize, 0x000000);
			stopField.border = false;
			stopField.selectable = false;
			stopField.text = ' stop sequencer';
			
			//default state is playing
			showStop();
			
			//bg properties after tf is done
			bg.graphics.beginFill(0xFFFFFF);
			bg.graphics.drawRect(0, 0, passedHeight, startField.height);
			bg.graphics.endFill();
			
			/* Listen for a touch on the dialog. */
			//helloButton.x = (stage.stageWidth - helloButton.width)/2;
			//helloButton.y = stage.stageHeight/2;
			holder.buttonMode = true;
			holder.mouseChildren = false;
			holder.useHandCursor = true;
			holder.addEventListener(MouseEvent.CLICK, onHit);
			holder.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			holder.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
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

		private function onMove(event : MouseEvent) : void {
			if(Data.touchScreen == true){
				this.alpha = Data.alphaDown;
			}
		}

		private function showStart() : void {
			startField.visible = true;
			stopField.visible = false;
		}

		private function showStop() : void {
			startField.visible = false;
			stopField.visible = true;
		}

		private function onHit(event : MouseEvent) : void {
			if(Data.beaterOn==true){
				Data.userStoppedSequencer=true;
				Brain.send(new Thought(Thought.STOP_SEQ));
				showStart();
			}else{
				Data.userStoppedSequencer=false;
				Brain.send(new Thought(Thought.START_SEQ));
				showStop();
			}
		}


	}	
}
