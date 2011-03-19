package model {
	import view.components.DrumHead;
	//create public static vars for easy reference without getting an instance ala
	//import model.Data; 
	//Data.margin = 2; 
    public class Data{
		//layout
		public static var margin : int;
		public static var totalTicks : int;
		public static var beaterOn : Boolean;
		public static var drums:Vector.<DrumHead> = new Vector.<DrumHead>();

		//
		














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