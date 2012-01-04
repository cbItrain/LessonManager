package itrain.common.events
{
	import flash.events.Event;
	
	import itrain.common.model.vo.LessonVO;
	
	public class LessonLoaderEvent extends Event
	{
		public static const LESSON_LOADED:String = "LessonLoaderEventLessonLoaded";
		public static const LESSON_LOAD_FAULT:String = "LessonLoaderEventLessonLoadFault";
		public static const LOAD_LESSON:String = "LessonLoaderEventLoadLesson";
		public static const SET_LESSON:String = "LessonLoaderEventSetLesson";
		public static const SAVE_LESSON:String = "LessonLoaderEventSaveLesson";
		public static const LESSON_SAVED:String = "LessonLoaderLessonSaved";
		public static const LESSON_SAVE_FAULT:String = "LessonLoaderEventLessonSaveFault";
//		public static const TOGGLE_LOCK_LESSON:String = "LessonLoaderEventToggleLockLesson";
//		public static const LESSON_TOGGLE_LOCKED:String = "LessonLoaderEventLessonToggleLocked";
		
		public var lessonId:String;
		public var lessonURL:String;
		public var lessonName:String;
		public var lesson:LessonVO;
		public var sendParameters:Object;
		
		public function LessonLoaderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}