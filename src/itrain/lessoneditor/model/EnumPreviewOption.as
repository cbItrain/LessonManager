package itrain.lessoneditor.model
{
	import itrain.common.model.enum.EnumClass;

	public class EnumPreviewOption extends EnumClass
	{
		public static var WATCH_IT:EnumPreviewOption = new EnumPreviewOption(0);
		public static var WATCH_IT_DEBUG:EnumPreviewOption = new EnumPreviewOption(1);
		public static var TRY_IT:EnumPreviewOption = new EnumPreviewOption(2);
		public static var TRY_IT_DEBUG:EnumPreviewOption = new EnumPreviewOption(3);
		
		public function EnumPreviewOption(ordinal:int)
		{
			switch (ordinal) {
				case 0: name = "WATCH IT"; break;
				case 1: name = "WATCH IT DEBUG"; break;
				case 2: name = "TRY IT"; break;
				case 3: name = "TRY IT DEBUG"; break;
			}
			this.ordinal = ordinal;
		}
		
		public static function get values():Array {
			return [WATCH_IT, WATCH_IT_DEBUG, TRY_IT, TRY_IT_DEBUG];
		}
	}
}