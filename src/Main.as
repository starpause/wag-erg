package {
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
		private var drums:Vector.<DrumHead> = new Vector.<DrumHead>();
		//private var baseParams:Object = new Object();
		//private var drumPads:Object = new Object();
		private var drumCounter:int = 0;
		
		//private var navWidth:Number;
		private var navHeight : Number;
		private var redrawDrumsCallback : Function;
		
		//assets
		[Embed(source="/assets/nokiafc22.ttf", fontFamily="nokia", mimeType="application/x-font-truetype")]
		public var nokia:String;
		
		public function Main(){
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);			
		}
		
		private function init(e:Event=null):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			navHeight = stage.stageHeight/3;
			Data.margin = Math.floor(stage.stageWidth * .01 / 2);
			
			// listeners
			Brain.addThoughtListener(Thought.ADD_DRUM, onAddDrum);
			Brain.addThoughtListener(Thought.ERASE_DRUM, eraseDrum);
			
			//drawing			
			var seqControls:SeqControls = new SeqControls(stage.stageWidth, stage.stageHeight-navHeight);
			addChild(seqControls);
			seqControls.x = 0;
			seqControls.y = navHeight;
			var seqHead:SeqHead = new SeqHead(navHeight,navHeight);
			addChild(seqHead);
			seqHead.x = 0;//stage.stageWidth - seqHead.width;
			seqHead.y = 0;
			
			//debugging
			Cc.startOnStage(this, "");
			Cc.y = 90;//stage.stageHeight-Cc.height;
			Cc.x = 300;//(stage.stageWidth-Cc.width)/2;			
		}
		
		private function onAddDrum(event:Thought) : void {
			//if we're not at 12 seconds already

			//new drum head
			drumCounter++;
			var tempName:String = "drum"+drumCounter.toString();
			var tempDrum:DrumHead = new DrumHead(tempName, navHeight);
			tempDrum.x = tempDrum.y = 0;
			drums.push(tempDrum);
			addChild(tempDrum);
			
			//new drum controls
			//tempName = "controls"+drumCounter.toString();
			var tempControls:DrumControls = new DrumControls(stage.stageWidth, stage.stageHeight-navHeight, tempName, tempDrum.color);
			tempControls.x = 0;
			tempControls.y = navHeight;
			addChild(tempControls);
			
			//re arange all the drums
			redrawDrums();
		}

		private function redrawDrums() : void {
			//start stacking left to right
			var lastX:Number = navHeight;
			
			//reserve a square in the right hand corner for the sequencer circle/main screen
			var newWidth:Number = stage.stageWidth - navHeight;
			
			//give each sound the same width in the remaining space
			newWidth = newWidth / drums.length;
			
			for each (var drum:DrumHead in drums){
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
			for each (var drum:DrumHead in drums) {
				if (drum.name != _name) {
					temp.push(drum);
				}
			}
			drums = temp;
			
			//destroy listeners
			
			//destroy drum head
			this.removeChild(this.getChildByName(_name));
			
			//destroy drum controls	
			
			//show the home screen
			redrawDrums();
			Brain.send(new Thought(Thought.SEQ_HEAD_HIT));
		}

		
	}
}