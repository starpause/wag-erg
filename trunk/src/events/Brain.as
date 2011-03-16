package events
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	/**
 	* The Brain is a Singleton class which extends flash.events.EventDispatcher and is used 
 	* across the project classes to dispatch and listen to project events. The project events are 
 	* basically all public static constants in the second class called “ProjectEvent.as”. The 
 	* ProjectEvent extends flash.events.Events.
 	* This code comes from http://www.angryrocket.com/?p=113
 	* 
 	* SAMPLE USAGE:
 	* Brain.addThoughtListener(Though.SOME_EVENT, handleSomeEvent);
	* function handleSomeEvent(event:Thought):void { //functionality }
	* Brain.send(new Thought(Thought.SOME_EVENT, {param1:'something'}));
 	*/
	
	public class Brain extends EventDispatcher {
		private static var instance:Brain;
		
		public static function getInstance():Brain {
			
			if (instance == null) {
				instance = new Brain(new SingletonBlocker());
			}
			return instance;
		}
		public function Brain(blocker:SingletonBlocker):void {
			
			super();
			if (blocker == null) {
				throw new Error("Error: Instantiation failed; Use EventCentral.getInstance()");
			}
		}
		
		public static function addThoughtListener(_type:String, _listener:Function, _useCapture:Boolean=false, _priority:int=0, _useWeakReference:Boolean=false):void{
			if(instance==null){
				getInstance();
			}
			instance.addEventListener(_type, _listener, _useCapture, _priority, _useWeakReference);
		}
		
		//dispatching
		public static function send($event:Event):Boolean{			
			return instance.dispatchEvent($event);
		}
		public override function dispatchEvent($event:Event):Boolean {
			
			return super.dispatchEvent($event);
		}
	}
}

	internal class SingletonBlocker {
}