package model {
	import view.components.DrumHead;
	import model.DrumFactory;
	//create public static vars for easy reference without getting an instance ala
	//import model.Data; 
	//Data.margin = 2; 
    public class Data {
		//layout
		public static var margin : int;
		public static var totalTicks : int;
		public static var beaterOn : Boolean;
		public static var drums : Vector.<DrumHead> = new Vector.<DrumHead>();
		public static var alphaUp : Number = .4;
		public static var alphaDown : Number = .6;
		public static var alphaHeadUp : Number = 0.0;
		public static var alphaHeadDown : Number = 0.15;
		public static var touchScreen : Boolean = false;
		public static var fontSize : Number = 32;
		public static var userStoppedSequencer : Boolean = false;
		public static var pokeSize : Number = 40;
		public static var platform : String;
		public static var controlHeight : Number;
		public static var drumFactory : DrumFactory = new DrumFactory();
		














    	//singleton enforcing
        public function Data(enforcer:SingletonEnforcer){
        }
        private static var _instance : Data;
        public static function getInstance():Data{
            if (_instance == null){
                _instance = new Data(new SingletonEnforcer());
            }

            return _instance;
        }
    }
}
class SingletonEnforcer {}