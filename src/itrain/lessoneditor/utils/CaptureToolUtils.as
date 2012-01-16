package itrain.lessoneditor.utils
{
	import itrain.lessoneditor.model.EnumCaptureToolStatus;

	public class CaptureToolUtils
	{
		private static function getCaptureToolStatusFromString(string:String):EnumCaptureToolStatus {
			if (string) {
				switch (string.toUpperCase()) {
					case "LOADING": return EnumCaptureToolStatus.LOADING;
					case "STARTING_APPLICATION": return EnumCaptureToolStatus.STARTING_APPLICATION;
					case "APPLICATION_STARTED": return EnumCaptureToolStatus.APPLICATION_STARTED;
					case "UPLOADING": return EnumCaptureToolStatus.UPLOADING;
					case "IDLE": return EnumCaptureToolStatus.IDLE;
					case "STOPPED": return EnumCaptureToolStatus.STOPPED;
					case "RECORDING": return EnumCaptureToolStatus.RECORDING;
					case "FINISHED": return EnumCaptureToolStatus.FINISHED;
					case "CAPTURE_SAVED": return EnumCaptureToolStatus.CAPTURE_SAVED;
					case "LAUNCH_ERROR": return EnumCaptureToolStatus.LAUNCH_ERROR;
				}
			} 
			return null;
		}
		
		public static function getCaptureToolStatus(status:String):EnumCaptureToolStatus {
			var ordinal:Number = Number(status);
			if (isNaN(ordinal))
				return getCaptureToolStatusFromString(status);
			else
				return new EnumCaptureToolStatus(ordinal);
		}
	}
}