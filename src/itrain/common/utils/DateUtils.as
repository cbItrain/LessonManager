package itrain.common.utils
{
	public class DateUtils
	{
		public static function isToday(date:Date):Boolean {
			if (date) {
				var today:Date = new Date();
				return today.fullYear == date.fullYear
						&& today.month == date.month
						&& today.date == date.date;
			}
			return false;
		}
		
		public static function isThisWeek(date:Date):Boolean {
			if (date) {
				var today:Date = new Date();
				return today.fullYear == date.fullYear
					&& today.month == date.month
					&& (today.date - date.date < 7)
			}
			return false;
		}
	}
}