package view {

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
    public class SliderFactory {
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
        public function createSlider(text:String):Sprite {
            //return new NewDrumButton(height - Data.margin * 2);
            var button:Sprite = new Sprite();
            var bg : Sprite = new Sprite();
            var textField:TextField = new TextField();
			
            //button.addChild(holder);
            button.addChild(bg);
            button.addChild(textField);
			
            //textfield properties
            textField.embedFonts = true;
            textField.autoSize = TextFieldAutoSize.LEFT;
            textField.antiAliasType = flash.text.AntiAliasType.NORMAL;         
            textField.defaultTextFormat = new TextFormat("nokia", Data.fontSize, 0x000000);
            textField.border = false;
            textField.selectable = false;
            textField.text = text;
            
            //bg properties after tf is done
            bg.graphics.beginFill(0xFFFFFF);
            bg.graphics.drawRect(0, 0, height - Data.margin * 2, textField.height);
            bg.graphics.endFill();
            
            /* Listen for a touch on the dialog. */
            button.buttonMode = true;
            button.mouseChildren = false;
            button.useHandCursor = true;
            button.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
            button.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
            button.addEventListener(MouseEvent.MOUSE_UP, onUp);
            button.addEventListener(MouseEvent.MOUSE_OUT, onUp);
            
            //rotating inside the button so the layout class doesn't have to do funny width/heigt 
            button.rotation = -90;
            button.alpha = Data.alphaUp;
            
            return button;
        }
        
        private function onUp(event : MouseEvent) : void {
            var button:Sprite = Sprite(event.target);
            button.alpha = Data.alphaUp;
        }

        private function onDown(event : MouseEvent) : void {
            var button:Sprite = Sprite(event.target);
            button.alpha = Data.alphaDown;
        }

        private function onMove(event : MouseEvent) : void {
            var button:Sprite = Sprite(event.target);
            if(Data.touchScreen == true){
                button.alpha = Data.alphaDown;
            }
        }
    }
}
