package itrain.common.model.enum
{
	[RemoteClass]
	public class EnumPosition extends EnumClass
	{
		public static const NONE:EnumPosition = new EnumPosition(0);
		public static const TOP_LEFT:EnumPosition = new EnumPosition(1);
		public static const TOP_RIGHT:EnumPosition = new EnumPosition(2);
		public static const BOTTOM_LEFT:EnumPosition = new EnumPosition(3);
		public static const BOTTOM_RIGHT:EnumPosition = new EnumPosition(4);
		public static const LEFT_TOP:EnumPosition = new EnumPosition(5);
		public static const LEFT_BOTTOM:EnumPosition = new EnumPosition(6);
		public static const RIGHT_TOP:EnumPosition = new EnumPosition(7);
		public static const RIGHT_BOTTOM:EnumPosition = new EnumPosition(8);
		
		public function EnumPosition(ordinal:int = NaN)
		{
			switch (ordinal) {
				case 1: name = "TOP_LEFT"; break;
				case 2: name = "TOP_BOTTOM"; break;
				case 3: name = "BOTTOM_LEFT"; break;
				case 4: name = "BOTTOM_RIGHT"; break;
				case 5: name = "LEFT_TOP"; break;
				case 6: name = "LEFT_BOTTOM"; break;
				case 7: name = "RIGHT_TOP"; break;
				case 8: name = "RIGHT_BOTTOM"; break;
				default: name = "NONE"; break;
			}
			this.ordinal = ordinal;
		}
		
		public static function get values():Array {
			return [NONE, TOP_LEFT, TOP_RIGHT, BOTTOM_LEFT, BOTTOM_RIGHT, LEFT_TOP, LEFT_BOTTOM, RIGHT_TOP, RIGHT_BOTTOM];
		}
	}
}