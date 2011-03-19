package view.components {
	import flash.text.TextFieldAutoSize;
	import flash.events.Event;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.display.Sprite;
	/**
	 * @author jgray
	 */
	public class ByLine extends Sprite{
		private var holder:Sprite = new Sprite;
		private var bg : Sprite = new Sprite;
		private var addDrumField:TextField = new TextField();		
		private var passedHeight : Number;
		
		public function ByLine(_height:Number){
			//store
			passedHeight = _height;
			
			//wait
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);			
		}
		
		private function init(e:Event=null) : void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addChild(holder);
			holder.addChild(bg);
			holder.addChild(addDrumField);
			
			//textfield properties
			addDrumField.embedFonts = true;
			addDrumField.autoSize = TextFieldAutoSize.LEFT;
			addDrumField.antiAliasType = flash.text.AntiAliasType.ADVANCED;			
			addDrumField.defaultTextFormat = new TextFormat("nokia", 32, 0xFFFFFF);
			addDrumField.border = false;
			addDrumField.selectable = false;
			addDrumField.text = ' wag ERG by k9d';
			
			//bg properties after tf is done
			bg.graphics.beginFill(0x000000);
			bg.graphics.drawRect(0, 0, passedHeight, addDrumField.height);
			bg.graphics.endFill();
			
			/* Listen for a touch on the dialog. */
			//helloButton.x = (stage.stageWidth - helloButton.width)/2;
			//helloButton.y = stage.stageHeight/2;
			/*
			holder.buttonMode = true;
			holder.mouseChildren = false;
			holder.useHandCursor = true;
			holder.addEventListener(MouseEvent.CLICK, onAddDrum);
			*/
			//rotating inside the button so the layout class doesn't have to do funny width/heigt 
			holder.rotation = -90;
		}

	}	
}
