package itrain.lessoneditor.model
{
	import itrain.common.model.enum.EnumAction;

	public class CaptureUtils
	{
		public static function translateCaptureAction(action:String):EnumAction {
			if (action) {
				switch (action.toUpperCase()) {
					case "LEFT_BUTTON_DOUBLE_CLICK": return EnumAction.DOUBLE_CLICK;
					case "RIGHT_BUTTON_CLICK": return EnumAction.RIGHT_MOUSE;
					default: return EnumAction.LEFT_MOUSE;
				}
			} else 
				return EnumAction.LEFT_MOUSE;
		}
		
		public static function getCaptureIdFromUrl(url:String):String {
			if (url) {
				var result:String = "";
				var splited:Array = url.split("/");
				if (splited.length > 3)
					result = splited[splited.length - 3];
				return result;
			}
			return "Unavailable";
		}
		
		public static function constructCaptureURL(captureId:int, companyId:String):String {
			return "/captures/" + companyId + "/capture/" + captureId + "/files/course_" + companyId + "_" + captureId + ".xml";
		}
	}
}