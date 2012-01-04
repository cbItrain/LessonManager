package itrain.lessoneditor.events
{
	import flash.events.Event;
	
	import itrain.common.model.vo.ChangeAwareModel;
	import itrain.common.model.vo.SlideObjectVO;
	
	public class EditorEvent extends Event
	{
		public static const OBJECT_SELECTION_CHANGE:String = "EditorEventObjectSelectionChange";
		public static const CLEAR_OBJECT_SELECTION:String = "EditorEventObjectClearObjectSelection";
		public static const REMOVE_OBJECT:String = "EditorEventRemoveObject";
		public static const OBJECT_REMOVED:String = "EditorEventObjectRemoved";
		public static const ADD_OBJECT:String = "EditorEventAddObject";
		public static const REMOVE_SLIDES_SILENTLY:String = "EditorEventRemoveSlidesSilently";
		public static const ADD_SLIDES_SILENTLY:String = "EditorEventAddSlidesSilently";
		public static const REORDER_SLIDE_SILENTLY:String = "EditorEventReorderSlideSilently";
		public static const SLIDES_ADDED_SILENTLY:String = "EditorEventSlidesAddedSilently";
		public static const SLIDES_REMOVED_SILENTLY:String = "EditorEventSlidesRemovedSilently";
		public static const SLIDES_REORDERED_SILENTLY:String = "EditorEventSlidesReorderedSilently";
		public static const OBJECT_ADDED:String = "EditorEventObjectAdded";
		public static const PREPARE_OBJECT:String = "EditorEventPrepareObject";
		public static const SCALE_CHANGE:String = "EditorEventScaleChange";
		public static const SHOW_WATCH_IT_PLAYER:String = "EditorEventShowWatchItPlayer";
		public static const SHOW_CAPTURE_IMPORTER:String = "EditorEventShowCaptureImporter";
		public static const UNDO:String = "EditorEventUndo";
		public static const REDO:String = "EditorEventRedo";
		public static const ENABLE_PROPERTY_CHANGE_TRACKING:String = "EditorEventEnablePropertyChangeTracking";
		public static const DISABLE_PROPERTY_CHANGE_TRACKING:String = "EditorEventDisablePropertyChangeTracking";
		public static const EDIT_SLIDE_INSTRUCTION:String = "EditorEventEditSlideInstruction";
		public static const HIDE_SLIDE_INSTRUCTION:String = "EditorEventHideSlideInstruction";
		public static const SLIDE_INSTRUCTION_SHOWN:String = "EditorEventSlideInstructionShown";
		public static const SLIDE_INSTRUCTION_HIDDEN:String = "EditorEventSlideInstructionHidden";
		public static const REQUEST_CLEAR_CACHE:String = "EditorEventRequestClearCache";
		public static const SCROLLS_ENABLED:String = "EditorEventScrollsEnabled";
		public static const CAPTIONS_STYLE_CHANGES:String = "EditorEventCaptionsStyleChanges";
		public static const PREVIEW_HIGHLIGHT_ANIMATION:String = "EditorEventPreviewHighlightAnimation";
		public static const SPELL_CHECK_CHANGES:String = "EditorEventSpellCheckChanges";
		public static const BACKGROUND_IMAGE_VISIBLE:String = "EditorEventBackgroundImageVisible";
		public static const SPELL_CHECK_COMPLETED:String = "EditorEventSpellCheckCompleted";
		
		public var model:ChangeAwareModel;
		
		public var additionalData:Object;
		
		public function EditorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}