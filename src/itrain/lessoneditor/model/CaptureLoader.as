package itrain.lessoneditor.model {
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

	import org.swizframework.reflection.MethodParameter;

	public class CaptureLoader {
		private var _captureListService:HTTPService;
		private var _captureIssueReportService:HTTPService;

		private var _sendParameters:Object;
		private var _captureReportParameters:Object;

		[Dispatcher]
		public var dispatcher:IEventDispatcher;

		public function CaptureLoader() {
			_captureListService=new HTTPService();
			_captureListService.addEventListener(ResultEvent.RESULT, loadCaptureListResult);
			_captureListService.addEventListener(FaultEvent.FAULT, onLoadCaptureListFault);

			_captureIssueReportService=new HTTPService();
			_captureIssueReportService.addEventListener(ResultEvent.RESULT, onReportResult);
			_captureIssueReportService.addEventListener(FaultEvent.FAULT, onReportFault);
			_captureIssueReportService.resultFormat=HTTPService.RESULT_FORMAT_TEXT;

			var params:Object=FlexGlobals.topLevelApplication.parameters;
			_sendParameters={};
			//_sendParameters.published = params.published;

			_captureReportParameters={};
			_captureReportParameters.lessonId=params.lessonId;

			_captureListService.url=params.captureListURL;
			_captureIssueReportService.url=params.captureIssueReportURL;
		}

		[Mediate(event="CaptureLoaderEvent.LOAD_CAPTURE_LIST")]
		public function onLoadCaptureList(cle:CaptureLoaderEvent):void {
			if (cle.additionalData)
				_captureListService.send(_sendParameters);
			else
				_captureListService.send({lessonId: ""});
		}

		[Mediate(event="CaptureLoaderEvent.LOAD_CAPTURE")]
		public function onLoadCapture(ce:CaptureLoaderEvent):void {
			loadCapture(ce.url);
		}

		[Mediate(event="CaptureLoaderEvent.SEND_REPORT")]
		public function onSendReport(cle:CaptureLoaderEvent):void {
			if (_captureIssueReportService.url) {
				_captureReportParameters.captureId=cle.id;
				_captureReportParameters.description=cle.additionalData;
				_captureIssueReportService.send(_captureReportParameters);
			}
			//onReportResult(new ResultEvent(ResultEvent.RESULT, true, true, "Thanks for reporting the problem! Your reference number is <a href='http://www.google.com'>15944</a>"));
		}

		private function loadCapture(url:String):void {
			if (url) {
				var cs:HTTPService=new HTTPService();
				cs.url=url;
				cs.addEventListener(ResultEvent.RESULT, loadCaptureResult);
				cs.addEventListener(FaultEvent.FAULT, onLoadCaptureFault);
				cs.send();
			}
		}

		private function loadCaptureResult(e:ResultEvent):void {
			if (e.result is ObjectProxy) {
				var o:ObjectProxy=e.result as ObjectProxy;
				var ce:CaptureLoaderEvent=new CaptureLoaderEvent(CaptureLoaderEvent.CAPTURE_LOADED, true);
				ce.captures=parseCaptures(o.root.slide);
				ce.url=e.target.url;
				dispatcher.dispatchEvent(ce);
			}
		}

		private function loadCaptureListResult(e:ResultEvent):void {
			if (e.result is ObjectProxy) {
				var o:ObjectProxy=e.result as ObjectProxy;
				var ce:CaptureLoaderEvent=new CaptureLoaderEvent(CaptureLoaderEvent.CAPTURE_LIST_LOADED, true);
				ce.captures=parseCaptureList(o.root.capture);
				dispatcher.dispatchEvent(ce);
			}
		}

		private function parseCaptures(o:Object):Array {
			var result:Array=[];
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
			var result:Array=[];
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

		private function onReportResult(re:ResultEvent):void {
			var ce:CaptureLoaderEvent=new CaptureLoaderEvent(CaptureLoaderEvent.REPORT_SENT, true);
			ce.additionalData=re.result;
			dispatcher.dispatchEvent(ce);
		}

		private function onReportFault(fe:FaultEvent):void {
			var ce:CaptureLoaderEvent=new CaptureLoaderEvent(CaptureLoaderEvent.REPORT_FAULT);
			ce.additionalData=LoaderUtils.buildFaultParameters(fe, true);
			dispatcher.dispatchEvent(ce);
		}

		private function onFault(e:FaultEvent):void {
			trace("Fault: " + e.message);
		}
	}
}
