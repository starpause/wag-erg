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
		private var offset:Number = 90; //initial angle, 90 is 12 o'clock
		
		public function PositionIndicator(_radius:Number) {
			circleR = _radius;
			Brain.addThoughtListener(Thought.ON_TICK, onTick);
		}
		
		private function onTick(event:Thought):void{
			//map total ticks against 360
			var x:Number = 360/Data.totalTicks;
			var i:Number = (x*event.params['position'])+offset;
			
			this.graphics.clear();
			this.graphics.lineStyle(1,0xFFFFFF);
			this.graphics.moveTo(0,0);
			this.graphics.beginFill(0xFFFFF,1);	
			this.graphics.lineTo(circleR*Math.cos(i*Math.PI/180), -circleR*Math.sin(i*Math.PI/180) );
			this.graphics.lineTo(0,0);
			this.graphics.endFill();			
		}
	}
}
