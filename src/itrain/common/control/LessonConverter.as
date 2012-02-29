package itrain.common.control
{
	import flash.events.IEventDispatcher;
	
	import itrain.common.events.CaptureImporterEvent;
	import itrain.common.events.CaptureLoaderEvent;
	import itrain.common.events.LessonConverterEvent;
	import itrain.common.model.vo.CaptureVOWrapper;
	import itrain.common.model.vo.LessonVO;
	import itrain.common.model.vo.SlideVO;
	import itrain.lessoneditor.model.CaptureVO;
	import itrain.lessoneditor.model.SlideCaptureVO;
	
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectProxy;

	public class LessonConverter
	{
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		private var _captureWrapper:CaptureVOWrapper = null;
		
		public function LessonConverter()
		{
		}
		
		[Mediate(event="CaptureImporterEvent.IMPORT_ALL_CAPTURES")]
		public function onImportAll(e:CaptureImporterEvent):void {
			if (e.toImport.slides.length) {
				var ev:LessonConverterEvent = new LessonConverterEvent(LessonConverterEvent.ADD_SLIDES, true);
				ev.slides = fromCapture(e.toImport.slides.source, e.additionalData);
				dispatcher.dispatchEvent(ev);
			} else {
				_captureWrapper = new CaptureVOWrapper(e.toImport as CaptureVO); // needs to be changed as there might be other objects
				var ce:CaptureLoaderEvent = new CaptureLoaderEvent(CaptureLoaderEvent.LOAD_CAPTURE);
				ce.url = _captureWrapper.capture.source;
				dispatcher.dispatchEvent(ce);
			}
		}
		
		[Mediate(event="CaptureLoaderEvent.CAPTURE_LOADED")]
		public function onCaptureSlide(ce:CaptureLoaderEvent):void {
			if (_captureWrapper && _captureWrapper.capture.source == ce.url) {
				var ev:LessonConverterEvent = new LessonConverterEvent(LessonConverterEvent.ADD_SLIDES, true);
				ev.slides = fromCapture(ce.captures, _captureWrapper.imagesOnly);
				dispatcher.dispatchEvent(ev);
				_captureWrapper = null;
			}
		}
		
		[Mediate(event="CaptureImporterEvent.IMPORT_SELECTED_CAPTURES")]
		public function onImportSelected(e:CaptureImporterEvent):void {
			var ev:LessonConverterEvent = new LessonConverterEvent(LessonConverterEvent.ADD_SLIDES, true);
			ev.slides = fromCapture(e.toImport.slides.source.filter(onlySelectedFilterFunction), e.additionalData);
			dispatcher.dispatchEvent(ev);
		}
		
		public function getLessonXML(lesson:LessonVO):XML {
			return lesson.convertToXML();
		}
		
		public function getLessonXMLString(lesson:LessonVO):String {
			return lesson.convertToXMLString();
		}
		
		private function onlySelectedFilterFunction(item:Object, index:int, array:Array):Boolean {
			return item.selected;
		}
		
		public function parseToLesson(o:ObjectProxy):LessonVO {
			return LessonVO.newInstanceFromProxy(o);
		}
		
		private function fromCapture(collection:Array, imagesOnly:Boolean):Array {
			var result:Array = [];
			for each (var sc:SlideCaptureVO in collection) {
				result.push(SlideVO.fromSlideCapture(sc, imagesOnly));
			}
			return result;
		}
		
	}
}