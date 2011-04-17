package model {
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	import SfxrSynth;
	/**
	 * This factory creates random Drums in the background and queues them up for
	 * use by a DrumHead. This avoids the delay after pressing the add drum button.
	 * The SfxrSynth object can generate a sound in the background by using a small
	 * timeslice from each frame. The DrumFactory starts generating these sounds in the
	 * background when it is created.
	 * 
	 * @author feweiss
	 */
	public class DrumFactory {
		private var drums:Array;
		private var queueLimit:Number;
		private var maxTimePerFrame:Number;
		/**
		 * Create a DrumFactory. The parameters are currntly hard coded.
		 */
		public function DrumFactory() {
			drums = new Array();
			queueLimit = 3;
			// when max time per frame was 500 it was making sounds faster in desktop debug mode
			// but it was causing a lag in the wait screen appearing on iOS
			// so it's been dropped to 50 and i increased all the SWF specs to run at 60fps
			maxTimePerFrame  = 50;
			start();
		}
		/**
		 * Get a new Drum with a random sound and do the callback when the sound
		 * has been generated. 
		 */
		public function getDrum(callback:Function):SfxrSynth {
			if (drums.length > 0) {
				var drum:SfxrSynth = drums.shift();
				
				// fill up the queue if necessary
				if (drums.length == queueLimit - 1) {
					start();
				}
				
				// there appears to be a race somewhere that messes up the display, so the callback
				// must be delayed. it's probably not the amount of time delay, but just doing it
				// on a separate "thread"
				var timer:Timer = new Timer(10,1);
				timer.addEventListener(TimerEvent.TIMER, function():void {
					callback();
				});
				timer.start();
				
				return drum;
			} else {
				// fallback
				var synth:SfxrSynth = createRandomSound();
				synth.cacheSound(callback, maxTimePerFrame);
				return synth;
			}
		}
		/**
		 * Create a sound synthesizer with randomized parameters.
		 * FIXME: why does minFrequency need to be 0?
		 */
		private function createRandomSound():SfxrSynth {
			var synth:SfxrSynth = new SfxrSynth();
			synth.params.randomize();
			// hard set some parameters
			synth.params.minFrequency = 0;
			return synth;
		}
		/**
		 * Start generating and enqueuing sounds for the drums. This runs in the background,
		 * using up a small timeslice of each frame, as per the SfrSynth implementation.
		 */
		private function start():void {
			var synth:SfxrSynth = createRandomSound();
			synth.cacheSound(onCacheComplete, maxTimePerFrame);
			
			function onCacheComplete():void {
				drums.push(synth);
				if (drums.length < queueLimit) {
					start();
				}
			}
		}
	}
}
