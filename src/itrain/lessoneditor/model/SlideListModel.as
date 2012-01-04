package itrain.lessoneditor.model
{
	import flash.events.IEventDispatcher;
	import flash.utils.setTimeout;
	
	import itrain.common.events.LessonLoaderEvent;
	import itrain.common.events.ModelEvent;
	import itrain.common.model.vo.SlideVO;
	import itrain.lessoneditor.events.EditorEvent;
	import itrain.lessoneditor.events.SlideListEvent;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.events.CollectionEvent;

	public class SlideListModel
	{		
		[Bindable] public var slides:ArrayCollection;
		[Bindable] public var currentlySelectedIndex:int = -1;
		[Bindable] public var currentlySelected:SlideVO;
		
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		[Mediate(event="LessonLoaderEvent.LESSON_LOADED")]
		public function lessonLoaded(e:LessonLoaderEvent):void{
			slides = e.lesson.slides;
			setSelectedAt(0);
		}
		
		public function setSelectedAt(index:int):void {
			var me:ModelEvent = new ModelEvent(ModelEvent.SLIDE_SELECTION_CHANGE);
			me.prevSlideIndex = currentlySelectedIndex;
			
			if (index >= 0 && slides && slides.length > index) {
				currentlySelectedIndex = index;
				currentlySelected = slides[index] as SlideVO;
			} else {
				currentlySelected = null;
				currentlySelectedIndex = -1;
			}
			
			me.slideIndex = currentlySelectedIndex;
			me.slide = currentlySelected;
			dispatcher.dispatchEvent(me);
		}
		
		[Mediate(event="SlideListEvent.REMOVE_SLIDE")]
		public function onRemoveSlide(ev:SlideListEvent):void {
			var toRemove:SlideVO = ev.slide;
			if (toRemove == currentlySelected) {
				if (currentlySelectedIndex > 0)
					setSelectedAt(currentlySelectedIndex - 1);
				else if (currentlySelectedIndex < slides.length - 1)
					setSelectedAt(currentlySelectedIndex + 1);
				else
					setSelectedAt(-1);
			}
			var removeIndex:int = slides.getItemIndex(toRemove);
			if (removeIndex > -1) {
				slides.removeItemAt(removeIndex);
				if (removeIndex <= currentlySelectedIndex)
					currentlySelectedIndex--;
			}
			
			var sle:SlideListEvent = new SlideListEvent(SlideListEvent.SLIDE_REMOVED, true);
			sle.slide = toRemove;
			dispatcher.dispatchEvent(sle);
		}
		
		[Mediate(event="SlideListEvent.COPY_SLIDE")]
		public function onCopySlide(ev:SlideListEvent):void {
			var toCopy:SlideVO = ev.slide;
			var copy:SlideVO = toCopy.clone();
			var index:int = slides.getItemIndex(toCopy);
			if (index > -1) {
				index++;
				slides.addItemAt(copy, index);
				setSelectedAt(index);
			}
			var sle:SlideListEvent = new SlideListEvent(SlideListEvent.SLIDE_COPIED, true);
			sle.slide = toCopy;
			dispatcher.dispatchEvent(sle);
		}
		
		[Mediate(event="EditorEvent.REMOVE_SLIDES_SILENTLY")]
		public function onEditorSlidesRemoveSilently(ev:EditorEvent):void {
			var array:Array = ev.additionalData as Array;
			var target:Array = slides.source;
			var index:int;
			for each (var si:SlideIndex in array) {
				index = target.indexOf(si.slide);
				if (index > -1)
					target.splice(index, 1);
			}
			slides.refresh();
			dispatcher.dispatchEvent(new EditorEvent(EditorEvent.SLIDES_REMOVED_SILENTLY, true));
		}
		
		[Mediate(event="EditorEvent.ADD_SLIDES_SILENTLY")]
		public function onEditorSlidesAddSilently(ev:EditorEvent):void {
			var array:Array = ev.additionalData as Array;
			var target:Array = slides.source;
			array.sortOn("index");
			for each (var si:SlideIndex in array) {
				if (si.index < target.length)
					target.splice(si.index, 0, si.slide);
				else
					target.push(si.slide);
			}
			if (array.length) {
				slides.refresh();
			}
			dispatcher.dispatchEvent(new EditorEvent(EditorEvent.SLIDES_ADDED_SILENTLY, true));
		}
		
		[Mediate(event="EditorEvent.REORDER_SLIDE_SILENTLY")]
		public function onEditorSlideReorderSilently(ev:EditorEvent):void {
			var target:Array = slides.source;
			var index:int = target.indexOf(ev.model);
			if (index > -1) {
				target.splice(index, 1);
				if (ev.additionalData < target.length - 1)
					target.splice(ev.additionalData, 0, ev.model);
				else 
					target.push(ev.model);
				slides.refresh();
			}
			dispatcher.dispatchEvent(new EditorEvent(EditorEvent.SLIDES_REORDERED_SILENTLY, true));
		}
		
		[Mediate(event="ModelEvent.CHANGE_SLIDE_SELECTION")]
		public function onChangeSlideSelection(ev:ModelEvent):void {
			setSelectedAt(ev.slideIndex);
		}
		
	}
}