package view.components {
	import flash.text.TextField;
	import com.bit101.components.VSlider;
	import com.bit101.components.Slider;
	import view.SliderFactory;
	import model.Data;
    import flash.events.MouseEvent;
	import events.Thought;
	import events.Brain;
	import view.ButtonFactory;
	import flash.events.Event;
	import flash.display.Sprite;
	/**
	 * @author jgray
	 */
	public class SeqControls extends Sprite {
		private var passedWidth : Number;
		private var passedHeight : Number;
		private var bgShape : Sprite = new Sprite;
		private var lastX : Number = 0;
		private var factory:ButtonFactory;
		private var sliderFactory:SliderFactory;
		private var speedSlider:Sprite;
		
		public function SeqControls(_width:Number,_height:Number){
			//store passed variables
			passedWidth = _width;
			passedHeight = _height;
			
			factory  = new ButtonFactory(_height);
			sliderFactory  = new SliderFactory(_height);
			//wait for the stage to init display
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);			
		}
		
		private function init(e:Event=null):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			lastX = Data.margin;
			
			drawBackground();
			//drawUniversalLabel();
			drawNewDrumButton();
			//drawSequencerLabel();
			drawStartStopButton();
			drawSpeedSlider();
		}

		private function drawSpeedSlider() : void {
			var key:String = "speed";
			speedSlider = sliderFactory.createSlider(" bpm", 230, 23, Data.bpm, key, 1, 0xFFFFFF);
			Slider(speedSlider.getChildByName(key)).valueChanged.add(onSliderSpeedChange);
			TextField(speedSlider.getChildByName('textValue')).text = ' = '+Math.floor(Data.bpm);
			addChild(speedSlider);
			
			speedSlider.x = lastX; //(passedWidth - sequenceLabel.width)/2;
			speedSlider.y = passedHeight - Data.margin;
			speedSlider.name = key;
			lastX = lastX + speedSlider.getChildByName(key).width + Data.margin;			
		}
		
		private function onSliderSpeedChange(newValue:Number) : void {
			TextField(speedSlider.getChildByName('textValue')).text = ' = '+Math.floor(newValue);
			Brain.send(new Thought(Thought.SPEED_CHANGE,{bpm:newValue}));
		}
		
		private function drawNewDrumButton() : void {
            var newDrumButton:Sprite = factory.createButton(" add sound");
            newDrumButton.addEventListener(MouseEvent.CLICK, onAddDrum);
			addChild(newDrumButton);
			
			newDrumButton.x = lastX;
			newDrumButton.y = passedHeight - Data.margin;
			lastX = lastX + newDrumButton.width + Data.margin;
		}
		
		private function drawStartStopButton() : void {
			var startSopButton:StartStopButton = new StartStopButton(passedHeight - (Data.margin*2));
			addChild(startSopButton);
			
			startSopButton.x = lastX; 
			startSopButton.y = passedHeight - Data.margin;
			lastX = lastX + startSopButton.width + Data.margin;
		}

		private function drawBackground() : void {
			//shape with _height for h&w
			bgShape.graphics.beginFill(0x000000);
			bgShape.graphics.drawRect(0,0,passedWidth,passedHeight);
			bgShape.graphics.endFill();
			addChild(bgShape);
			bgShape.doubleClickEnabled = true;
			bgShape.buttonMode = true;
			bgShape.mouseChildren = false;
			bgShape.useHandCursor = false;
			bgShape.addEventListener(MouseEvent.DOUBLE_CLICK, onBgDoubleClick);
		}

		private function onBgDoubleClick(event : MouseEvent) : void {
			Brain.send(new Thought(Thought.BLACK_DOUBLE_CLICK));
		}
		

        private function onAddDrum(event : MouseEvent) : void {
            Brain.send(new Thought(Thought.ADD_DRUM));
        }
		
	}
}
