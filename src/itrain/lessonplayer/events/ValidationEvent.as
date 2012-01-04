package itrain.lessonplayer.events
{
	import flash.events.Event;
	
	public class ValidationEvent extends Event
	{
		public static const VALIDATION_EVENT:String = "ValidationEventValidationEvent";
		public static const	LESSON_COMPLETE:String = "ValidationEventComplete";
		public static const	LESSON_RESET:String = "ValidationEventReset";

		public var valid:Boolean = false;
		public var message:String = "";
		
		public function ValidationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}