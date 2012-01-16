package itrain.lessoneditor.model
{
	import flash.events.IEventDispatcher;
	import flash.external.ExternalInterface;
	import flash.utils.setTimeout;
	
	import itrain.common.events.CaptureLoaderEvent;
	import itrain.lessoneditor.utils.CaptureToolUtils;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;

	public class NewCaptureModel
	{
		public static const STATE_DEFAULT:String="default";
		
		private static const STATE_UPLOADING:String="uploading";
		private static const STATE_LAUNCHING:String="launching";
		private static const STATE_RECORDING:String="recording";
		private static const STATE_SAVED:String="saved";
		private static const STATE_FINISHED:String="finished";
		private static const STATE_READY:String="ready";
		private static const STATE_LAUNCH_ERROR:String="launchError";

		private static const STATE_DELAY:int=2000;

		[Dispatcher]
		public var dispatcher:IEventDispatcher;

		[Inject]
		public var importModel:CaptureImportModel;

		[Bindable]
		public var uploadProgress:int=0;

		[Bindable]
		public var currentState:String=STATE_DEFAULT;
		
		[Bindable]
		public var highlightNewButton:Boolean = false;

		private var _captureToolStatus:EnumCaptureToolStatus=null;
		private var _captureToolRunFunctionName:String=null;
		private var _captureToolPauseFunctionName:String=null;
		private var _captureToolStopFunctionName:String=null;
		private var _captureToolCancelFucntionName:String=null;
		private var _lessonName:String = "No name";

		private var _companyId:int=0;

		private var _currentCapture:CaptureVO=null;
		private var _capturingStarted:Boolean=false;

		public function NewCaptureModel()
		{
			var flashVars:Object=FlexGlobals.topLevelApplication.parameters;
			if (ExternalInterface.available)
			{
				if (flashVars.captureToolStatusUpdateFunction)
					ExternalInterface.addCallback(flashVars.captureToolStatusUpdateFunction, captureToolStatusUpdate);
			}
			if (flashVars.captureToolRunFunctionName)
			{
				_captureToolRunFunctionName=flashVars.captureToolRunFunctionName;
			}
			if (flashVars.captureToolPauseFunctionName)
			{
				_captureToolPauseFunctionName=flashVars.captureToolPauseFunctionName;
			}
			if (flashVars.captureToolStopFunctionName)
			{
				_captureToolStopFunctionName=flashVars.captureToolStopFunctionName;
			}
			if (flashVars.captureToolCancelFunctionName)
			{
				_captureToolCancelFucntionName=flashVars.captureToolCancelFunctionName;
			}
			if (flashVars.companyId)
			{
				_companyId=flashVars.companyId;
			}
			if (flashVars.lessonName) {
				_lessonName = flashVars.lessonName;
			}
		}

		public function newCaptrue():void
		{
			if (ExternalInterface.available && _captureToolRunFunctionName)
			{
				_capturingStarted=true;
				currentState=STATE_LAUNCHING;
				ExternalInterface.call(_captureToolRunFunctionName);
			}
		}

		public function stopRecording():void
		{
			if (ExternalInterface.available && _captureToolStopFunctionName)
			{
				ExternalInterface.call(_captureToolStopFunctionName);
			}
		}

		public function pauseRecording():void
		{
			if (ExternalInterface.available && _captureToolPauseFunctionName)
			{
				ExternalInterface.call(_captureToolPauseFunctionName);
			}
		}

		public function cancelRecording():void
		{
			if (ExternalInterface.available && _captureToolCancelFucntionName)
			{
				ExternalInterface.call(_captureToolCancelFucntionName);
			}
		}

		private function addNewCapture(captureId:int):void
		{
			removeCapture();
			_currentCapture=new CaptureVO();
			_currentCapture.id=captureId;
			_currentCapture.lessonName=_lessonName;

			importModel.addCaptures([_currentCapture], false);
		}

		private function removeCapture():void
		{
			if (_currentCapture)
				importModel.removeCapture(_currentCapture);
		}

		private function captureToolStatusUpdate(captureId:int, status:String, data:Object):void
		{
			if (_capturingStarted)
			{
				_captureToolStatus=CaptureToolUtils.getCaptureToolStatus(status);
				if (_captureToolStatus)
				{
					switch (_captureToolStatus.ordinal)
					{
						case EnumCaptureToolStatus.STARTING_APPLICATION.ordinal:
						case EnumCaptureToolStatus.LOADING.ordinal:
							currentState=STATE_LAUNCHING;
							addNewCapture(captureId);
							break;
						case EnumCaptureToolStatus.APPLICATION_STARTED.ordinal:
							currentState=STATE_READY;
							break;
						case EnumCaptureToolStatus.RECORDING.ordinal:
							currentState=STATE_RECORDING;
							break;
						case EnumCaptureToolStatus.UPLOADING.ordinal:
							currentState=STATE_UPLOADING;
							uploadProgress=data as int;
							break;
						case EnumCaptureToolStatus.FINISHED.ordinal:
							currentState=STATE_FINISHED;
							uploadProgress=100;
							break;
						case EnumCaptureToolStatus.CAPTURE_SAVED.ordinal:
							currentState=STATE_SAVED;
							uploadProgress=100;
							setTimeout(function():void
							{
								currentState=STATE_DEFAULT;
								highlightNewButton = false;
								uploadProgress=0;
								if (_currentCapture)
								{
									_currentCapture.timeStamp=new Date();
									_currentCapture.source=CaptureUtils.constructCaptureURL(_currentCapture.id, _companyId);
								}
								_capturingStarted=false;
							}, STATE_DELAY);
							break;
						case EnumCaptureToolStatus.LAUNCH_ERROR.ordinal:
							currentState = STATE_LAUNCH_ERROR;
							setTimeout(function():void
							{
								currentState=STATE_DEFAULT;
								uploadProgress=0;
								if (_currentCapture)
								{
									removeCapture();
								}
								_capturingStarted=false;
							}, STATE_DELAY*2);
							break;
					}
				}
			}
		}
	}
}
