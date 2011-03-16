package view.components {
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
		
		public function SeqHead(_height:Number, _width:Number) {
			this.passedHeight = _height;
			this.passedWidth = _width;
			drawBackground();
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
