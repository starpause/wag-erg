package view.components {
	import model.Data;
	import events.Thought;
	import events.Brain;
	import flash.events.Event;
	import flash.display.Shape;
	import flash.display.Sprite;
	/**
	 * @author jgray
	 */
	public class SeqControls extends Sprite {
		private var passedWidth : Number;
		private var passedHeight : Number;
		private var bgShape : Shape = new Shape;
		private var lastX : Number = 0;
		
		public function SeqControls(_width:Number,_height:Number){
			//store passed variables
			passedWidth = _width;
			passedHeight = _height;

			//wait for the stage to init display
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			// add listeners
			Brain.addThoughtListener(Thought.DRUM_HEAD_HIT, hide);
			Brain.addThoughtListener(Thought.SEQ_HEAD_HIT, show);
		}

		private function hide(event : Thought) : void {
			this.visible = false;
		}

		private function show(event : Thought) : void {
			this.visible = true;
		}

		private function init(e:Event=null):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);

			lastX = Data.margin;
			
			drawBackground();
			drawByLine();
			drawNewDrumButton();
			drawStartStopButton();
		}

		private function drawByLine() : void {
			var byLine:ByLine = new ByLine(passedHeight - (Data.margin*2));
			addChild(byLine);
			
			byLine.alpha = 1;
			byLine.x = lastX; 
			byLine.y = passedHeight - Data.margin;
			lastX = lastX + byLine.width + Data.margin;			
		}

		private function drawNewDrumButton() : void {
			var newDrumButton:NewDrumButton = new NewDrumButton(passedHeight - (Data.margin*2));
			addChild(newDrumButton);
			
			newDrumButton.x = lastX; 
			newDrumButton.y = passedHeight - Data.margin;
			lastX = lastX + newDrumButton.width + Data.margin;
		}
		
		private function drawStartStopButton() : void {
			var startSopButton:StartStopButton = new StartStopButton(passedHeight - (Data.margin*2));
			addChild(startSopButton);
			
			startSopButton.x = lastX; 
			startSopButton.y = passedHeight - Data.margin;
			lastX = lastX + startSopButton.width + Data.margin;
		}

		private function drawBackground() : void {
			//shape with _height for h&w
			bgShape.graphics.beginFill(0x000000);
			bgShape.graphics.drawRect(0,0,passedWidth,passedHeight);
			bgShape.graphics.endFill();
			addChild(bgShape);			
		}
		
		
		
	}
}
