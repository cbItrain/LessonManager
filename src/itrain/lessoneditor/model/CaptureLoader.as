package itrain.lessoneditor.model
{
	import flash.events.IEventDispatcher;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	
	import itrain.common.events.CaptureLoaderEvent;
	import itrain.common.events.LessonLoaderEvent;
	import itrain.common.utils.LoaderUtils;
	
	import mx.collections.IList;
	import mx.core.FlexGlobals;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.rpc.http.Operation;
	import mx.utils.ObjectProxy;

	public class CaptureLoader
	{
		private var _captureListService:HTTPService;
		private var _captureService:HTTPService;
		
		private var _sendParameters:Object;
		private var _newCaptureParameters:URLVariables;
		
		private var _beforeNewCaptureHandler:String;
		
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		public function CaptureLoader()
		{
			_captureListService = new HTTPService();
			_captureListService.addEventListener(ResultEvent.RESULT, loadCaptureListResult);
			_captureListService.addEventListener(FaultEvent.FAULT, onLoadCaptureListFault);
			
			_captureService = new HTTPService();
			_captureService.addEventListener(ResultEvent.RESULT, loadCaptureResult);
			_captureService.addEventListener(FaultEvent.FAULT, onLoadCaptureFault);
			
			var params:Object = FlexGlobals.topLevelApplication.parameters; 
			_sendParameters = {};
			_newCaptureParameters = new URLVariables();
			_newCaptureParameters.lessonId = _sendParameters.lessonId = params.lessonId;
			_newCaptureParameters.customerId = params.companyId;
			//_sendParameters.published = params.published;
			
			_captureListService.url = params.captureListURL;
			
			_beforeNewCaptureHandler = params.beforeNewCapture;
		}
		
		[Mediate(event="CaptureLoaderEvent.NEW_CAPTURE")]
		public function onNewCapture():void {
			var url:String = FlexGlobals.topLevelApplication.parameters.newCaptureURL;
			if (url) {
				beforeNewCapture();
				_newCaptureParameters.uniqueId = String(Date.parse(new Date()));
				var urlRequest:URLRequest = new URLRequest(url);
				urlRequest.method = URLRequestMethod.GET;
				urlRequest.data = _newCaptureParameters;
				navigateToURL(urlRequest, "_self");
			}
		}
		
		private function beforeNewCapture():void {
			if (ExternalInterface.available && _beforeNewCaptureHandler) {
				ExternalInterface.call(_beforeNewCaptureHandler);
			}
		}
		
		[Mediate(event="LessonLoaderEvent.LESSON_LOADED")]
		public function lessonLoaded(e:LessonLoaderEvent):void{
			_newCaptureParameters.lessonId = e.lessonId;
		}
		
		[Mediate(event="CaptureLoaderEvent.LOAD_CAPTURE_LIST")]
		public function onLoadCaptureList(cle:CaptureLoaderEvent):void {
			if (cle.additionalData)
				_captureListService.send(_sendParameters);
			else
				_captureListService.send({lessonId:""});
		}
		
		[Mediate(event="CaptureLoaderEvent.LOAD_CAPTURE")]
		public function onLoadCapture(ce:CaptureLoaderEvent):void {
			_captureService.url = ce.url;
			_captureService.send();
		}
		
		private function loadCaptureResult(e:ResultEvent):void {
			if (e.result is ObjectProxy) {
				var o:ObjectProxy = e.result as ObjectProxy;
				var ce:CaptureLoaderEvent = new CaptureLoaderEvent(CaptureLoaderEvent.CAPTURE_LOADED, true);
				ce.captures = parseCaptures(o.root.slide);
				ce.url = e.target.url;
				dispatcher.dispatchEvent(ce);
			}
		}
		
		private function loadCaptureListResult(e:ResultEvent):void {
			if (e.result is ObjectProxy) {
				var o:ObjectProxy = e.result as ObjectProxy;
				var ce:CaptureLoaderEvent = new CaptureLoaderEvent(CaptureLoaderEvent.CAPTURE_LIST_LOADED, true);
				ce.captures = parseCaptureList(o.root.capture);
				dispatcher.dispatchEvent(ce);
			}
		}
		
		private function parseCaptures(o:Object):Array {
			var result:Array = [];
			if (o) {
				if (o is IList) {
					for each (var s:ObjectProxy in o) {
						result.push(SlideCaptureVO.parse(s));
					}
				} else {
					result.push(SlideCaptureVO.parse(o as ObjectProxy));
				}
			}
			return result;
		}
		
		private function parseCaptureList(o:Object):Array {
			var result:Array = [];
			if (o) {
				if (o is IList) {
					for each (var c:ObjectProxy in o) {
						result.push(CaptureVO.parse(c));
					}
				} else {
					result.push(CaptureVO.parse(o as ObjectProxy));
				}
			}
			return result;
		}
		
		private function onLoadCaptureListFault(fe:FaultEvent):void {
			var ce:CaptureLoaderEvent=new CaptureLoaderEvent(CaptureLoaderEvent.CAPTURE_LIST_LOAD_FAULT);
			ce.additionalData=LoaderUtils.buildFaultParameters(fe, true);
			dispatcher.dispatchEvent(ce);
		}
		
		private function onLoadCaptureFault(fe:FaultEvent):void {
			var ce:CaptureLoaderEvent=new CaptureLoaderEvent(CaptureLoaderEvent.CAPTURE_LOAD_FAULT);
			ce.additionalData=LoaderUtils.buildFaultParameters(fe, true);
			dispatcher.dispatchEvent(ce);
		}
		
		private function onFault(e:FaultEvent):void {
			trace("Fault: " + e.message);
		}
	}
}