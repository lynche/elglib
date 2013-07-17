package Elegant.config
{
	import flash.text.TextFormatAlign;
	import flash.text.TextFormat;

	/**
	 * @author 万游在线（北京）科技有限公司
	 */
	public class TextFormatLib
	{
		// 文字
		public static var black_12px : TextFormat = new TextFormat("宋体", 12, 0x000000);
		public static var gray_12px : TextFormat = new TextFormat("宋体", 12, 0x46413f);
		public static var red_14px : TextFormat = new TextFormat("宋体", 14, ColorLib.red);
		public static var green_12px : TextFormat = new TextFormat("宋体", 12, ColorLib.green);
		public static var gold_14px : TextFormat = new TextFormat("宋体", 14, ColorLib.gold);
		public static var black_14px : TextFormat = new TextFormat("宋体", 14, ColorLib.black);
		public static var white_10px : TextFormat = new TextFormat("宋体", 10, ColorLib.white);
		public static var white_bold_10px : TextFormat = new TextFormat("宋体", 10, ColorLib.white, true);
		public static var white_12px : TextFormat = new TextFormat("宋体", 12, ColorLib.white, false);
		public static var white_leading3_12px : TextFormat = new TextFormat("宋体", 12, ColorLib.white, false,null,null,null,null,null,null,null,null,3);
		public static var white_9px : TextFormat = new TextFormat("宋体", 9, ColorLib.white);
		public static var white_leading3_14px : TextFormat = new TextFormat("宋体", 14, ColorLib.white, null, null, null, null, null, null, null, null, null, 3);
		public static var white_leading3_14px_bold : TextFormat = new TextFormat("宋体", 14, 0xF9FAF9, true, null, null, null, null, null, null, null, null, 3);
		public static var white_bold_12px : TextFormat = new TextFormat("宋体", 12, ColorLib.white, true);
		public static var liteGreen_bold_12px : TextFormat = new TextFormat("宋体", 12, ColorLib.liteGreen, false);
		public static var white_arial_10px : TextFormat = new TextFormat("Arial", 10, ColorLib.white, true);
		public static var white_arial_12px : TextFormat = new TextFormat("Arial", 12, ColorLib.white, true);
		public static var white_14px : TextFormat = new TextFormat("宋体", 14, ColorLib.white);
		public static var white_center_leading2_14px : TextFormat = new TextFormat("宋体", 14, ColorLib.white, null, null, null, null, null, "center", null, null, null, 3);
		public static var rice_center_14px : TextFormat = new TextFormat("宋体", 14, ColorLib.rice, null, null, null, null, null, "center");
		public static var rice_12px : TextFormat = new TextFormat("宋体", 12, ColorLib.rice);
		public static var rice_center_12px : TextFormat = new TextFormat("宋体", 12, ColorLib.liteGreen, null, null, null, null, null, TextFormatAlign.CENTER);
		public static var blueGreen_14px : TextFormat = new TextFormat("宋体", 14, ColorLib.blueGreen);
		public static var yellow_12px : TextFormat = new TextFormat("宋体", 12, 0xffff00, null, null, null, null, null, TextFormatAlign.CENTER);
	}
}