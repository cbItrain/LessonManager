package itrain.common.utils
{
	import itrain.common.model.enum.EnumCursor;

	public class CursorUtils
	{
		public static function getCursorFromString(string:String):EnumCursor {
			if (string) {
				switch (string.toUpperCase()) {
					case "HAND": return EnumCursor.HAND;
					case "TEXT": return EnumCursor.TEXT;
				}
			}
			return EnumCursor.POINTER;
		}
		
		public static function getCursor(cursor:String):EnumCursor {
			var ordinal:Number = Number(cursor);
			if (isNaN(ordinal))
				return getCursorFromString(cursor);
			else
				return new EnumCursor(ordinal);
		}
		
		public static function getCursorLabel(item:EnumCursor):String {
			switch (item.ordinal) {
				case EnumCursor.HAND.ordinal:
					return "Hand";
				case EnumCursor.TEXT.ordinal:
					return "Text";
				case EnumCursor.POINTER.ordinal:
					return "Pointer";
			}
			return "";
		}
	}
}