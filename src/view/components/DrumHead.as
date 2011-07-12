package view.components {
	import util.Conversion;
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
	 * A DrumHead object is a sound that is played via a sequence and has a key color.
	 * Also manages a button for selecting the track.
	 *
	 * Upon construction, it creates:
	 * 1) a random euclidean sequence
	 * 2) a random synth sound paramters
	 * 3) a random color
	 * 4) starts the process of creating the sound via the synth
	 * When the synth has finished, the callback triggers the sound and add
	 * event handlers for the tick event and to randomize the sequence and to reandomize
	 * the color.
	 *
	 * This class has a bit too many responsibilities.
	 *
	 * @author jgray
	 */
	public class DrumHead extends Sprite {
		private var synth:SfxrSynth;
		private var bgShape:Shape = new Shape;
		private var bgWhite:Shape = new Shape;
		public var color:Number = Math.random() * 0xFFFFFF;
		private var mutateChannel:int = Math.floor(Math.random() * 3); //random 0r 1g 2b 
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
			
			//silence
			SoundMixer.soundTransform = sTransform;
			
			synth = Data.drumFactory.getDrum(onCacheComplete);
		}
		
		private function onRandomizeColor(event:Thought) : void {
			if(event.params['key']==this.key){
				color = Math.random() * 0xFFFFFF;
				mutateChannel = Math.floor(Math.random() * 3); //random 0r 1g 2b
				onNewColor();
				Brain.send(new Thought(Thought.NEW_COLOR,{key:this.key,color:this.color}));
			}
		}

		private function onMutateColor(event:Thought) : void {
			if(event.params['key']==this.key){
				var tempColor:Object = Conversion.hexToRGB(color);
				switch(mutateChannel){
					case 0:
						tempColor.r = tempColor.r + Math.floor(Math.random() * 33)-16;
						if(tempColor.r<0){
							tempColor.r=0;
						}
						if(tempColor.r>255){
							tempColor.r=255;
						}
					case 1:
						tempColor.g = tempColor.g + Math.floor(Math.random() * 33)-6;
						if(tempColor.g<0){
							tempColor.g=0;
						}
						if(tempColor.g>255){
							tempColor.g=255;
						}
					case 2:
						tempColor.b = tempColor.b + Math.floor(Math.random() * 33)-16;
						if(tempColor.b<0){
							tempColor.b=0;
						}
						if(tempColor.b>255){
							tempColor.b=255;
						}
				}
				
				color = Conversion.RGBToHex(tempColor);
				onNewColor();
				Brain.send(new Thought(Thought.NEW_COLOR,{key:this.key,color:this.color}));
			}
		}

		private function onRandomizeSequence(event:Thought) : void {
			if(event.params['key'] == this.key){
				euclideanSequence = new EuclideanSequence(Data.totalTicks);
				Brain.send(new Thought(Thought.UPDATE_RINGS,{key:this.key,sequence:euclideanSequence._euHits,tickSequence:euclideanSequence._tickHits}));
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
			//Brain.addThoughtListener(Thought.VOLUME_CHANGE, onVolumeChange);
			Brain.addThoughtListener(Thought.RANDOMIZE_SEQUENCE, onRandomizeSequence);
			Brain.addThoughtListener(Thought.RANDOMIZE_COLOR, onRandomizeColor);
			Brain.addThoughtListener(Thought.ERASE_DRUM, onEraseDrum);
			//Brain.addThoughtListener(Thought.MUTATE_COLOR, onMutateColor);
		}

		private function onEraseDrum(event:Thought) : void {
			if(this.key == event.params['key']){
				this.removeEventListener(MouseEvent.CLICK, onClick);
				this.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
				this.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
				this.removeEventListener(MouseEvent.MOUSE_UP, onUp);
				this.removeEventListener(MouseEvent.MOUSE_OUT, onUp);			
				synth = null;
				this.destroy();
			}
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

		private function onVolumeChange(event:Thought) : void {
			if(this.key == event.params['key']){
				synth.params.masterVolume = event.params['volume']; 
			}
		}

		private function onTick(event:Thought):void{
			if(euclideanSequence.hasHitAt(event.params['position'])){
				triggerSound();
			}
		}

		private function triggerSoundWithAccent() : void {
			if(synth==null){return;};
			synth.play();
		}
		
		private function triggerSound(event:Event=null):void{
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
		
		public function tickSeq():Vector.<Boolean>{
			return euclideanSequence._tickHits;
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
			// until finger was lifted off screen on iOS
		}

		public function get _synth() : SfxrSynth {
			return synth;
		}
		

		
				
	}
}
