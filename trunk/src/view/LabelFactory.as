package view {

    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
	import flash.text.AntiAliasType;

    import model.Data;
	
    /**
     * Use this factory object to create platform-specific labels.
     * The factory takes care of standardizing labels as per global style.
     */
    public class LabelFactory {
        private var height:Number;
        
        /**
         * Construct a label factory with the parameters common to all
         * the labels. These parameters may be platform-specific, thus
         * the factory creates the correct kind of labels for the platform.
         *
         * @param height the height of the labels
         */
        public function LabelFactory(height:Number) {
            this.height = height;
        }

        /**
         * Create a label with specific size, font, rollover effects.
         *
         * @param text the text of the label
         */
        public function createLabel(text:String):Sprite {
			var label:Sprite = new Sprite();
			var textField:TextField = new TextField();
			var textBack:TextField = new TextField();
			
            //label.addChild(holder);
            label.addChild(textBack);			
            //textBack properties
            textBack.embedFonts = true;
            textBack.autoSize = TextFieldAutoSize.LEFT;
            textBack.antiAliasType = flash.text.AntiAliasType.NORMAL;         
            textBack.defaultTextFormat = new TextFormat("nokia", Data.fontSize, 0x000000);
            textBack.border = false;
            textBack.selectable = false;
            textBack.text = text;
            textBack.alpha = Data.alphaUp;
            textBack.x=1;
            textBack.y=1;
            
            //label.addChild(holder);
            label.addChild(textField);			
            //textfield properties
            textField.embedFonts = true;
            textField.autoSize = TextFieldAutoSize.LEFT;
            textField.antiAliasType = flash.text.AntiAliasType.NORMAL;         
            textField.defaultTextFormat = new TextFormat("nokia", Data.fontSize, 0xFFFFFF);
            textField.border = false;
            textField.selectable = false;
            textField.text = text;
            textField.alpha = Data.alphaUp;
			
            //rotating inside the label so the layout class doesn't have to do funny width/heigt 
			label.rotation = -90;
			return label;
        }
        
    }
}
