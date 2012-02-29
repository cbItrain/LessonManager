package itrain.common.model.enum
{

	public class EnumDisplay extends EnumClass
	{
		public static const BEFORE:EnumDisplay = new EnumDisplay(0);
		public static const AFTER:EnumDisplay = new EnumDisplay(1);
		public static const ALWAYS:EnumDisplay = new EnumDisplay(2);
		
		public function EnumDisplay(ordinal:int)
		{
			switch (ordinal) {
				case 0: name = "BEFORE"; break;
				case 1: name = "AFTER"; break;
				case 2: name = "ALWAYS"; break;
			}
			this.ordinal = ordinal;
		}
		
		public static function get values():Array {
			return [BEFORE, AFTER, ALWAYS];
		}
	}
}