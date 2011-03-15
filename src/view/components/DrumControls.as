package view.components {
	import flash.display.Shape;
	import events.pVent;
	import events.EventCentral;
	import flash.events.Event;
	import flash.display.Sprite;
	/**
	 * @author jgray
	 */
	public class DrumControls extends Sprite {
		private var color : Number;
		private var passedWidth : Number;
		private var passedHeight : Number;
		private var bgShape : Shape = new Shape;
		private var key : String = "";
		
		public function DrumControls(_width:Number,_height:Number,_name:String="",_color:Number=0x000000){
			//store passed variables
			key = _name;
			color = _color;
			passedWidth = _width;
			passedHeight = _height;

			//wait for the stage to init display
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			// add listeners
			EventCentral.getInstance().addEventListener(pVent.DRUM_HEAD_HIT, onDrumHeadHit);
			EventCentral.getInstance().addEventListener(pVent.SEQ_HEAD_HIT, onSeqHeadHit);
		}

		private function onSeqHeadHit(event : pVent) : void {
			hide();
		}
		
		private function onDrumHeadHit(event : pVent) : void {
			if(String(event.params["key"]) == key){
				show();
			}else{
				hide();
			}
		}

		private function hide() : void {
			this.visible = false;
		}

		private function show() : void {
			this.visible = true;
		}
		
		private function init(e:Event=null):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			drawBackground();
			hide();
			//draw the other shit drums need
			
		}

		private function drawBackground() : void {
			//shape with _height for h&w
			bgShape.graphics.beginFill(color);
			bgShape.graphics.drawRect(0,0,passedWidth,passedHeight);
			bgShape.graphics.endFill();
			addChild(bgShape);
		}
		
		
		
	}
}