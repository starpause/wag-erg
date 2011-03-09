package events
{
	import flash.events.Event;
	
	 /**
	 * This Class defines public constants for all the module wide events in the module
	 * They are edispatched via a Singleton class EventCentral
	 * 
	 * SAMPLE USAGE:
	 * EventCentral.getInstance().addEventListener('ProjectEvent.SOME_EVENT', handleSomeEvent);
	 * function handleSomeEvent(event:ProjectEvent):void { //functionality }
	 * EventCentral.getInstance().dispatchEvent(new ProjectEvent('ProjectEvent.SOME_EVENT', {param1:'something'}));
	 */


	public class pVent extends Event {
		public static const ADD_DRUM : String = "ADD_DRUM";
		public static const SEQ_HEAD_HIT : String = "SEQ_HEAD_HIT";
		public static const DRUM_HEAD_HIT : String = "DRUM_HEAD_HIT";
		
		public var params:Object;
		public function pVent($type:String, $params:Object = null) {
			super($type, true, true);
			this.params = $params;
		}
		
		public override function clone():Event {
			
			return new pVent(this.type,this.params);
		}
		
		override public function toString():String {
			
			return ("[Event ProjectEvent]");
		}
	}
}