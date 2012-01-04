package itrain.common.model.vo
{
	import itrain.lessoneditor.model.CaptureVO;

	public class CaptureVOWrapper
	{
		public var imagesOnly:Boolean;
		public var capture:CaptureVO;
		
		public function CaptureVOWrapper(capture:CaptureVO)
		{
			super();
			this.capture = capture;
		}
	}
}