package itrain.lessoneditor.model
{
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.external.ExternalInterface;
	import flash.utils.setTimeout;
	
	import itrain.common.events.CaptureLoaderEvent;
	import itrain.common.utils.Messages;
	import itrain.lessoneditor.events.NewCaptureEvent;
	import itrain.lessoneditor.utils.CaptureToolUtils;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;

	public class NewCaptureModel
	{
		public static const STATE_DEFAULT:String="default";

		private static const STATE_UPLOADING:String="uploading";
		private static const STATE_LAUNCHING:String="launching";
		private static const STATE_RECORDING:String="recording";
		private static const STATE_SAVED:String="saved";
		private static const STATE_UPLOADED:String="uploaded";
		private static const STATE_READY:String="ready";
		private static const STATE_ERROR:String="error";

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
		public var highlightNewButton:Boolean=false;

		[Bindable]
		public var message:String;

		[Bindable]
		public var description:String;

		[Bindable]
		public var freezed:Boolean=false;

		[Bindable]
		public var ctAvailable:Boolean=true;

		private var _captureToolStatus:EnumCaptureToolStatus=null;
		private var _captureToolRunFunctionName:String=null;
		private var _captureToolPauseResumeFunctionName:String=null;
		private var _captureToolStopFunctionName:String=null;
		private var _captureToolCancelFucntionName:String=null;
		private var _retryCaptureToolFucntionName:String=null;

		private var _currentCapture:CaptureVO=null;
		private var _capturingStarted:Boolean=false;
		private var _captureUploaded:Boolean=false;

		private var _lessonId:int;
		private var _userId:String;
		private var _userName:String;
		private var _courseId:String;
		private var _courseName:String
		private var _comId:String;
		private var _lessonName:String="No name";

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
				_captureToolPauseResumeFunctionName=flashVars.captureToolPauseResumeFunctionName;
			}
			if (flashVars.captureToolStopFunctionName)
			{
				_captureToolStopFunctionName=flashVars.captureToolStopFunctionName;
			}
			if (flashVars.captureToolCancelFunctionName)
			{
				_captureToolCancelFucntionName=flashVars.captureToolCancelFunctionName;
			}
			if (flashVars.retryCaptureToolFunctionName)
			{
				_retryCaptureToolFucntionName=flashVars.retryCaptureToolFunctionName;
			}
			_comId=flashVars.companyId;
			_lessonName=flashVars.lessonName;
			_lessonId=Number(flashVars.lessonId);
			_userId=flashVars.currentUserId;
			_courseId=flashVars.courseId;
			_comId=flashVars.companyId;
			_userName=flashVars.userName;
			_courseName=flashVars.courseName;
		}

		public function newCaptrue():void
		{
			if (ExternalInterface.available && _captureToolRunFunctionName)
			{
				_capturingStarted=true;
				_captureUploaded=false;
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

		public function pauseResumeRecording():void
		{
			if (ExternalInterface.available && _captureToolPauseResumeFunctionName)
			{
				ExternalInterface.call(_captureToolPauseResumeFunctionName);
			}
		}

		public function cancelRecording():void
		{
			if (ExternalInterface.available && _captureToolCancelFucntionName)
			{
				ExternalInterface.call(_captureToolCancelFucntionName);
			}
		}

		public function retryCaptureTool():void
		{
			if (ExternalInterface.available && _retryCaptureToolFucntionName)
			{
				ExternalInterface.call(_retryCaptureToolFucntionName);
			}
		}

		private function addNewCapture(captureId:int):void
		{
			removeCapture();
			_currentCapture=new CaptureVO();
			_currentCapture.id=captureId;
			_currentCapture.comId=_comId;
			_currentCapture.userId=_userId;
			_currentCapture.userName=_userName;
			_currentCapture.lessonId=_lessonId;
			_currentCapture.courseId=_courseId;
			_currentCapture.courseName=_courseName;
			_currentCapture.lessonName=_lessonName;

			importModel.addCaptures([_currentCapture], false);
		}

		private function removeCapture():void
		{
			if (_currentCapture)
				importModel.removeCapture(_currentCapture);
		}
		
		public function getCurrentCaptureId():int {
			if (_currentCapture)
				return _currentCapture.id;
			return 0;
		}

		private function captureCancelled():void
		{
			currentState=STATE_DEFAULT;
			if (_currentCapture)
			{
				removeCapture();
			}
			uploadProgress=0;
			_captureUploaded=false;
			_capturingStarted=false;
		}

		private function captureToolStatusUpdate(captureId:int, status:String, data:Object):void
		{
			_captureToolStatus=CaptureToolUtils.getCaptureToolStatus(status);
			if (_capturingStarted)
			{
				if (_captureToolStatus)
				{
					freezed=false;
					message=description="";
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
						case EnumCaptureToolStatus.UPLOADED.ordinal:
							currentState=STATE_UPLOADED;
							uploadProgress=100;
							break;
						case EnumCaptureToolStatus.FINISHED.ordinal:
							if (uploadProgress != 100)
								captureCancelled();
							break;
						case EnumCaptureToolStatus.CAPTURE_SAVED.ordinal:
							currentState=STATE_SAVED;
							setTimeout(function():void
							{
								dispatcher.dispatchEvent(new NewCaptureEvent(NewCaptureEvent.CAPTURE_COMPLETED));
								currentState=STATE_DEFAULT;
								highlightNewButton=false;
								uploadProgress=0;
								if (_currentCapture)
								{
									_currentCapture.timeStamp=new Date();
									//_currentCapture.source="assets/capture1.xml";
									_currentCapture.source=CaptureUtils.constructCaptureURL(_currentCapture.id, _comId);
									_currentCapture=null;
								}
								_capturingStarted=false;
							}, STATE_DELAY);
							break;
						case EnumCaptureToolStatus.CRASHED.ordinal:
						case EnumCaptureToolStatus.LAUNCH_ERROR.ordinal:
							_capturingStarted=false;
							currentState=STATE_ERROR;
							if (_captureToolStatus.equals(EnumCaptureToolStatus.LAUNCH_ERROR))
							{
								message=Messages.CT_LAUNCHING_ERROR;
								description=(data != null && data != "") ? data as String : Messages.CT_LAUNCHING_ERROR_INFO;
							}
							else
							{
								message=Messages.CT_CRASHED;
								description=(data != null && data != "") ? data as String : Messages.CT_CRASHED_INFO;
							}
							setTimeout(function():void
							{
								captureCancelled();
							}, STATE_DELAY * 4);
							break;
						case EnumCaptureToolStatus.WAIT_USER_DECISION.ordinal:
							freezed=true;
							break;
					}
				}
			}
			else if (_captureToolStatus.equals(EnumCaptureToolStatus.CAPTURE_TOOL_UNAVAILABLE))
			{
				message=Messages.CT_CAPTURE_TOOL_UNV;
				description=Messages.CT_LAUNCHING_ERROR_INFO;
				currentState=STATE_ERROR;
				ctAvailable=false;
			}
			else if (_captureToolStatus.equals(EnumCaptureToolStatus.CAPTURE_TOOL_AVAILABLE))
			{
				currentState=STATE_DEFAULT;
				ctAvailable=true;
			}
		}
	}
}
