package itrain.lessoneditor.model
{
	import itrain.common.model.enum.EnumClass;
	
	public class EnumCaptureToolStatus extends EnumClass
	{
		public static const LOADING:EnumCaptureToolStatus = new EnumCaptureToolStatus(0);
		public static const STARTING_APPLICATION:EnumCaptureToolStatus = new EnumCaptureToolStatus(1);
		public static const APPLICATION_STARTED:EnumCaptureToolStatus = new EnumCaptureToolStatus(2);
		public static const UPLOADING:EnumCaptureToolStatus = new EnumCaptureToolStatus(3);
		public static const IDLE:EnumCaptureToolStatus = new EnumCaptureToolStatus(4);
		public static const STOPPED:EnumCaptureToolStatus = new EnumCaptureToolStatus(5);
		public static const RECORDING:EnumCaptureToolStatus = new EnumCaptureToolStatus(6);
		public static const FINISHED:EnumCaptureToolStatus = new EnumCaptureToolStatus(7);
		public static const CAPTURE_SAVED:EnumCaptureToolStatus = new EnumCaptureToolStatus(8);
		public static const LAUNCH_ERROR:EnumCaptureToolStatus = new EnumCaptureToolStatus(9);
		
		public function EnumCaptureToolStatus(ordinal:int)
		{
			super();
			switch (ordinal) {
				case 0: name = "LOADING"; break;
				case 1: name = "STARTING_APPLICATION"; break;
				case 2: name = "APPLICATION_STARTED"; break;
				case 3: name = "UPLOADING"; break;
				case 4: name = "IDLE"; break;
				case 5: name = "STOPPED"; break;
				case 6: name = "RECORDING"; break;
				case 7: name = "FINISHED"; break;
				case 8: name = "CAPTURE_SAVED"; break;
				case 9: name = "LAUNCH_ERROR"; break;
			}
			this.ordinal = ordinal;
		}
		
		public function get values():Array {
			return [LOADING, STARTING_APPLICATION, APPLICATION_STARTED, UPLOADING, IDLE, STOPPED, RECORDING, FINISHED, CAPTURE_SAVED, LAUNCH_ERROR];
		}
	}
}