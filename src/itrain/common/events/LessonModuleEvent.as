package itrain.common.events
{
	import flash.events.Event;
	
	public class LessonModuleEvent extends Event
	{
		public static const MODULE_CREATION_COMPLETE:String = "LessonModuleEventCreationComplete";
		public static const PREPARE_TO_UNLOAD:String = "LessonModuleEventPrepareToUnload";
		
		public function LessonModuleEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}