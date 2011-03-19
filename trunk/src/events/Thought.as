package events{
	import flash.events.Event;
	
	 /**
	 * This Class defines public constants for all the module wide events in the module
	 * They are edispatched via a Singleton class EventCentral
	 * 
	 * SAMPLE USAGE:
     * Brain.addThoughtListener(Though.SOME_EVENT, handleSomeEvent);
	 * function handleSomeEvent(event:Thought):void { //functionality }
 	 * Brain.send(new Thought(Thought.SOME_EVENT, {param1:'something'}));
	 */

	public class Thought extends Event {
		public static const ADD_DRUM : String = "ADD_DRUM";
		public static const SEQ_HEAD_HIT : String = "SEQ_HEAD_HIT";
		public static const DRUM_HEAD_HIT : String = "DRUM_HEAD_HIT";
		public static const ERASE_DRUM : String = "ERASE_DRUM";
		public static const ON_BEAT : String = "ON_BEAT";
		public static const ADD_DRUM_COMPLETE : String = "ADD_DRUM_COMPLETE";
		public static const ON_TICK : String = "ON_TICK";
		public static const CLONE_DRUM : String = "CLONE_DRUM";
		public static const STOP_SEQ : String = "STOP_SEQ";
		public static const START_SEQ : String = "START_SEQ";
		public static const ADD_RING : String = "ADD_RING";
		public static const ON_GHOST : String = "ON_GHOST";
		public static const RANDOMIZE_SEQUENCE : String = "RANDOMIZE_SEQUENCE";
		public static const UPDATE_RINGS : String = "UPDATE_RINGS";
		public static const RANDOMIZE_COLOR : String = "RANDOMIZE_COLOR";
		public static const NEW_COLOR : String = "NEW_COLOR";





		//boilerplate
		public var params:Object;
		public function Thought($type:String, $params:Object = null) {
			super($type, true, true);
			this.params = $params;
		}
		
		public override function clone():Event {
			
			return new Thought(this.type,this.params);
		}
		
		override public function toString():String {
			
			return ("[Event ProjectEvent]");
		}
	}
}