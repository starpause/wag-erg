package view.components {
	import model.Data;
	import events.Brain;
	import events.Thought;
	import flash.display.Sprite;

	/**
	 * @author jgray
	 */
	public class PositionIndicator extends Sprite {
		private var circleR:Number = 0;
		private var offset:Number = -90; //initial angle, -90 is 12 o'clock
		private var dial:Sprite = new Sprite();
		private var ghost:Sprite = new Sprite();
		
		public function PositionIndicator(_radius:Number) {
			circleR = _radius;
			addChild(ghost);
			addChild(dial);
			
			Brain.addThoughtListener(Thought.ON_TICK, onTick);
			Brain.addThoughtListener(Thought.ON_GHOST, onGhost);
		}
		
		public function onTick(position:Number):void{
			//map total ticks against 360
			var x:Number = 360/Data.totalTicks;
			var i:Number = (x*position)+offset;
			i = i*-1;
			
			dial.graphics.clear();
			dial.graphics.lineStyle(1,0xFFFFFF);
			dial.graphics.moveTo(0,0);
			dial.graphics.beginFill(0xFFFFF,1);	
			dial.graphics.lineTo(circleR*Math.cos(i*Math.PI/180), -circleR*Math.sin(i*Math.PI/180) );
			dial.graphics.lineTo(0,0);
			dial.graphics.endFill();			
		}
		
		public function onGhost(position:Number):void{
			var ghostAlpha:Number = .2;
			//map total ticks against 360
			var x:Number = 360/Data.totalTicks;
			var i:Number = (x*position)+offset;
			i = i*-1;
			
			ghost.graphics.clear();
			ghost.graphics.lineStyle(1,0xFFFFFF,ghostAlpha);
			ghost.graphics.moveTo(0,0);
			ghost.graphics.beginFill(0xFFFFF,ghostAlpha);	
			ghost.graphics.lineTo(circleR*Math.cos(i*Math.PI/180), -circleR*Math.sin(i*Math.PI/180) );
			ghost.graphics.lineTo(0,0);
			ghost.graphics.endFill();			
		}
	}
}
