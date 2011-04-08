package view.components {
	import com.junkbyte.console.Cc;
	import model.Data;
    import view.ButtonFactory;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import events.Thought;
	import events.Brain;
	import flash.events.Event;
	import flash.display.Sprite;
	/**
	 * @author jgray
	 */
	public class DrumControls extends Sprite {
		private var color : Number;
		private var passedWidth : Number;
		private var passedHeight : Number;
		private var bgShape : Shape = new Shape;
		private var key : String = "";
		private var lastX : Number = 0;
		private var buttonFactory : ButtonFactory;
		
		public function DrumControls(_width:Number,_height:Number,_name:String="",_color:Number=0x000000){
			//store passed variables
			key = _name;
			color = _color;
			passedWidth = _width;
			passedHeight = _height;
			Cc.log('Drum Height: '+passedHeight);
			
            buttonFactory  = new ButtonFactory(_height);

			//wait for the stage to init display
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			// add listeners
			Brain.addThoughtListener(Thought.DRUM_HEAD_HIT, onDrumHeadHit);
		}

		private function onSeqHeadHit(event : Thought) : void {
			hide();
		}
		
		private function onDrumHeadHit(event : Thought) : void {
			if(String(event.params["key"]) == key){
				show();
			}else{
				hide();
			}
		}

		private function hide() : void {
			this.visible = false;
		}

		private function show() : void {
			this.visible = true;
		}
		
		private function init(e:Event=null):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			lastX = Data.margin;

			addChild(bgShape);
			drawBackground();
			
			//drawCloneDrumButton();
			drawRandomizeColorButton();
			drawRandomizeSequenceButton();
			//drawMutatePrevButton();
			//drawMutateNextButton();
			//drawCacheMutationButton();
			drawRemoveDrumButton();
			
			hide();
			//draw the other shit drums need
			Brain.addThoughtListener(Thought.NEW_COLOR, onNewColor);
			
		}

		private function drawRandomizeColorButton() : void {
			var drumButton:DrumButton = new DrumButton(passedHeight-(Data.margin*2), key, 'rand color',Thought.RANDOMIZE_COLOR);
			addChild(drumButton);
			
			drumButton.x = lastX; //(passedWidth - eraseDrumButton.width)/2;
			drumButton.y = passedHeight - Data.margin;
			lastX = lastX + drumButton.width + Data.margin;
		}

		private function drawRandomizeSequenceButton() : void {
			var drumButton:DrumButton = new DrumButton(passedHeight-(Data.margin*2), key, 'rand sequence',Thought.RANDOMIZE_SEQUENCE);
			addChild(drumButton);
			
			drumButton.x = lastX; //(passedWidth - eraseDrumButton.width)/2;
			drumButton.y = passedHeight - Data.margin;
			lastX = lastX + drumButton.width + Data.margin;
		}

		private function drawCloneDrumButton() : void {
			var cloneDrumButton:DrumButton = new DrumButton(passedHeight-(Data.margin*2), key, 'clone sound',Thought.CLONE_DRUM);
			addChild(cloneDrumButton);
			
			cloneDrumButton.x = lastX; //(passedWidth - eraseDrumButton.width)/2;
			cloneDrumButton.y = passedHeight - Data.margin;
			lastX = lastX + cloneDrumButton.width + Data.margin;
		}

		private function drawRemoveDrumButton() : void {
			var eraseDrumButton:Sprite = buttonFactory.createButton(" erase sound");
			eraseDrumButton.addEventListener(MouseEvent.CLICK, onEraseDrum)
			addChild(eraseDrumButton);
			
			eraseDrumButton.x = lastX; //(passedWidth - eraseDrumButton.width)/2;
			eraseDrumButton.y = passedHeight - Data.margin;
			lastX = lastX + eraseDrumButton.width + Data.margin;
		}
		
		private function onNewColor(event:Thought):void{
			if(this.key == event.params['key']){
				this.color = event.params['color'];
				drawBackground();
			}
		}

		private function drawBackground() : void {
			//shape with _height for h&w
			bgShape.graphics.clear();
			bgShape.graphics.beginFill(color);
			bgShape.graphics.drawRect(0,0,passedWidth,passedHeight);
			bgShape.graphics.endFill();
		}
		
		private function onEraseDrum(event : MouseEvent) : void {
            Brain.send(new Thought(Thought.ERASE_DRUM, {key:this.key}));
        }
		
		
	}
}
