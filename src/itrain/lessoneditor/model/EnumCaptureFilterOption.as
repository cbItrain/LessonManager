package itrain.lessoneditor.model
{
	import itrain.common.model.enum.EnumClass;
	
	public class EnumCaptureFilterOption extends EnumClass
	{
		public static const LESSON:EnumCaptureFilterOption = new EnumCaptureFilterOption(0);
		public static const COURSE:EnumCaptureFilterOption = new EnumCaptureFilterOption(1);
		public static const MY:EnumCaptureFilterOption = new EnumCaptureFilterOption(2);
		public static const ALL:EnumCaptureFilterOption = new EnumCaptureFilterOption(3);
		
		public function EnumCaptureFilterOption(ordinal:int)
		{
			super();
			switch (ordinal) {
				case 0: name = "Captures for this lesson"; break;
				case 1: name = "Captures for this course"; break;
				case 2: name = "My Captures"; break;
				case 3: name = "All Captures"; break;
			}
			this.ordinal = ordinal;
		}
		
		public static function get values():Array {
			return [LESSON, COURSE, MY, ALL];
		}
	}
}