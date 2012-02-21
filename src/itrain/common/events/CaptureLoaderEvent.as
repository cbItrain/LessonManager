package itrain.common.events
{
	import flash.events.Event;
	
	public class CaptureLoaderEvent extends Event
	{
		public static const CAPTURE_LIST_LOADED:String = "CaptureLoaderEventCaptureListLoaded";
		public static const CAPTURE_LOADED:String = "CaptureLoaderEventCaptureLoaded";
		public static const CAPTURE_LIST_LOAD_FAULT:String = "CaptureLoaderEventCaptureListLoadFault";
		public static const CAPTURE_LOAD_FAULT:String = "CaptureLoaderEventCaptureLoadFault";
		public static const LOAD_CAPTURE_LIST:String = "CaptureLoaderEventLoadCaptureList";
		public static const LOAD_CAPTURE:String = "CaptureLoaderEventLoadCapture";
		public static const REPORT_SENT:String = "CaptureLoaderEventReportSent";
		public static const REPORT_FAULT:String = "CaptureLoaderEventReportFault";
		public static const SEND_REPORT:String = "CaptureLoaderEventSendReport";
		
		public var url:String;
		public var captures:Array;
		public var additionalData:Object;
		public var id:int;
		
		public function CaptureLoaderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}