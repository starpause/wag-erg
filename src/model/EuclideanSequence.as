package model {
	/**
	 * @author jgray
	 */
	public class EuclideanSequence {
		private var tickHits:Vector.<Boolean>;
		private var totalTicks:int;
		
		private var pulses:int;
		private var euHits:Array;
		
		public function EuclideanSequence(_totalTicks:int):void{
			totalTicks = _totalTicks;
			randomizeHits();
		}
		
		public function randomizeHits():void{
			//clear old
			tickHits=new Vector.<Boolean>(totalTicks);
			euHits=null;
			
			//get a cool eucledean sequnce
			var chambers:int = Math.floor((Math.random()*totalTicks));
			var bullets:int = Math.floor((Math.random()*chambers));
			euHits = eugen(chambers,bullets);
			
			//map the eu resolution to our tick resolution
			var ticksPerChamber:Number = totalTicks / chambers;
			for(var i:int=0;i<chambers;i++){
				if(euHits[i]==1){
					//would Math.round be better? worried about going out of bounds
					var targetTick:Number = Math.round(i*ticksPerChamber);
					tickHits[targetTick] = true;
				}
			}
			
		}

		public function hasHitAt(position:int):Boolean{
			return tickHits[position];
		}
		
		public function hasAccentedHitAt(position:int):Boolean{
			position = position;
			return false;
		}

		private function eugen(s:int, p:int):Array {
		    var r:Array = new Array();
		    //test for input for sanity
		    if(p >= s || s == 1 || p == 0) { 
		        if (p >= s) {
		        	//give trivial rhythm of a pulse on every step
		            for (var i:int = 0; i < s; i++){ 
		                r.push(1);
		            }
		        } else if (s == 1) {
					if (p == 1) {
						r.push(1);
					} else {
						r.push(0);
					}
		        } else {
		            for (i = 0; i < s; i++) {
		                r.push(0);
		            }
		        }
		    } else { 
		    	//input was sane
		    	var remainder:Number;
		        var pauses:int = s - p;
		        if (pauses >= p) { //first case more pauses than p
		            var per_pulse:Number = Math.floor(pauses / p);
		            remainder = pauses % p;
		            for (i = 0; i < p; i++) {
		                r.push(1);
		                for (var j:int = 0; j < per_pulse; j++) {
		                    r.push(0);
		                }
		                if (i < remainder) {
		                    r.push(0);
		                }
		            }
		        } else { //second case more p than pauses
		            var per_pause:Number = Math.floor( (p - pauses) / pauses);
		            remainder = (p - pauses) % pauses;
		            for (i = 0; i < pauses; i++) {
		                r.push(1);
		                r.push(0);
		                for (j = 0; j < per_pause; j++) {
		                    r.push(1);
		                }
		                if (i < remainder) {
		                    r.push(1);
		                }
		            }
		        }
		    }
		    return r;
		}



		
	}
}
