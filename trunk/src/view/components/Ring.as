package view.components {
	/**
	 * @author jgray
	 */
	
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class Ring extends Sprite{
		private var fillColor:Number;
		private var tickColor:Number;
		
		private var offset:Number = -90;// Initial angle
		private var circleR:Number; // Circle radius (in pixels)
		
		private var tickFill:Shape;
		private var tickSprite:Sprite;
		
		private var thickness:int = 4;
		private var key:String;
		private var euHits : Array;
		private var tickHits : Vector.<Boolean>;
		private var degreeHits:Vector.<Boolean>;
		private var degreesPerChamber:Number = 0;
		private var degreesPerTick:Number = 0;
		
		public function Ring(radius:Number=29, _key:String="", foreColor:Number=0xFFFFFF, backgroundColor:Number=0x888888,sequence:Array=null,tickSequence:Vector.<Boolean>=null){
			key = _key;
			name = _key;
			fillColor = foreColor;
			tickColor = backgroundColor;
			circleR = radius;
			euHits=sequence;
			tickHits=tickSequence;
			mapTicksToDegrees();
			
			//drawing set up
			tickSprite = new Sprite();
			addChild(tickSprite);
			tickFill = new Shape();
			tickSprite.addChild(tickFill);			
		}
		
		private function drawTicks():void{
			//undo cacheAsBitmap optimization
			tickFill.cacheAsBitmap = false;
			
			//kill the old look
			tickFill.graphics.clear();
			tickFill.graphics.moveTo(0,0);
						
			//how wide should each tick be?
			degreesPerChamber = 360 / euHits.length;
			
			//draw them ticks
			for (var i:int=0; i<360; i++) {
				thickness = 4;
				tickFill.graphics.lineStyle(thickness,tickColor,1);
				
				if(degreeHits[i]==true){
					var dFirst:Number = (i+offset)*-1;
					var dLast:Number = Math.floor((i+degreesPerChamber-3+offset)*-1);
					//var dControl:Number = (dFirst + this.degreesPerChamber /2)*-1;
					var alphaTemp:Number = 1;
					tickFill.graphics.moveTo((circleR-thickness/2)*Math.cos(dFirst*Math.PI/180), -(circleR-thickness/2)*Math.sin(dFirst*Math.PI/180) );
					while(dFirst > dLast){
						//tickFill.graphics.curveTo(circleR*Math.cos(dControl*Math.PI/180), -circleR*Math.sin(dControl*Math.PI/180), circleR*Math.cos(dLast*Math.PI/180), -circleR*Math.sin(dLast*Math.PI/180));
						
						tickFill.graphics.lineTo(circleR*Math.cos(dFirst*Math.PI/180), -circleR*Math.sin(dFirst*Math.PI/180) );
						dFirst = dFirst - .1;
						if(alphaTemp>.4){
							alphaTemp-=.008;
						}
						tickFill.graphics.lineStyle(thickness,tickColor,alphaTemp);
					}
					//The final lineTo outside of the loop takes the "pen" back to its starting point.
					//tickFill.graphics.lineTo(0,0);
				}
			}
			
			//graphics.draw results in vectors but bitmaps are faster to work with so cache the ticks
			tickFill.cacheAsBitmap = true;			
		}
		
		public function newColor(color:Number):void{
			tickColor = color;
			redraw(circleR);
		}
		
		//sequence is a euclidean sequence for getting the beat ring right
		public function redraw(radius : Number, sequence:Array=null, tickSequence:Vector.<Boolean>=null) : void {
			//new radius
			circleR = radius;
			
			//did we get a new sequence?
			if(sequence!=null){
				euHits=sequence;
				tickHits=tickSequence;
				mapTicksToDegrees();
			}
			
			//draw back fill
			drawTicks();
			
			//punch out masking of back
			//drawMask();				
		}

		public function get _key() : String {
			return key;
		}
		
		private function mapTicksToDegrees() : void {
			//map the eu resolution to our tick resolution
			degreeHits = new Vector.<Boolean>(360);
			degreesPerTick = 360 / tickHits.length;
			for(var i:int=0;i<tickHits.length;i++){
				if(tickHits[i]==1){
					var targetDegree:Number = Math.round(i*degreesPerTick);
					degreeHits[targetDegree] = true;
				}
			}
		}

		public function get _circleR() : Number {
			return circleR;
		}
		

		
	}
}
