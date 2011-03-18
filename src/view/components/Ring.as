package view.components {
	/**
	 * @author jgray
	 */
	
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	
	public class Ring extends Sprite{
		private var fillColor:Number;
		private var backColor:Number;
		private var maskColor:Number = 0xFF0000;
		
		private var offset:Number = 90;// Initial angle
		private var circleR:Number; // Circle radius (in pixels)
		private var maskR:Number;
		
		private var backFill:Shape;
		private var backBoard:Sprite;
		private var maskFill:Shape;
		private var maskBoard:Sprite;
		
		private var foreFill:Shape
		private var foreBoard:Sprite;		
		private var maskForeFill:Shape;
		private var maskForeBoard:Sprite;
		private var thickness:int = 3;
		private var key:String;
		
		public function Ring(radius:Number=29, _key:String="", foreColor:Number=0xFFFFFF, backgroundColor:Number=0x888888){
			key = _key;
			name = _key;
			fillColor = foreColor;
			backColor = backgroundColor;
			circleR = radius;
			
			//
			backBoard = new Sprite();
			addChild(backBoard);
			backFill = new Shape();
			backBoard.addChild(backFill);		
			
			//punchout
			maskBoard = new Sprite();
			maskFill = new Shape();
			maskBoard.addChild(maskFill);
			backBoard.blendMode = BlendMode.LAYER;
			maskBoard.blendMode = BlendMode.ERASE;
			backBoard.addChild(maskBoard);				
		}
		
		private function drawMask():void{
			maskFill.graphics.clear();
			maskFill.graphics.lineStyle(1,maskColor);
			maskFill.graphics.moveTo(0,0);
			maskFill.graphics.beginFill(maskColor,1);//.7
			
			for (var i:int=0; i<361; i++) {
				maskFill.graphics.lineTo(maskR*Math.cos(i*Math.PI/180), -maskR*Math.sin(i*Math.PI/180) );
			}

			//The final lineTo outside of the loop takes the "pen" back to its starting point.
			maskFill.graphics.lineTo(0,0);
			
			//Since the drawing is between beginFill and endFill, we get the filled shape.
			maskFill.graphics.endFill();
		}

		private function drawForeMask():void{
			maskForeFill.graphics.clear();
			maskForeFill.graphics.lineStyle(1,maskColor);
			maskForeFill.graphics.moveTo(0,0);
			maskForeFill.graphics.beginFill(maskColor,1);//.7
			
			for (var i:int=0; i<361; i++) {
				maskForeFill.graphics.lineTo(maskR*Math.cos(i*Math.PI/180), -maskR*Math.sin(i*Math.PI/180) );
			}

			//The final lineTo outside of the loop takes the "pen" back to its starting point.
			maskForeFill.graphics.lineTo(0,0);
			
			//Since the drawing is between beginFill and endFill, we get the filled shape.
			maskForeFill.graphics.endFill();
		}

		private function drawBack():void{
			backFill.graphics.clear();
			backFill.graphics.lineStyle(1,backColor);
			backFill.graphics.moveTo(0,0);
			backFill.graphics.beginFill(backColor,1);//.7
			
			for (var i:int=0; i<361; i++) {
				backFill.graphics.lineTo(circleR*Math.cos(i*Math.PI/180), -circleR*Math.sin(i*Math.PI/180) );
			}

			//The final lineTo outside of the loop takes the "pen" back to its starting point.
			backFill.graphics.lineTo(0,0);
			
			//Since the drawing is between beginFill and endFill, we get the filled shape.
			backFill.graphics.endFill();
		}
		
		
		public function update(percent:Number):void{
			//t is in degrees
			var t:Number = 360*(percent);
			
			foreFill.graphics.clear();
			foreFill.graphics.lineStyle(1,fillColor);
			foreFill.graphics.moveTo(0,0);
			foreFill.graphics.beginFill(fillColor,1);//.7
			
			// The loop draws tiny lines between points on the circle one
			// separated from each other by one degree.
			for (var i:int=0+offset; i>=(offset-t); i--) {
				foreFill.graphics.lineTo(circleR*Math.cos(i*Math.PI/180), -circleR*Math.sin(i*Math.PI/180) );
			}
			
			//The final lineTo outside of the loop takes the "pen" back to its starting point.
			foreFill.graphics.lineTo(0,0);
			
			//Since the drawing is between beginFill and endFill, we get the filled shape.
			foreFill.graphics.endFill();
		}

		//sequence is a euclidean sequence for getting the beat ring right
		public function redraw(radius : Number, sequence:Array) : void {
			//new radius
			circleR = radius;
			//required for punch out mask
			maskR = circleR - thickness;						
			
			//draw back fill
			drawBack();
			
			//punch out masking of back
			drawMask();
				
			/*		
			//draw front fill
			foreBoard = new Sprite();
			foreFill = new Shape();
			addChild(foreBoard);
			foreBoard.addChild(foreFill);
			//drawFore(); //done every update
			
			//punch out masking of front
			maskForeBoard = new Sprite();
			maskForeFill = new Shape();
			maskForeBoard.addChild(maskForeFill);
			drawForeMask();
			foreBoard.blendMode = BlendMode.LAYER;
			maskForeBoard.blendMode = BlendMode.ERASE;
			foreBoard.addChild(maskForeBoard);
			
			//Glow Filter
			var glow:GlowFilter = new GlowFilter();
			glow.color = fillColor;
			glow.alpha = .4;
			glow.blurX = 8;
			glow.blurY = 8;
			var filtersArray:Array = new Array(glow);
			foreBoard.filters = filtersArray;
			*/
		}

		public function get _key() : String {
			return key;
		}
		
		
	}
}
