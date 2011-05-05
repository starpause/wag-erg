package view {
	import flash.events.Event;
	import com.bit101.components.VSlider;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
	import flash.text.AntiAliasType;

    import model.Data;
    import view.components.DrumButton;
    
    /**
     * Use this factory object to create platform-specific buttons.
     * The factory takes care of standardizing buttons as per global style.
     */
    public class SliderFactory{
		private var height:Number;
        
        /**
         * Construct a button factory with the parameters common to all
         * the buttons. These parameters may be platform-specific, thus
         * the factory creates the correct kind of buttons for the platform.
         *
         * @param height the height of the buttons
         */
        public function SliderFactory(height:Number) {
            this.height = height;
        }

        /**
         * Create a button with specific size, font, rollover effects.
         *
         * @param text the text of the button
         */
		public function createSlider(text:String, maximum:Number, minimum:Number, initialValue:Number, key:String, labelColor:Number=0x000000):Sprite {
        	var slider:Sprite = new Sprite();
			var textBack:TextField = new TextField();
			var textValue:TextField = new TextField();
			var vSlider:VSlider = new VSlider();
			
			slider.addChild(textBack);			
			slider.addChild(textValue);			
			slider.addChild(vSlider);
			
            //textBack properties
            textBack.embedFonts = true;
            textBack.autoSize = TextFieldAutoSize.LEFT;
            textBack.antiAliasType = flash.text.AntiAliasType.NORMAL;
            textBack.defaultTextFormat = new TextFormat("nokia", Data.fontSize, labelColor);
            textBack.border = false;
            textBack.selectable = false;
            textBack.text = text;
            textBack.name = 'textBack';
            textBack.alpha = Data.alphaUp;
            //textBack.x=0;
            //textBack.y=height - Data.margin;
            textBack.rotation = -90;
			
			//valueText properties
			textValue.embedFonts = true;
			textValue.autoSize = TextFieldAutoSize.LEFT;
			textValue.antiAliasType = flash.text.AntiAliasType.NORMAL;
			textValue.defaultTextFormat = new TextFormat("nokia", Data.fontSize, labelColor);
			textValue.border = false;
			textValue.selectable = false;
			//textValue.text = text;
			textValue.name = 'textValue';
			textValue.alpha = Data.alphaUp;
			//textValue.x=0;
			textValue.y=textBack.y - textBack.height;
			textValue.rotation = -90;
			
			//draw slider
			vSlider.alpha = Data.alphaUp;
			//vSlider.x = 0;
			vSlider.y = - height + Data.margin*2;
			vSlider.height = height-(Data.margin*2);
			vSlider.width = Data.pokeSize+Data.pokeSize/2;
			vSlider.name = key;
			//vSlider.addEventListener(Event.CHANGE, onSliderChange);
			//vSlider.backClick = false;
			//map slider volume to synth volume
			vSlider.maximum = maximum;
			vSlider.minimum = minimum;
			vSlider.value = initialValue;
			
			//touches
			
			return slider;
		}

    }
}
