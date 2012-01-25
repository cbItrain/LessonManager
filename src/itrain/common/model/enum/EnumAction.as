package itrain.common.model.enum
{

	public class EnumAction extends EnumClass
	{
		public static const LEFT_MOUSE:EnumAction = new EnumAction(0);
		public static const RIGHT_MOUSE:EnumAction = new EnumAction(1);
		public static const DOUBLE_CLICK:EnumAction = new EnumAction(2);
		public static const MOUSE_WHEEL:EnumAction = new EnumAction(3);
		public static const MIDDLE_CLICK:EnumAction = new EnumAction(4);
		
		public function EnumAction(ordinal:int)
		{
			switch (ordinal) {
				case 0: name = "LEFT_MOUSE"; break;
				case 1: name = "RIGHT_MOUSE"; break;
				case 2: name = "DOUBLE_CLICK"; break;
				case 3: name = "MOUSE_WHEEL"; break;
				case 4: name = "MIDDLE_CLICK"; break;
			}
			this.ordinal = ordinal;
		}
		
		public static function get values():Array {
			return [LEFT_MOUSE, RIGHT_MOUSE, DOUBLE_CLICK, MOUSE_WHEEL, MIDDLE_CLICK];
		}
	}
}