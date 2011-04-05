package view.components {
	import model.Data;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.media.Sound;
	import com.junkbyte.console.Cc;
	import events.Thought;
	import events.Brain;
	import flash.events.Event;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import model.EuclideanSequence;
	
	/**
	 * @author jgray
	 */
	public class DrumHead extends Sprite {
		private var synth:SfxrSynth;
		private var baseParams:SfxrParams;
		private var bgShape:Shape = new Shape;
		private var bgWhite:Shape = new Shape;
		public var color:Number = Math.random() * 0xFFFFFF; 
		private var passedHeight:Number;
		private var passedWidth:Number;
		private var key : String = "";
		private	var sTransform:SoundTransform = new SoundTransform(0,0);
		private var euclideanSequence:EuclideanSequence;
		
		public function DrumHead(_name:String="", _height:Number=10){
			//Cc.log('DrumHead with '+_name+' '+_height);
			this.name = _name;
			this.key = _name;
			this.passedHeight = _height;
			this.passedWidth = _height;
			
			//init display
			this.visible = false;
			drawBackground();
			
			//init sequencer
			euclideanSequence = new EuclideanSequence(Data.totalTicks);
			
			//init sound
			synth = new SfxrSynth();
			synth.params.randomize();
			
			//hard set some values
			synth.params.minFrequency = 0;
			
			//baseParams = synth.params.clone();
			//silence
			SoundMixer.soundTransform = sTransform;
			//when max time per frame was 500 it was making sounds faster in desktop debug mode
			//but it was causing a lag in the wait screen appearing on iOS
			//so it's been dropped to 50 and i increased all the SWF specs to run at 60fps
			synth.cacheSound(onCacheComplete,50);
		}
		
		private function onRandomizeColor(event:Thought) : void {
			if(event.params['key']==this.key){
				color = Math.random() * 0xFFFFFF;
				onNewColor();
				Brain.send(new Thought(Thought.NEW_COLOR,{key:this.key,color:this.color}));
			}
		}

		private function onRandomizeSequence(event:Thought) : void {
			if(event.params['key'] == this.key){
				euclideanSequence = new EuclideanSequence(Data.totalTicks);
				Brain.send(new Thought(Thought.UPDATE_RINGS,{key:this.key,sequence:euclideanSequence._euHits}));
			}
		}

		private function onCacheComplete() : void {
			//back to normal volume
			sTransform.volume = 1;
			SoundMixer.soundTransform = sTransform;
			
			//hear
			triggerSound();
			
			//show
			this.visible = true;
			Brain.send(new Thought(Thought.ADD_DRUM_COMPLETE,{key:this.key}));
			
			//listeners
			Brain.addThoughtListener(Thought.ON_TICK, onTick);
			Brain.addThoughtListener(Thought.RANDOMIZE_SEQUENCE, onRandomizeSequence);
			Brain.addThoughtListener(Thought.RANDOMIZE_COLOR, onRandomizeColor);
		}

		private function drawBackground() : void {
			//shape with _height for h&w
			bgShape.graphics.clear();
			bgShape.graphics.beginFill(color);
			bgShape.graphics.drawRect(0,0,passedHeight,passedWidth);
			bgShape.graphics.endFill();			
			addChild(bgShape);
			
			//highlight
			bgWhite.graphics.clear();
			bgWhite.graphics.beginFill(0xFFFFFF);
			bgWhite.graphics.drawRect(0,0,passedHeight,passedWidth);
			bgWhite.graphics.endFill();
			addChild(bgWhite);
			bgWhite.alpha = Data.alphaHeadUp;
			
			this.buttonMode = true;
			this.useHandCursor = true;
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.CLICK, onClick);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			this.addEventListener(MouseEvent.MOUSE_UP, onUp);
			this.addEventListener(MouseEvent.MOUSE_OUT, onUp);
		}
		
		private function onNewColor():void{
			bgShape.graphics.clear();
			bgShape.graphics.beginFill(color);
			bgShape.graphics.drawRect(0,0,passedWidth,passedHeight);
			bgShape.graphics.endFill();			
		}

		private function onTick(event:Thought):void{
			var position:uint = event.params['position'];
			if(euclideanSequence.hasHitAt(position)){
				triggerSound();
			}else if(euclideanSequence.hasAccentedHitAt(position)){
				triggerSoundWithAccent();
			}
		}

		private function triggerSoundWithAccent() : void {
			if(synth==null){return;};
			synth.play();
		}
		
		private function triggerSound(event:Event=null):void{
			/*
			synth.params = baseParams.clone();
			synth.params.mutate();
			synth.params.minFrequency = 0;
			synth.play();
			*/
			if(synth==null){return;};
			synth.play();
		}
		
		public function redraw(newWidth : Number = -1) : void {
			bgShape.graphics.clear();
			bgWhite.graphics.clear();

			bgShape.graphics.beginFill(color);
			bgWhite.graphics.beginFill(0xFFFFFF);

			if(newWidth != -1){
				bgShape.graphics.drawRect(0,0,newWidth,passedHeight);
				bgWhite.graphics.drawRect(0,0,newWidth,passedHeight);
				passedWidth = newWidth;
			}else{
				bgShape.graphics.drawRect(0,0,passedWidth,passedHeight);
				bgWhite.graphics.drawRect(0,0,passedWidth,passedHeight);
			}
			
			bgWhite.graphics.endFill();
			bgShape.graphics.endFill();
		}
		
		
		public function destroy() : void {
			//is there anything else i can do to clean up? no removeEventListener on Brain 
			synth = null;
		}
		
		public function euSeq():Array{
			return euclideanSequence._euHits;
		}
		
		private function onUp(event : MouseEvent) : void {
			bgWhite.alpha = Data.alphaHeadUp;
		}
		private function onDown(event : MouseEvent) : void {
			triggerSound();
			Brain.send(new Thought(Thought.DRUM_HEAD_HIT, {key:this.key}));
			bgWhite.alpha = Data.alphaHeadDown;
		}
		private function onMove(event : MouseEvent) : void {
			if(Data.touchScreen == true){
				bgWhite.alpha = Data.alphaHeadDown;
			}
		}
		private function onClick(event : MouseEvent) : void {
			//moved to onDown because onClick wasn't triggering 
			//until finger was lifted off screen on iOS
		}
		

		
				
	}
}
