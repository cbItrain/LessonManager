package itrain.common.events
{
	import flash.events.Event;
	
	public class LessonConverterEvent extends Event
	{
		public static const ADD_SLIDES:String = "LessonConverterEventAddSlides";
		
		public var slides:Array;
		
		public function LessonConverterEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}