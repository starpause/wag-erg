package util {
	import flash.geom.ColorTransform;
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

		/**
		 * Convert a uint (0x000000) to a color object.
		 *
		 * @param hex  Color.
		 * @return Converted object {r:, g:, b:}
		 */
		public static function hexToRGB(hex:uint):Object{
			var c:Object = {};
			c.a = hex >> 24 & 0xFF;
			c.r = hex >> 16 & 0xFF;
			c.g = hex >> 8 & 0xFF;
			c.b = hex & 0xFF;
			return c;
		}
		
		/**
		 * Convert a color object to uint octal (0x000000).
		 *
		 * @param c  Color object {r:, g:, b:}.
		 * @return Converted color uint (0x000000).
		 */
		public static function RGBToHex(c:Object):uint{
		    var ct:ColorTransform = new ColorTransform(0, 0, 0, 0, c.r, c.g, c.b, 100);
		    return ct.color as uint;
		}

	
	}	
}
