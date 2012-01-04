package itrain.lessoneditor.model
{
	import flash.events.IEventDispatcher;
	
	import itrain.common.events.CaptureLoaderEvent;
	import itrain.common.events.LessonConverterEvent;
	import itrain.common.events.LessonLoaderEvent;
	import itrain.common.model.vo.CaptionVO;
	import itrain.common.model.vo.HighlightVO;
	import itrain.common.model.vo.HotspotVO;
	import itrain.common.model.vo.SlideVO;
	import itrain.common.model.vo.TextFieldVO;
	import itrain.lessoneditor.events.EditorEvent;
	import itrain.lessoneditor.events.MessageEvent;
	import itrain.lessonplayer.view.elements.Hotspot;

	public class MessageBean
	{
		
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		[Mediate(event="LessonLoaderEvent.LESSON_SAVED")]
		public function onLessonSave():void {
			showMessage("Lesson has been saved", null, "", "", true);
		}
		
		[Mediate(event="LessonLoaderEvent.LESSON_SAVE_FAULT")]
		public function onLessonSaveFault(lle:LessonLoaderEvent):void {
			showMessage("An Error has occured during the saving process", EnumMessageSeverity.MAJOR, lle.sendParameters.description, lle.sendParameters.technical);
		}
		
		[Mediate(event="LessonLoaderEvent.LESSON_LOAD_FAULT")]
		public function onLessonLoadFault(lle:LessonLoaderEvent):void {
			showMessage("An Error has occured during data loading process", EnumMessageSeverity.MAJOR, lle.sendParameters.description, lle.sendParameters.technical);
		}
		
		[Mediate(event="CaptureLoaderEvent.CAPTURE_LIST_LOAD_FAULT")]
		public function onCaptureListLoadFault(cle:CaptureLoaderEvent):void {
			showMessage("An Error has occured during the capture list loading process", EnumMessageSeverity.MAJOR, cle.additionalData.description, cle.additionalData.technical);
		}
		
		[Mediate(event="CaptureLoaderEvent.CAPTURE_LOAD_FAULT")]
		public function onCaptureLoadFault(cle:CaptureLoaderEvent):void {
			showMessage("An Error has occured during capture loading process", EnumMessageSeverity.MAJOR, cle.additionalData.description, cle.additionalData.technical);
		}
		
		[Mediate(event="LessonConverterEvent.ADD_SLIDES")]
		public function onImport(e:LessonConverterEvent):void {
			var message:String = " slide";
			if (e.slides.length != 1)
				message+="s";
			message = e.slides.length + message + " has been imported from the capture";
			showMessage(message);
		}
		
		[Mediate(event="SlideListEvent.REMOVE_SLIDE")]
		public function onRemoveSlide():void {
			showMessage("Slide has been removed");
		}
		
		[Mediate(event="SlideListEvent.COPY_SLIDE")]
		public function onCopySlide():void {
			showMessage("Slide has been coppied");
		}
		
		[Mediate(event="EditorEvent.OBJECT_ADDED")]
		public function onAddedObject(e:EditorEvent):void {
			var oString:String = "Object";
			if (e.model is CaptionVO)
				oString = "Caption";
			else if (e.model is TextFieldVO)
				oString = "Textfield";
			else if (e.model is HotspotVO)
				oString = "Hotspot";
			else if (e.model is HighlightVO)
				oString = "Highlight";
			showMessage(oString + " has been added");
			if ((e.additionalData as SlideVO).hotspots.length == 0) {
				showMessage("No hotspot on the slide - ENTER will be used to move forward", EnumMessageSeverity.HINT);
			}
		}
		
		[Mediate(event="EditorEvent.OBJECT_REMOVED")]
		public function onRemovedObject(e:EditorEvent):void {
			var oString:String = "Object";
			if (e.model is CaptionVO)
				oString = "Caption";
			else if (e.model is TextFieldVO)
				oString = "Textfield";
			else if (e.model is HotspotVO)
				oString = "Hotspot";
			else if (e.model is HighlightVO)
				oString = "Hightlight";
			showMessage(oString + " has been removed");
		}
		
		
		[Mediate(event="EditorEvent.PREPARE_OBJECT")]
		public function onPrepareObject(e:EditorEvent):void {
			var oString:String;
			if (e.model is CaptionVO)
				oString = "Caption";
			else if (e.model is TextFieldVO)
				oString = "Textfield";
			else if (e.model is HotspotVO)
				oString = "Hotspot";
			else if (e.model is HighlightVO)
				oString = "Highlight";
			if (oString)
				showMessage("Double click on slide or start drawing to add a " + oString, EnumMessageSeverity.HINT);
		}
		
		[Mediate(event="EditorEvent.SCROLLS_ENABLED")]
		public function onScrollsEnabled(e:EditorEvent):void {
			showMessage("Drag the slide to do the scrolling", EnumMessageSeverity.HINT);
		}
		
		[Mediate(event="EditorEvent.OBJECT_SELECTION_CHANGE")]
		public function onObjectSelectionChange(ee:EditorEvent):void {
			if (ee.model is CaptionVO) {
				showMessage("Click and drag the yellow handler to adjust pointer position", EnumMessageSeverity.HINT);
			}
		}
		
		private function showMessage(message:String, severity:EnumMessageSeverity = null, description:String = "", additionalInfo:String = "", highPriority:Boolean = false):void {
			var me:MessageEvent = new MessageEvent(MessageEvent.SHOW_MESSAGE, true);
			me.message = message;
			me.description = description;
			me.additionalInfo = additionalInfo;
			me.highPriority = highPriority;
			if (!severity)
				severity = EnumMessageSeverity.NORMAL;
			me.messageSeverity = severity;
			dispatcher.dispatchEvent(me);
		}
	}
}