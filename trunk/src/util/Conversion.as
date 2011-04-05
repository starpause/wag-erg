package util {
	import flash.system.Capabilities;
	/**
	 * @author jgray
	 */
	public class Conversion {

		public static function inchesToPixels(inches:Number):uint{
		   return Math.round(Capabilities.screenDPI * inches);
		}
		
		public static function mmToPixels(mm:Number):uint{
		   return Math.round(Capabilities.screenDPI * (mm / 25.4));
		}

	}
	
	
}
