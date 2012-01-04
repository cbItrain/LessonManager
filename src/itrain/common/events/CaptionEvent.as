package itrain.common.events
{
	import flash.events.Event;
	
	public class CaptionEvent extends Event
	{
		public static const MINIMIZE_CAPTION:String = "CaptionEventMinimize";
		public static const CAPTION_MINIMIZED:String = "CaptionEventCaptionMinimized";
		public static const MAXIMIZE_CAPTION:String = "CaptionEventMaximize";
		public static const CAPTION_MAXIMIZED:String = "CaptionEventCaptionMaximized";
		public static const CONTINUE:String = "CaptionEventContinue";
		
		public var data:Object;
		
		public function CaptionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}