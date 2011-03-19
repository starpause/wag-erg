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
			synth.cacheSound(onCacheComplete,500);
		}
		
		
		/*
		 * playing around with cache ... doesn't sound as good
		 * 
		 */
		private function init(e:Event=null) : void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function onCacheComplete() : void {
			//back to normal volume
			sTransform.volume = 1;
			SoundMixer.soundTransform = sTransform;
			
			//hear
			//triggerSound();

			//show
			this.visible = true;
			Brain.send(new Thought(Thought.ADD_DRUM_COMPLETE));
			
			//listeners
			Brain.addThoughtListener(Thought.ON_TICK, onTick);
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
		
		
		public function destroy() : void {
			//is there anything else i can do to clean up? no removeEventListener on Brain 
			synth = null;
		}
		
		public function euSeq():Array{
			return euclideanSequence._euHits;
		}
				
	}
}
