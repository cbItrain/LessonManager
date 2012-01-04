package itrain.common.utils
{
	import itrain.common.model.enum.EnumAction;

	public class ActionUtils
	{
		public static function getActionFromString(string:String):EnumAction {
			if (string) {
				switch (string.toUpperCase()) {
					case "RIGHT_MOUSE": return EnumAction.RIGHT_MOUSE;
					case "DOUBLE_CLICK": return EnumAction.DOUBLE_CLICK;
					case "MOUSE_WHEEL": return EnumAction.MOUSE_WHEEL;
					case "MIDDLE_CLICK": return EnumAction.MIDDLE_CLICK;
				}
			}
			return EnumAction.LEFT_MOUSE;
		}
		
		public static function getAction(action:String):EnumAction {
			var ordinal:Number = Number(action);
			if (isNaN(ordinal))
				return getActionFromString(action);
			else
				return new EnumAction(ordinal);
		}
		
		public static function getActionLabel(item:EnumAction):String {
			switch (item.ordinal) {
				case EnumAction.DOUBLE_CLICK.ordinal:
					return "Double Mouse Click";
				case EnumAction.LEFT_MOUSE.ordinal:
					return "Left Mouse Click";
				case EnumAction.RIGHT_MOUSE.ordinal:
					return "Right Mouse Click";
				case EnumAction.MOUSE_WHEEL.ordinal:
					return "Mouse Wheel";
				case EnumAction.MIDDLE_CLICK.ordinal:
					return "Middle button click";
			}
			return "";
		}
	}
}