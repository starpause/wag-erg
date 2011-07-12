package view.components {
	import model.Data;
	import events.Brain;
	import events.Thought;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.display.Sprite;

	/**
	 * @author jgray
	 */
	public class SeqHead extends Sprite {
		private var color:Number = 0xFFFFFF;
		private var bgShape : Shape = new Shape;
		private var passedHeight : Number;
		private var passedWidth : Number;
		private var ringHolder : Sprite = new Sprite;
		
		private var rings:Vector.<Ring> = new Vector.<Ring>();
		private var greatestRadius : Number;
		private var ringSpacer : Number = 5;
		private var positionIndicator : PositionIndicator;
		
		public function SeqHead(_height:Number, _width:Number) {
			this.passedHeight = _height;
			this.passedWidth = _width;
			greatestRadius = (passedWidth - Data.margin*2) / 2;
			
			drawBackground();
			drawRingHolder();
			drawPositionIndicator();
			
			addListeners();
		}

		private function drawPositionIndicator() : void {
			positionIndicator = new PositionIndicator(greatestRadius+ringSpacer/2);
			addChild(positionIndicator);
			positionIndicator.x = (passedWidth)/2;
			positionIndicator.y = (passedHeight)/2;			
		}
		
		private function addListeners():void{
			Brain.addThoughtListener(Thought.ADD_RING, onAddRing);			
			Brain.addThoughtListener(Thought.ERASE_DRUM, onEraseDrum);
			Brain.addThoughtListener(Thought.UPDATE_RINGS, onUpdateRings);
			Brain.addThoughtListener(Thought.NEW_COLOR, onNewColor);
		}
		
		private function onNewColor(event:Thought) : void {
			for each (var ring:Ring in rings) {
				if (ring._key == event.params['key'] ){
					ring.newColor(event.params['color']);
				}
			}			
		}
		
		private function onUpdateRings(event:Thought) : void {
			for each (var ring:Ring in rings) {
				if (ring._key == event.params['key'] ){
					ring.redraw(ring._circleR,event.params['sequence'],event.params['tickSequence']);
				}
			}
		}

		private function onEraseDrum(event:Thought) : void {
			var _name:String = event.params["key"];
			
			//clean out of vector
			var temp:Vector.<Ring> = new Vector.<Ring>();
			for each (var ring:Ring in rings) {
				if (ring._key != _name) {
					temp.push(ring);
				}else{
					ringHolder.removeChild(ringHolder.getChildByName(_name));	
				}
			}
			rings = temp;
			
			//show the home screen
			redrawRings();
		}
		
		private function onAddRing(event:Thought) : void {
			//TODO: uncache as bitmap?
			//new ring
			var tKey:String = event.params['key'];
			var tColor:Number = event.params['drumColor'];
			var tSequence:Array = event.params['sequence'];
			var tTickSequence:Vector.<Boolean> = event.params['tickSequence'];
			var tempRing:Ring = new Ring(greatestRadius, tKey, 0xFFFFFF, tColor,tSequence,tTickSequence);
			ringHolder.addChild(tempRing);
			rings.unshift(tempRing);
			//make 'em pritty
			redrawRings();
			//TODO:cache ring holder as bitmap?
		}

		private function drawRingHolder() : void {
			addChild(ringHolder);
			ringHolder.x = (passedWidth)/2;
			ringHolder.y = (passedHeight)/2;			
		}
		
		private function redrawRings(event:Thought=null) : void {
			var i:int=0;
			//var sequence:Array = new Array;//get from event
			for each (var ring:Ring in rings){
				//Cc.log("i"+i+" "+ring._key);
				ring.redraw(greatestRadius - i*ringSpacer);
				i++;
			}
		}

		private function drawBackground() : void {
			//shape with _height for h&w
			bgShape.graphics.beginFill(color);
			bgShape.graphics.drawRect(0,0,passedHeight,passedWidth);
			bgShape.graphics.endFill();
			bgShape.alpha = Data.alphaHeadUp;
			addChild(bgShape);
			
			this.buttonMode = true;
			this.useHandCursor = true;
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.CLICK, onClick);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			this.addEventListener(MouseEvent.MOUSE_UP, onUp);
			this.addEventListener(MouseEvent.MOUSE_OUT, onUp);
		}
		
		private function onUp(event : MouseEvent) : void {
			bgShape.alpha = Data.alphaHeadUp;
		}

		private function onDown(event : MouseEvent) : void {
			//which should be first here for most responsive feel?
			Brain.send(new Thought(Thought.SEQ_HEAD_HIT));
			bgShape.alpha = Data.alphaHeadDown;
		}

		private function onMove(event : MouseEvent) : void {
			if(Data.touchScreen == true){
				bgShape.alpha = Data.alphaHeadDown;
			}
		}

		private function onClick(event : MouseEvent=null) : void {
			//moved to onDown because onClick wasn't triggering 
			//until finger was lifted off screen on iOS
		}


	}
}
