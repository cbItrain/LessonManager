package itrain.common.control {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import itrain.common.events.LessonLoaderEvent;
	import itrain.common.model.vo.CaptionVO;
	import itrain.common.model.vo.HotspotVO;
	import itrain.common.model.vo.LessonVO;
	import itrain.common.model.vo.SlideVO;
	import itrain.common.model.vo.TextFieldVO;
	import itrain.common.utils.DataUtils;
	import itrain.common.utils.LoaderUtils;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.graphics.shaderClasses.ExclusionShader;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.utils.ObjectProxy;

	public class LessonLoader {

		private static var CHUNK_SIZE:int=3000;

		[Dispatcher]
		public var dispatcher:IEventDispatcher;

		[Inject]
		public var lessonConverter:LessonConverter;

		private var _lessonLoadService:HTTPService;
		private var _lessonSaveService:HTTPService;
		private var _loadParameters:Object;
		private var _saveParameters:Object;

		public function LessonLoader() {
			_lessonLoadService=new HTTPService();
			_lessonLoadService.addEventListener(ResultEvent.RESULT, loadResult);
			_lessonLoadService.addEventListener(FaultEvent.FAULT, loadFault);

			_lessonSaveService=new HTTPService();
			_lessonSaveService.addEventListener(ResultEvent.RESULT, saveResult);
			_lessonSaveService.addEventListener(FaultEvent.FAULT, saveFault);
			_lessonSaveService.method=URLRequestMethod.POST;


			var params:Object=FlexGlobals.topLevelApplication.parameters;
			_saveParameters={};
			_loadParameters={};
			_saveParameters.lessonId=_loadParameters.lessonId=params.lessonId;
			_loadParameters.published=params.published;


			_lessonLoadService.url=params.getLessonURL;
			_lessonSaveService.url=params.saveLessonURL;
		}

		[Mediate(event="LessonLoaderEvent.LOAD_LESSON")]
		public function loadData(le:LessonLoaderEvent):void {
			if (le.sendParameters) {
				_lessonLoadService.send(le.sendParameters);
			} else {
				_lessonLoadService.send(_loadParameters);
			}
		}

		[Mediate(event="LessonLoaderEvent.SET_LESSON")]
		public function onSetLesson(e:LessonLoaderEvent):void {
			var le:LessonLoaderEvent=new LessonLoaderEvent(LessonLoaderEvent.LESSON_LOADED, true);
			le.lesson=e.lesson
			le.sendParameters = e.sendParameters;
			dispatcher.dispatchEvent(le);
		}

		[Mediate(event="LessonLoaderEvent.SAVE_LESSON")]
		public function onSaveLesson(e:LessonLoaderEvent):void {
			var sendString:String=lessonConverter.getLessonXML(e.lesson).toXMLString();
			var arrayOfStrings:Array=sendString.split(null, CHUNK_SIZE);
			arrayOfStrings.push("");
			_saveParameters.data=arrayOfStrings;
			_lessonSaveService.send(_saveParameters);
		}

		private function loadResult(e:ResultEvent):void {
			var lesson:LessonVO;
			if (e.result && e.result is ObjectProxy && (e.result as ObjectProxy).content) {
				var content:ObjectProxy=e.result.content;
				try {
					lesson=lessonConverter.parseToLesson(content.lesson);
				} catch (error:Error) {
					lesson = null;
				}
				if (lesson) {
					var le:LessonLoaderEvent=new LessonLoaderEvent(LessonLoaderEvent.LESSON_LOADED, true);
					le.lesson=lesson;
					le.lessonName=content.metadata.lessonName;
					le.lessonId=e.token.message.body.lessonId;
					dispatcher.dispatchEvent(le);
					return;
				}
			}
			if (!lesson) {
				var lef:LessonLoaderEvent=new LessonLoaderEvent(LessonLoaderEvent.LESSON_LOAD_FAULT);
				lef.sendParameters={content: "Invalid Data.", description: "Invalid Data.", technical: "No additional information available."};
				dispatcher.dispatchEvent(lef);
			}
		}

		private function loadFault(e:FaultEvent):void {
			var le:LessonLoaderEvent=new LessonLoaderEvent(LessonLoaderEvent.LESSON_LOAD_FAULT);
			le.sendParameters=LoaderUtils.buildFaultParameters(e, true);
			dispatcher.dispatchEvent(le);
		}

		private function saveResult(e:ResultEvent):void {
			var le:LessonLoaderEvent=new LessonLoaderEvent(LessonLoaderEvent.LESSON_SAVED);
			dispatcher.dispatchEvent(le);
		}

		private function saveFault(e:FaultEvent):void {
			var le:LessonLoaderEvent=new LessonLoaderEvent(LessonLoaderEvent.LESSON_SAVE_FAULT);
			le.sendParameters=LoaderUtils.buildFaultParameters(e, false);
			dispatcher.dispatchEvent(le);
		}

		private function onFault(e:FaultEvent):void {
			trace("Fault: " + e.message);
		}

	}
}