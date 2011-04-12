package util {
	import com.junkbyte.console.Cc;
	import model.Data;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	
	/**
	 * @author jgray
	 */
	public class DetectFontSize extends Sprite {

		public function DetectFontSize(){
			//use the default font size if we're web/desktop
			if(Data.touchScreen==false){return;};
			//make a text field
			var detectField:TextField = new TextField();
			var pointSize:int = 1;
			var textBigEnoughToPoke:Boolean = false;
			
			//try a font size of 1
			//loop to keep moving up until the height of the textfield is more than .25 
			while(textBigEnoughToPoke==false){
				detectField = new TextField();
				detectField.embedFonts = true;
				detectField.autoSize = TextFieldAutoSize.LEFT;
				detectField.antiAliasType = flash.text.AntiAliasType.NORMAL;
				detectField.border = false;
				detectField.selectable = false;
				detectField.defaultTextFormat = new TextFormat("nokia", pointSize, 0xFFFFFF);
				detectField.text = 'Pack my !@#$%^&* box with five dozen liquor jugs ()~{}|:"<>?,./';
				addChild(detectField);
				
				Cc.log('pointSize: '+pointSize);
				
				if(detectField.height > Conversion.inchesToPixels(11/64)){
					textBigEnoughToPoke=true;
				}else{
					pointSize++;
				}
				
				
			}
			
			//we found a decent value, let the applicaiton use it
			Data.fontSize = pointSize;
			Data.pokeSize = detectField.height;
			//cleanup?
		}
		
		private function init(e:Event=null) : void {
		}


		
		

	}
}
