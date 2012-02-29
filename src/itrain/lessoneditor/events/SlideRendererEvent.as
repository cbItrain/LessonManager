package itrain.lessoneditor.events
{
	import flash.events.Event;
	
	public class SlideRendererEvent extends Event
	{
		public static const DELETE:String = "SlideRendererEventDelete";
		public static const COPY:String = "SlideRendererEventCopy";
		
		public function SlideRendererEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}