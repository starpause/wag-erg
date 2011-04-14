package view.components {
	import flash.filters.GlowFilter;
	import events.Thought;
	import events.Brain;
	/**
	 * @author jgray
	 */
	
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class Ring extends Sprite{
		private var fillColor:Number;
		private var tickColor:Number;
		private var maskColor:Number = 0xFF0000;
		
		private var offset:Number = -90;// Initial angle
		private var circleR:Number; // Circle radius (in pixels)
		
		private var tickFill:Shape;
		private var tickSprite:Sprite;
		
		private var thickness:int = 4;
		private var key:String;
		private var euHits : Array;
		private var degreeHits:Vector.<Boolean>;
		private var degreesToDraw:int =1;
		private var degreesPerChamber:Number =0;
		
		public function Ring(radius:Number=29, _key:String="", foreColor:Number=0xFFFFFF, backgroundColor:Number=0x888888,sequence:Array=null){
			key = _key;
			name = _key;
			fillColor = foreColor;
			tickColor = backgroundColor;
			circleR = radius;
			euHits=sequence;
			mapChambersToDegrees();
			
			//drawing set up
			tickSprite = new Sprite();
			addChild(tickSprite);
			tickFill = new Shape();
			tickSprite.addChild(tickFill);			
		}
		
		private function drawTicks():void{
			tickFill.graphics.clear();
			tickFill.graphics.lineStyle(1,tickColor);
			tickFill.graphics.moveTo(0,0);
			tickFill.graphics.beginFill(tickColor,1);//.7
			
			for (var i:int=0; i<361; i++) {
				if(degreeHits[i]==true){
					var dFirst:Number = (i+offset)*-1;
					var dLast:Number = Math.floor((i+degreesPerChamber-1+offset)*-1);
					while(dFirst > dLast){
						tickFill.graphics.moveTo((circleR-thickness)*Math.cos(dFirst*Math.PI/180), -(circleR-thickness)*Math.sin(dFirst*Math.PI/180) );
						tickFill.graphics.lineTo(circleR*Math.cos(dFirst*Math.PI/180), -circleR*Math.sin(dFirst*Math.PI/180) );
						//tickFill.graphics.lineTo(circleR*Math.cos(dLast*Math.PI/180), -circleR*Math.sin(dLast*Math.PI/180) );
						dFirst = dFirst - .5;
					}
					//The final lineTo outside of the loop takes the "pen" back to its starting point.
					//tickFill.graphics.lineTo(0,0);
				}
			}
			
			//Since the drawing is between beginFill and endFill, we get the filled shape.
			tickFill.graphics.endFill();
		}
		
		public function newColor(color:Number):void{
			tickColor = color;
			redraw(circleR);
		}
		
		//sequence is a euclidean sequence for getting the beat ring right
		public function redraw(radius : Number, sequence:Array=null) : void {
			//new radius
			circleR = radius;
			
			//did we get a new sequence?
			if(sequence!=null){
				euHits=sequence;
				mapChambersToDegrees();
			}
			
			//draw back fill
			drawTicks();
			
			//punch out masking of back
			//drawMask();				
		}

		public function get _key() : String {
			return key;
		}
		
		private function mapChambersToDegrees() : void {
			//map the eu resolution to our tick resolution
			degreeHits = new Vector.<Boolean>(361);
			degreesPerChamber = 360 / euHits.length;
			degreesToDraw = Math.floor(degreesPerChamber);
			for(var i:int=0;i<euHits.length;i++){
				if(euHits[i]==1){
					var targetDegree:Number = Math.round(i*degreesPerChamber);
					degreeHits[targetDegree] = true;
				}
			}
		}

		public function get _circleR() : Number {
			return circleR;
		}
		

		
	}
}
