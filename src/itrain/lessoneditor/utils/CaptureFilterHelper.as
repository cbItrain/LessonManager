package itrain.lessoneditor.utils
{
	import itrain.lessoneditor.model.EnumCaptureFilterOption;
	
	import mx.collections.ArrayCollection;

	public class CaptureFilterHelper
	{
		public static function getCaptureFilterOptions():ArrayCollection {
			return new ArrayCollection(EnumCaptureFilterOption.values);
		}
	}
}