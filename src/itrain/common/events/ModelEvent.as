package itrain.common.events
{
	import flash.events.Event;
	
	import itrain.common.model.vo.SlideVO;
	
	public class ModelEvent extends Event
	{
		public static const LESSON_READY:String = "ModelEventLessonReady";
		public static const SLIDE_IMAGE_READY:String = "ModelEventImageReady";
		public static const SLIDE_IMAGE_NOT_AVAILABLE:String = "ModelEventImageNotAvailable";
		public static const SLIDE_SELECTION_CHANGE:String = "ModelEventSlideSelectionChange";
		public static const CHANGE_SLIDE_SELECTION:String = "ModelEventChangeSlideSelection";
		
		public var slideIndex:int;
		public var prevSlideIndex:int;
		public var slide:SlideVO;
		public var url:String;
		public var additionalData:Object;
		
		public function ModelEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}