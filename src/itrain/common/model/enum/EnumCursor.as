package itrain.common.model.enum
{
	public class EnumCursor extends EnumClass
	{
		public static const POINTER:EnumCursor = new EnumCursor(0);
		public static const HAND:EnumCursor = new EnumCursor(1);
		public static const TEXT:EnumCursor = new EnumCursor(2);
		
		public function EnumCursor(ordinal:int)
		{
			switch (ordinal) {
				case 0: name = "POINTER"; break;
				case 1: name = "HAND"; break;
				case 2: name = "TEXT"; break;
			}
			this.ordinal = ordinal;
		}
		
		public static function get values():Array {
			return [POINTER, HAND, TEXT];
		}
	}
}