package view.components {
	import com.junkbyte.console.Cc;
	import model.Data;
	import events.Brain;
	import events.Thought;
	import flash.display.Shape;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.display.Sprite;

	/**
	 * @author jgray
	 */
	public class SeqHead extends Sprite {
		private var color:Number = 0x000000;
		private var bgShape : Shape = new Shape;
		private var passedHeight : Number;
		private var passedWidth : Number;
		private var ringHolder : Sprite = new Sprite;

		private var rings:Vector.<Ring> = new Vector.<Ring>();
		private var greatestRadius : Number;
		private var ringSpacer : Number = 4;
		
		public function SeqHead(_height:Number, _width:Number) {
			this.passedHeight = _height;
			this.passedWidth = _width;
			drawBackground();
			drawRingHolder();
			//drawPositionIndicator();
			
			addListeners();
		}
		
		private function addListeners():void{
			Brain.addThoughtListener(Thought.ADD_RING, onAddRing);			
			Brain.addThoughtListener(Thought.ERASE_DRUM, onEraseDrum);			
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
			//new ring
			var tKey:String = event.params['key'];
			var tColor:Number = event.params['drumColor'];
			var tempRing:Ring = new Ring(greatestRadius, tKey, 0xFFFFFF, tColor);
			ringHolder.addChild(tempRing);
			rings.unshift(tempRing);
			//make 'em pritty
			redrawRings();
		}

		private function drawRingHolder() : void {
			addChild(ringHolder);
			ringHolder.x = (passedWidth)/2;
			ringHolder.y = (passedHeight)/2;			
		}
		
		private function redrawRings() : void {
			greatestRadius = (passedWidth - Data.margin*2) / 2;
			
			var i:int=0;
			var sequence:Array = new Array;//get from event
			for each (var ring:Ring in rings){
				Cc.log("i"+i+" "+ring._key);
				ring.redraw(greatestRadius - i*ringSpacer, sequence);
				i++;
			}
		}

		private function drawBackground() : void {
			//shape with _height for h&w
			bgShape.graphics.beginFill(color);
			bgShape.graphics.drawRect(0,0,passedHeight,passedWidth);
			bgShape.graphics.endFill();
			//bgSprite.alpha = .2;
			addChild(bgShape);
			
			this.buttonMode = true;
			this.useHandCursor = true;
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(event : MouseEvent) : void {
			Brain.send(new Thought(Thought.SEQ_HEAD_HIT));
		}


	}
}
