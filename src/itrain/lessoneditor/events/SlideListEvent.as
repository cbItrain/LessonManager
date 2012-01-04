package itrain.lessoneditor.events
{
	import flash.events.Event;
	
	import itrain.common.model.vo.SlideVO;
	
	public class SlideListEvent extends Event
	{
		public static const REMOVE_SLIDE:String = "SlideListEventRemoveSlide";
		public static const SLIDE_REMOVED:String = "SlideListEventSlideRemoved";
		public static const COPY_SLIDE:String = "SlideListEventCopySlide";
		public static const SLIDE_COPIED:String = "SlideListEventSlideCopied";
		
		public var slide:SlideVO;
		
		public function SlideListEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}