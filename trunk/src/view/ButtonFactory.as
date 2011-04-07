package view {

    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

    import events.Thought;
    import events.Brain;
    import model.Data;
    import view.components.DrumButton;
    import view.components.NewDrumButton;
    
    /**
     * Use this factory object to create platform-specific buttons.
     * The factory takes care of standardizing buttons as per global style.
     */
    public class ButtonFactory {
        private var height:Number;
        
        /**
         * Construct a button factory with the parameters common to all
         * the buttons. These parameters may be platform-specific, thus
         * the factory creates the correct kind of buttons for the platform.
         */
        public function ButtonFactory(height:Number) {
            this.height = height;
        }

        /**
         * Create a drum button with specific size, font, rollover effects.
         */
        public function createButton(_height:Number, _key:String, _copy:String, _event:String):Sprite {
            return new DrumButton(_height, _key, _copy, _event);
        }

        /**
         * Create a NEW drum button with specific size.
         */
        public function createNewButton():Sprite {
            //return new NewDrumButton(height - Data.margin * 2);
            var button:Sprite = new Sprite();

            var holder:Sprite = new Sprite();
            var bg : Sprite = new Sprite();
            var textField:TextField = new TextField();       
            var passedHeight : Number;
        
            button.addChild(holder);
            holder.addChild(bg);
            holder.addChild(textField);
            
            //textfield properties
            textField.embedFonts = true;
            textField.autoSize = TextFieldAutoSize.LEFT;
            textField.antiAliasType = flash.text.AntiAliasType.ADVANCED;         
            textField.defaultTextFormat = new TextFormat("nokia", Data.fontSize, 0x000000);
            textField.border = false;
            textField.selectable = false;
            textField.text = ' add sound';
            
            //bg properties after tf is done
            bg.graphics.beginFill(0xFFFFFF);
            bg.graphics.drawRect(0, 0, height - Data.margin * 2, textField.height);
            bg.graphics.endFill();
            
            /* Listen for a touch on the dialog. */
            holder.buttonMode = true;
            holder.mouseChildren = false;
            holder.useHandCursor = true;
            holder.addEventListener(MouseEvent.CLICK, onAddDrum);
            holder.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
            holder.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
            holder.addEventListener(MouseEvent.MOUSE_UP, onUp);
            holder.addEventListener(MouseEvent.MOUSE_OUT, onUp);
            
            //rotating inside the button so the layout class doesn't have to do funny width/heigt 
            holder.rotation = -90;
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

        private function onAddDrum(event : MouseEvent) : void {
            Brain.send(new Thought(Thought.ADD_DRUM));
        }
    }
}
