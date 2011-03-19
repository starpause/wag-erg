package {
	import view.components.WaitScreen;
	import events.BeatDispatcherEvent;
	import events.BeatDispatcher;
	import view.components.SeqHead;
	import view.components.SeqControls;
	import events.Thought;
	import events.Brain;
	import view.components.DrumControls;
	import com.junkbyte.console.Cc;
	import view.components.DrumHead;
	import model.Data;
	
	import flash.display.Sprite;
	import flash.events.Event;

	public class Main extends Sprite{
		//private var drums:Vector.<DrumHead> = new Vector.<DrumHead>();
		//private var baseParams:Object = new Object();
		//private var drumPads:Object = new Object();
		private var drumCounter:int = 0;
		
		//private var navWidth:Number;
		private var navHeight : Number;
		private var redrawDrumsCallback : Function;
		
		private var beater:BeatDispatcher;
		private var mainScreen:Sprite = new Sprite();
		private var drumControlsHolder:Sprite = new Sprite();
		private var waitScreen:WaitScreen = new WaitScreen();
		
		//assets
		[Embed(source="/assets/nokiafc22.ttf", fontFamily="nokia", mimeType="application/x-font-truetype")]
		public var nokia:String;
		
		public function Main(){
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);			
		}
		
		private function init(e:Event=null):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//compute some stage based variables now that we have access
			navHeight = stage.stageHeight/3;
			Data.margin = Math.floor(stage.stageWidth * .01 / 2);
			
			addListeners();
			
			//drawing
			addChild(mainScreen);
			addChild(drumControlsHolder);
			addChild(waitScreen);
			waitScreen.visible = false;
			
			var seqControls:SeqControls = new SeqControls(stage.stageWidth, stage.stageHeight-navHeight);
			mainScreen.addChild(seqControls);
			seqControls.x = 0;
			seqControls.y = navHeight;
			var seqHead:SeqHead = new SeqHead(navHeight,navHeight);
			mainScreen.addChild(seqHead);
			seqHead.x = 0;//stage.stageWidth - seqHead.width;
			seqHead.y = 0;
						
			//init the sequencer
			initBeater();
			
			//debugging
			Cc.startOnStage(this, "`");
			Cc.y = 90;//stage.stageHeight-Cc.height;
			Cc.x = 300;//(stage.stageWidth-Cc.width)/2;
		}

		private function addListeners() : void {
			Brain.addThoughtListener(Thought.ADD_DRUM, onAddDrum);
			Brain.addThoughtListener(Thought.ERASE_DRUM, eraseDrum);
			Brain.addThoughtListener(Thought.ADD_DRUM_COMPLETE, onAddDrumComplete);
			Brain.addThoughtListener(Thought.STOP_SEQ, onStopSeq);
			Brain.addThoughtListener(Thought.START_SEQ, onStartSeq);
			Brain.addThoughtListener(Thought.SEQ_HEAD_HIT, onSeqHeadHit);
			Brain.addThoughtListener(Thought.DRUM_HEAD_HIT, onDrumHeadHit);
		}

		private function onDrumHeadHit(event:Thought) : void {
			drumControlsHolder.visible = true;
		}

		private function onSeqHeadHit(event:Thought) : void {
			drumControlsHolder.visible = false;
		}

		private function onStartSeq(event:Thought) : void {
			//set position?
			Data.beaterOn=true;
			beater.addEventListener(BeatDispatcherEvent.TICK,onTick);
		}

		private function onStopSeq(event:Thought) : void {
			//store position?
			Data.beaterOn=false;
			beater.removeEventListener(BeatDispatcherEvent.TICK,onTick);
		}
		
		private function destroyBeater():void{
			
		}

		private function initBeater() : void {
			//the max example of euclidean beats that i played with had a resolution of 128 steps and that was accurate enough
			//so 16 measures * 4 beats a measure * 2 ticks a beat should be enough resolution
			//went with more measures than more ticks per beat because things were slowing down when i increased the tick resolution, even matching lsdj's 6 ticks a beat would pause on cached sfxr play
			beater = new BeatDispatcher(160, 16, 4, 2);
			//beater.addEventListener(BeatDispatcherEvent.BEAT, onBeat);
			beater.addEventListener(BeatDispatcherEvent.TICK,onTick);
			beater.addEventListener(BeatDispatcherEvent.TICK,onGhost);
			beater.start();
			Data.beaterOn = beater.isTicking;
			
			Data.totalTicks = beater.totalPosition;
		}

		private function onTick(event : BeatDispatcherEvent) : void {
			Cc.log(event.toString());
			Brain.send(new Thought(Thought.ON_TICK,{'position':event.currentPosition}));
		}
		
		private function onGhost(event : BeatDispatcherEvent) : void {
			Brain.send(new Thought(Thought.ON_GHOST,{'position':event.currentPosition}));
		}
		
		private function onAddDrum(event:Thought) : void {
			//if we're not at 12 seconds already
			
			//blank out the screen so user doesn't going nuts on adding sounds or expect the app to be responsive
			waitScreen.visible = true;

			//when we make a new drum sound every property sits on the head
			//when the controls and ring might also need access
			//so an array of sounds should sit in Data with all the interesting properties
			//everythign else can feed off that instead of the drumhead
			
			//new drum head
			drumCounter++;
			var tempName:String = "drum"+drumCounter.toString();
			var tempDrum:DrumHead = new DrumHead(tempName, navHeight);
			tempDrum.x = tempDrum.y = 0;
			Data.drums.push(tempDrum);
			mainScreen.addChild(tempDrum);
			
			//new drum controls
			//tempName = "controls"+drumCounter.toString();
			var tempControls:DrumControls = new DrumControls(stage.stageWidth, stage.stageHeight-navHeight, tempName, tempDrum.color);
			tempControls.x = 0;
			tempControls.y = navHeight;
			drumControlsHolder.addChild(tempControls);
			
			//new drum ring
			Brain.send(new Thought(Thought.ADD_RING,{drumColor:tempDrum.color,key:tempName,sequence:tempDrum.euSeq()}));
		}
		
		private function onAddDrumComplete(event:Thought):void{
			waitScreen.visible = false;
			//re arange all the drums
			redrawDrums();			
		}

		private function redrawDrums() : void {
			//start stacking left to right
			var lastX:Number = navHeight;
			
			//reserve a square in the right hand corner for the sequencer circle/main screen
			var newWidth:Number = stage.stageWidth - navHeight;
			
			//give each sound the same width in the remaining space
			newWidth = newWidth / Data.drums.length;
			
			for each (var drum:DrumHead in Data.drums){
				//Cc.log(drum.name+" "+newWidth+" "+lastX);
				drum.redraw(newWidth);
				drum.y = 0;
				drum.x = lastX;
				lastX = lastX + newWidth;
			}
		}
		
		private function eraseDrum(event:Thought) : void {
			var _name:String = event.params["key"];
			
			//clean out of vector
			var temp:Vector.<DrumHead> = new Vector.<DrumHead>();
			for each (var drum:DrumHead in Data.drums) {
				if (drum.name != _name) {
					temp.push(drum);
				}
			}
			Data.drums = temp;
			
			//destroy listeners
			
			//destroy drum head
			DrumHead(mainScreen.getChildByName(_name)).destroy();
			mainScreen.removeChild(mainScreen.getChildByName(_name));
			
			//destroy drum controls
			
			//show the home screen
			redrawDrums();
			Brain.send(new Thought(Thought.SEQ_HEAD_HIT));
		}

		
	}
}