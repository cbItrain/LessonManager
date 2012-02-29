package itrain.lessoneditor.events
{
	import flash.events.Event;
	
	import itrain.lessoneditor.model.CaptureVO;
	
	public class CaptureListItemRendererEvent extends Event
	{
		public static const DOUBLE_CLICKED:String = "CaptureListItemRendererEventDoubleClicked";
		
		public var capture:CaptureVO;
		
		public function CaptureListItemRendererEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}