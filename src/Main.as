package {
	import view.components.ByLine;
	import flash.ui.Keyboard;
	import model.Platform;
	import flash.events.KeyboardEvent;
	import flash.desktop.NativeApplication;
	import flash.system.Capabilities;
	import util.DetectFontSize;
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
		private var byLineWithMargin:Number;
		
		//assets
		//set -managers=flash.fonts.AFEFontManager in the flex compiler arguments if fonts are blank
		//comment out all other font managers in /blackberry-tablet-sdk-0.9.2/frameworks/air-config.xml
		[Embed(source="/assets/nokiafc22.ttf", fontFamily="nokia", mimeType="application/x-font-truetype")]
		public var nokia : String;
		private var detectedWidth : int;
		private	var detectedHeight : int;
		
		public function Main(){
			//non stage dependent init
			var detectFontSize:DetectFontSize = new DetectFontSize();
			detectFontSize;
			//stage dependent init
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event=null):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			detectStageSize();
			
			navHeight = detectedHeight/3;
			Data.controlHeight = detectedHeight - navHeight;
			Data.margin = Math.floor(detectedHeight * .01);
			
			addListeners();
			
			//drawing
			addChild(mainScreen);
			populateMainScreen();
			//drum controls get their own holder for easy show/hide of all them at once
			addChild(drumControlsHolder);
			addChild(waitScreen);
			waitScreen.visible = false;
						
			//init the sequencer
			initBeater();			
		}

		private function populateMainScreen() : void {
			var byLine:ByLine = new ByLine(detectedHeight-navHeight - (Data.margin*2));
			mainScreen.addChild(byLine);
			byLine.x = Data.margin;
			byLine.y = detectedHeight - Data.margin;
			byLineWithMargin = byLine.width + Data.margin*2;
			
			var seqControls:SeqControls = new SeqControls(stage.stageWidth - byLineWithMargin, detectedHeight-navHeight);
			mainScreen.addChild(seqControls);
			seqControls.x = byLineWithMargin;
			seqControls.y = navHeight;
			
			var seqHead:SeqHead = new SeqHead(navHeight,navHeight);
			mainScreen.addChild(seqHead);
			seqHead.x = 0;//stage.stageWidth - seqHead.width;
			seqHead.y = 0;
		}

		
		private function detectStageSize() : void {
			//compute some stage based variables now that we have access
			if(Data.platform=="IOS"){
				detectedHeight = Capabilities.screenResolutionX;
				detectedWidth = Capabilities.screenResolutionY;
			}else{
				detectedHeight = stage.stageHeight;
				detectedWidth = stage.stageWidth;
			}
		}
	
		private function addListeners() : void {
			Brain.addThoughtListener(Thought.ADD_DRUM, onAddDrum);
			Brain.addThoughtListener(Thought.ERASE_DRUM, eraseDrum);
			Brain.addThoughtListener(Thought.ADD_DRUM_COMPLETE, onAddDrumComplete);
			Brain.addThoughtListener(Thought.STOP_SEQ, onStopSeq);
			Brain.addThoughtListener(Thought.START_SEQ, onStartSeq);
			Brain.addThoughtListener(Thought.SEQ_HEAD_HIT, onSeqHeadHit);
			Brain.addThoughtListener(Thought.BY_LINE_HIT, onSeqHeadHit);
			Brain.addThoughtListener(Thought.DRUM_HEAD_HIT, onDrumHeadHit);
			Brain.addThoughtListener(Thought.DRUM_FACTORY_START, onDrumFactoryStart);
			Brain.addThoughtListener(Thought.SPEED_CHANGE, onSpeedChange);
		}

		private function onSpeedChange(event:Thought) : void {
			Data.bpm = event.params['bpm'];
			initBeater(Data.beaterOn);
		}

		private function onDrumFactoryStart(event:Thought) : void {
		}

		private function onDrumHeadHit(event:Thought) : void {
			drumControlsHolder.visible = true;
		}

		private function onSeqHeadHit(event:Thought=null) : void {
			drumControlsHolder.visible = false;
		}

		private function onStartSeq(event:Thought=null) : void {
			//set position?
			Data.beaterOn=true;
			beater.addEventListener(BeatDispatcherEvent.TICK,onTick);
		}

		private function onStopSeq(event:Thought=null) : void {
			//store position?
			Data.beaterOn=false;
			beater.removeEventListener(BeatDispatcherEvent.TICK,onTick);
		}
		
		private function initBeater(startBeater:Boolean=true) : void {
			if(beater!=null){
				beater.removeEventListener(BeatDispatcherEvent.TICK,onTick);
				beater.removeEventListener(BeatDispatcherEvent.TICK,onGhost);
				beater=null;
			}
			//the max example of euclidean beats that i played with had a resolution of 128 steps and that was accurate enough
			//so 16 measures * 4 beats a measure * 2 ticks a beat should be enough resolution
			//went with more measures than more ticks per beat because things were slowing down when i increased the tick resolution, even matching lsdj's 6 ticks a beat would pause on cached sfxr play
			beater = new BeatDispatcher(Data.bpm, 8, 4, 3);
			//listeners
			beater.addEventListener(BeatDispatcherEvent.TICK,onGhost);
			if(startBeater==true){
				beater.addEventListener(BeatDispatcherEvent.TICK,onTick);
				Data.beaterOn = true;//beater.isTicking;
			}
			//gg0g00g0
			beater.start();			
			Data.totalTicks = beater.totalPosition;			
		}

		private function onTick(event : BeatDispatcherEvent) : void {
			Brain.send(new Thought(Thought.ON_TICK,{'position':event.currentPosition}));
		}
		
		private function onGhost(event : BeatDispatcherEvent) : void {
			Brain.send(new Thought(Thought.ON_GHOST,{'position':event.currentPosition}));
		}
		
		private function onAddDrum(event:Thought) : void {
			//if we're not at 12 seconds already
			
			//blank out the screen so user doesn't going nuts on adding sounds or expect the app to be responsive
			waitScreen.visible = true;
			if(Data.userStoppedSequencer==false){
				beater.removeEventListener(BeatDispatcherEvent.TICK,onTick);
			}
			
			//when we make a new drum sound every property sits on the head
			//when the controls and ring might also need access
			//so an array of sounds should sit in Data with all the interesting properties
			//everythign else can feed off that instead of the drumhead
			
			//new drum head
			drumCounter++;
			var tempName:String = "sound "+drumCounter.toString();
			var tempDrum:DrumHead = new DrumHead(tempName, navHeight);
			tempDrum.x = tempDrum.y = 0;
			Data.drums.push(tempDrum);
			mainScreen.addChild(tempDrum);
			
			//new drum ring
			Brain.send(new Thought(Thought.ADD_RING,{drumColor:tempDrum.color,key:tempName,sequence:tempDrum.euSeq(),tickSequence:tempDrum.tickSeq()}));
			
			//new drum controls
			//tempName = "controls"+drumCounter.toString();
			var tempControls:DrumControls = new DrumControls(tempDrum._synth, stage.stageWidth-byLineWithMargin, stage.stageHeight-navHeight, tempName, tempDrum.color);
			tempControls.x = byLineWithMargin;
			tempControls.y = navHeight;
			drumControlsHolder.addChild(tempControls);
			
		}
		
		private function onAddDrumComplete(event:Thought):void{
			waitScreen.visible = false;
			if(Data.userStoppedSequencer==false){
				beater.addEventListener(BeatDispatcherEvent.TICK,onTick);
			}
			//re arange all the drums
			redrawDrums();
			Brain.send(new Thought(Thought.DRUM_HEAD_HIT, {key:event.params['key']}));
		}

		private function redrawDrums() : void {
			//start stacking left to right
			var lastX:Number = navHeight;
			
			//reserve a square in the right hand corner for the sequencer circle/main screen
			var newWidth:Number = stage.stageWidth - navHeight;
			
			//give each sound the same width in the remaining space
			newWidth = newWidth / Data.drums.length;
			
			for each (var drum:DrumHead in Data.drums){
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