package model{
	//create public static vars for easy reference without getting an instance ala
	//import model.Data; 
	//Data.margin = 2; 
    public class Data{
		//layout
		public static var margin:int;

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