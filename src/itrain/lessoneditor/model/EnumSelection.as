package itrain.lessoneditor.model
{
	import itrain.common.model.enum.EnumClass;

	public class EnumSelection extends EnumClass
	{
		public static const UNSELECTED:EnumSelection = new EnumSelection(0);
		public static const MIDDLE:EnumSelection = new EnumSelection(1);
		public static const SELECTED:EnumSelection = new EnumSelection(2);
		
		public function EnumSelection(ordinal:int)
		{
			switch (ordinal) {
				case 0: name = "UNSELECTED"; break;
				case 1: name = "MIDDLE"; break;
				case 2: name = "SELECTED"; break;
			}
			this.ordinal = ordinal;
		}
		
		public static function get values():Array {
			return [UNSELECTED, MIDDLE, SELECTED];
		}
	}
}