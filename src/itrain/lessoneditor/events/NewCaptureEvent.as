package itrain.lessoneditor.events
{
	import flash.events.Event;
	
	public class NewCaptureEvent extends Event
	{
		public static const REPORT_ISSUE:String = "NewCaptureEventReportIssue";
		public static const CAPTURE_COMPLETED:String = "NewCaptureEventCaptureCompleted";
		
		public var captureId:int;
		
		public function NewCaptureEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}