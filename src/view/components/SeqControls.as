package view.components {
	import events.pVent;
	import events.EventCentral;
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
		
		public function SeqControls(_width:Number,_height:Number){
			//store passed variables
			passedWidth = _width;
			passedHeight = _height;

			//wait for the stage to init display
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			// add listeners
			EventCentral.getInstance().addEventListener(pVent.DRUM_HEAD_HIT, hide);
			EventCentral.getInstance().addEventListener(pVent.SEQ_HEAD_HIT, show);
		}

		private function hide(event : pVent) : void {
			this.visible = false;
		}

		private function show(event : pVent) : void {
			this.visible = true;
		}

		private function init(e:Event=null):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			drawBackground();
			
			var newDrumButton:NewDrumButton = new NewDrumButton();
			addChild(newDrumButton);
			
			newDrumButton.x = (passedWidth - newDrumButton.width)/2;
			newDrumButton.y = (passedHeight - newDrumButton.height)/2;
			
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