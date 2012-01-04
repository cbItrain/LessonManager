package itrain.common.utils
{
	public class ColorUtils
	{
		public static function parseStringColor(stringColor:String):int {
			var result:int = -1;
			if (stringColor && (stringColor.length == 7 || stringColor.length == 8)) {
				var match:Array = stringColor.match(/#?(0x)?([a-fA-f0-9]{6})/);
				if (match && match.length > 0) {
					result = parseInt(stringColor.substr(stringColor.length - 6,6), 16);
				}
			}
			return result;
		}
	}
}