package view.components {
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import com.bit101.components.VSlider;
	import view.LabelFactory;
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
		private var labelFactory : LabelFactory;
		
		public function DrumControls(_width:Number,_height:Number,_name:String="",_color:Number=0x000000){
			//store passed variables
			key = _name;
			color = _color;
			passedWidth = _width;
			passedHeight = _height;
			Cc.log('Drum Height: '+passedHeight);
			
            buttonFactory  = new ButtonFactory(_height);
            labelFactory  = new LabelFactory(_height);

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
			drawSoundLabel();
			drawRemoveDrumButton();
			drawRandomizeColorButton();
			drawVolumeLabel();
			drawVolumeSlider();

			drawSequenceLabel();
			drawRandomizeSequenceButton();
			//drawMutatePrevButton();
			//drawMutateNextButton();
			//drawCacheMutationButton();
			
			hide();
			//draw the other shit drums need
			Brain.addThoughtListener(Thought.NEW_COLOR, onNewColor);
			
		}

		private function drawVolumeLabel() : void {
		}

		private function drawVolumeSlider() : void {
			var textBack:TextField = new TextField();
			
            //label.addChild(holder);
			addChild(textBack);			
            //textBack properties
            textBack.embedFonts = true;
            textBack.autoSize = TextFieldAutoSize.LEFT;
            textBack.antiAliasType = flash.text.AntiAliasType.NORMAL;         
            textBack.defaultTextFormat = new TextFormat("nokia", Data.fontSize, 0x000000);
            textBack.border = false;
            textBack.selectable = false;
            textBack.text = " volume";
            textBack.alpha = Data.alphaUp;
            textBack.x=lastX;
            textBack.y=passedHeight - Data.margin;
            textBack.rotation = -90;


			var sliderVolume:VSlider = new VSlider();
			addChild(sliderVolume);
			
			//draw slider
			sliderVolume.alpha = .5;
			sliderVolume.x = lastX;
			sliderVolume.y = Data.margin;
			sliderVolume.height = passedHeight-(Data.margin*2);
			sliderVolume.width = Data.pokeSize+Data.pokeSize/2;
			//sliderVolume.backClick = false;
			//map slider volume to synth volume
			sliderVolume.maximum = 1;
			sliderVolume.minimum = 0;
			sliderVolume.value = .5;//naughty magic value, should get this from synth on init
			sliderVolume.name = key;
			sliderVolume.addEventListener(Event.CHANGE, onSliderVolumeChange);
			lastX = lastX + sliderVolume.width + Data.margin;
		}

		private function onSliderVolumeChange(event : Event) : void {
			Brain.send(new Thought(Thought.VOLUME_CHANGE,{key:this.key,volume:VSlider(event.target).value}));
		}

		private function drawSequenceLabel() : void {
			var sequenceLabel:Sprite = labelFactory.createLabel(" sequence");
			addChild(sequenceLabel);
			
			sequenceLabel.x = lastX; //(passedWidth - sequenceLabel.width)/2;
			sequenceLabel.y = passedHeight - Data.margin;
			lastX = lastX + sequenceLabel.width + Data.margin;
		}
		
		private function drawSoundLabel() : void {
			var soundLabel:Sprite = labelFactory.createLabel(" "+key);
			addChild(soundLabel);
			
			soundLabel.x = lastX; //(passedWidth - soundLabel.width)/2;
			soundLabel.y = passedHeight - Data.margin;
			lastX = lastX + soundLabel.width + Data.margin;
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
			var eraseDrumButton:Sprite = buttonFactory.createButton(" erase drum");
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
