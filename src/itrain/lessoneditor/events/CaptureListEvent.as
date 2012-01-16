package itrain.lessoneditor.events
{
	import flash.events.Event;
	
	public class CaptureListEvent extends Event
	{
		public static const CAPTURE_DONE:String = "CaptureListEventCaptureDone";
		
		public var data:Object;
		
		public function CaptureListEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}