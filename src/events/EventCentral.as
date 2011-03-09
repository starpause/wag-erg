package events
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	/**
 	* The EventCentral is a Singleton class which extends flash.events.EventDispatcher and is used 
 	* across the project classes to dispatch and listen to project events. The project events are 
 	* basically all public static constants in the second class called “ProjectEvent.as”. The 
 	* ProjectEvent extends flash.events.Events.
 	* This code comes from http://www.angryrocket.com/?p=113
 	* 
 	* SAMPLE USAGE:
 	* EventCentral.getInstance().addEventListener('ProjectEvent.SOME_EVENT', handleSomeEvent);
	* function handleSomeEvent(event:pVent):void { //functionality }
	* EventCentral.getInstance().dispatchEvent(new pVent(pVent.SOME_EVENT, {param1:'something'}));
 	*/
	
	public class EventCentral extends EventDispatcher {
		
		private static  var instance:EventCentral;
		
		public static function getInstance():EventCentral {
			
			if (instance == null) {
				instance = new EventCentral(new SingletonBlocker());
			}
			return instance;
		}
		public function EventCentral(blocker:SingletonBlocker):void {
			
			super();
			if (blocker == null) {
				throw new Error("Error: Instantiation failed; Use EventCentral.getInstance()");
			}
		}
		
		public override function dispatchEvent($event:Event):Boolean {
			
			return super.dispatchEvent($event);
		}
	}
}

	internal class SingletonBlocker {
}