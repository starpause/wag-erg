package view.components {
	import events.Thought;
	import events.Brain;
	import flash.events.Event;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	/**
	 * @author jgray
	 */
	public class DrumHead extends Sprite {
		private var synth:SfxrSynth;
		private var baseParams:SfxrParams;
		private var bgShape:Shape = new Shape;
		public var color:Number = Math.random() * 0xFFFFFF; 
		private var passedHeight:Number;
		private var passedWidth:Number;
		private var key:String = "";
		
		public function DrumHead(_name:String="", _height:Number=10){
			//Cc.log('DrumHead with '+_name+' '+_height);
			this.name = _name;
			this.key = _name;
			this.passedHeight = _height;
			this.passedWidth = _height;
			
			//init sound
			synth = new SfxrSynth();
			synth.params.randomize();
			synth.params.minFrequency = 0;
			baseParams = synth.params.clone();
			synth.play();
			
			//init display
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
			triggerSound();
			Brain.send(new Thought(Thought.DRUM_HEAD_HIT, {key:this.key}));
		}
		
		private function triggerSound(event:Event=null):void{
			synth.params = baseParams.clone();
			synth.params.mutate();
			synth.params.minFrequency = 0;
			synth.play();			
		}

		public function redraw(newWidth : Number = -1) : void {
			bgShape.graphics.clear();
			bgShape.graphics.beginFill(color);
			if(newWidth != -1){
				bgShape.graphics.drawRect(0,0,newWidth,passedHeight);
				passedWidth = newWidth;
			}else{
				bgShape.graphics.drawRect(0,0,passedWidth,passedHeight);
			}
			bgShape.graphics.endFill();
			addChild(bgShape);
		}
				
	}
}
