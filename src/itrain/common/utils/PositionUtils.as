package itrain.common.utils
{
	import itrain.common.model.enum.EnumPosition;

	public class PositionUtils
	{
		public static function getPointPositionFromString(string:String):EnumPosition {
			if (string) {
				switch (string.toUpperCase()) {
					case "TL": return EnumPosition.TOP_LEFT;
					case "TR": return EnumPosition.TOP_RIGHT;
					case "RT": return EnumPosition.RIGHT_TOP;
					case "RB": return EnumPosition.RIGHT_BOTTOM;
					case "BR": return EnumPosition.BOTTOM_RIGHT;
					case "BL": return EnumPosition.BOTTOM_LEFT;
					case "LB": return EnumPosition.LEFT_BOTTOM;
					case "LT": return EnumPosition.LEFT_TOP;
				}
			} 
			return EnumPosition.NONE;
		}
		
		public static function getPointPosition(position:String):EnumPosition {
				var ordinal:Number = Number(position);
				if (isNaN(ordinal))
					return getPointPositionFromString(position);
				else
					return new EnumPosition(ordinal);
		}
		
		public static function getPointLabel(item:EnumPosition):String {
			switch (item.ordinal) {
				case EnumPosition.BOTTOM_LEFT.ordinal:
					return "Bottom Left";
				case EnumPosition.BOTTOM_RIGHT.ordinal:
					return "Bottom Right";
				case EnumPosition.LEFT_BOTTOM.ordinal:
					return "Left Bottom";
				case EnumPosition.LEFT_TOP.ordinal:
					return "Left Top";
				case EnumPosition.TOP_LEFT.ordinal:
					return "Top Left";
				case EnumPosition.TOP_RIGHT.ordinal:
					return "Top Right";
				case EnumPosition.RIGHT_TOP.ordinal:
					return "Right Top";
				case EnumPosition.RIGHT_BOTTOM.ordinal:
					return "Right Bottom";
				case EnumPosition.NONE.ordinal:
					return "No Pointer";
			}
			return "";
		}
	}
}