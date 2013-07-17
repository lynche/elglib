package Elegant.utils
{
	
	/**
	 * ...
	 * @author Lynch
	 */
	public class DateUtil
	{
		/**
		 * 将date转为 天/时/分
		 * @param	date
		 * @return
		 */
		public static function encodeDate(date:Date):String
		{
			var s:String = date.date + "天" + date.hours + "小时" + date.minutes + "分";
			return s;
		}
		
		/**
		 * 将秒转为 时:分:秒
		 * @param	date
		 * @return
		 */
		public static function encodeHour(time:uint):String
		{
			var seconds:int = time % 60;
			var minutes:int = time / 60 % 60;
			var hours:int = time / 3600 % 24;
			var day:int = time / 3600 / 24;
			
			var s:String = IntUtil.coverage(hours) + ":" + IntUtil.coverage(minutes) + ":" + IntUtil.coverage(seconds);
			
			if (day)
				s = day + "天 " + s;
			
			return s;
		}
		
		/**
		 * 将秒转化为天数
		 * @return
		 */
		public static function encodeInDay(sec:int):Number
		{
			return sec / 60 / 60 / 24;
		}
		
		/**
		 * 从时间1到时间2间隔的date
		 * 时分秒是正确的, 时区问题1970毫秒值应加8小时
		 * @param	time	秒
		 * @param	time1	秒
		 */
		public static function durDate(time1:uint, time2:uint):Date
		{
			var date1:Date = new Date();
			date1.time = time1 * 1000;
			
			var date2:Date = new Date();
			date2.time = time2 * 1000;
			
			var date:Date = new Date();
			date.time = date1.time - date2.time;
			date.hours -= 8;
			
			return date;
		}
	}
}