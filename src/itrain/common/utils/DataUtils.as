package itrain.common.utils
{
	public class DataUtils
	{
		public static function parseBoolean(string:String):Boolean {
			return string && string.toUpperCase() == "TRUE"
		}
		
		public static function getNumberNotNaN(value:Number):Number {
			if (isNaN(value))
				return 0.0;
			else
				return value;
		}
		
		public static function cleanHTMLText(string:String):String {
			if (string) {
			var result:String = string;
			var index:int = result.indexOf("<![CDATA[");
			if (index > -1) {
				result = result.replace("<![CDATA[", "");
				result = result.replace("]]>", "");
				if (result.toUpperCase() == "NULL")
					return "";
				else
					return result;
			} else 
				return result;
			}
			return "";
		}
		
		public static function getNumberOrderEnding(value:Number):String {
			var mod:Number = value % 100;
			if (mod > 10 && mod < 21)
				return "th";
			mod = mod % 10;
			switch (mod) {
				case 1: return "st";
				case 2: return "nd";
				case 3: return "rd";
				default: return "th";
			}
		}
	}
}