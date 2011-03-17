package view.components {
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.Sprite;
	/**
	 * @author jgray
	 */
	public class WaitScreen extends Sprite {
		private var bgShape : Sprite = new Sprite();
		
		public function WaitScreen():void{
			//wait for the stage to init display
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);		
		}

		private function init(e:Event=null):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			drawBackground();
			addListeners();
		}
		
		private function addListeners() : void {
			this.buttonMode = true;
			this.useHandCursor = true;
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function drawBackground() : void {
			//shape with _height for h&w
			bgShape.graphics.beginFill(0x000000);
			bgShape.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			bgShape.graphics.endFill();
			bgShape.alpha = .8;
			addChild(bgShape);
		}

		private function onClick(event : MouseEvent) : void {
		}
			
	}
}
