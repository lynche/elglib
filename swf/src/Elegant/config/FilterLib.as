package Elegant.config
{
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;

	/**
	 * 滤镜与transform
	 * @author 万游在线（北京）科技有限公司
	 */
	public class FilterLib
	{
		// 经典1像素黑色描边
		public static var glow_classic : GlowFilter = new GlowFilter(0x110204, 1, 1.8, 1.8, 7, 1);
		// zlused
		public static var glow_classic_bold : GlowFilter = new GlowFilter(0x110204, 1, 5, 5, 7, 1);
		// 经典1像素黑色描边inner
		public static var glow_classic_inner : GlowFilter = new GlowFilter(0x110204, 1, 2, 2, 1, 3, true);
		// 经典1像素黑色描边
		public static var glow_black : GlowFilter = new GlowFilter(0x000000, 1, 1.8, 1.8, 7, 1);
		// 经典1像素黑色描边
		public static var glow_black_inner : GlowFilter = new GlowFilter(0x000000, 1, 2, 3, 9, 1);
		// 淡灰色轻柔化描边
		public static var glow_dust : GlowFilter = new GlowFilter(0x071717, 1, 1.1, 1.1, 1, 1);
		// 淡灰色柔化描边
		public static var glow_soft : GlowFilter = new GlowFilter(0x071717, 1, 1.4, 1.4, 3, 2);
		// 淡灰色柔化描边
		public static var glow_lite : GlowFilter = new GlowFilter(0x071717, 1, 1.4, 1.4, 2, 2);
		// 深灰色柔化描边
		public static var glow_cloud : GlowFilter = new GlowFilter(0x071717, 1, 2, 2, 2.2, 5);
		// 白色柔化描边
		public static var glow_white : GlowFilter = new GlowFilter(0xffffff, 1, 2, 2, 3);
		// 白色柔化描边
		public static var glow_white_inner : GlowFilter = new GlowFilter(0xf5f4f4, 1, 1.2, 1.2, 8, 1, true);
		// 金色描变
		public static var glow_glod : GlowFilter = new GlowFilter(ColorLib.gold, 1, 3, 3, 5, 1);

		// 金色描变
		public static var glow_glod_inner : GlowFilter = new GlowFilter(ColorLib.gold, 1, 3, 3, 5, 1, true);

		// 蓝绿色描变
		public static var glow_blueGreen : GlowFilter = new GlowFilter(ColorLib.blueGreen, 1, 3, 3, 5, 1);
		// 蓝绿色描变 内
		public static var glow_blueGreen_inner : GlowFilter = new GlowFilter(ColorLib.blueGreen, 1, 3, 3, 5, 1, true);
		// 红色发光
		public static var glow_Red : GlowFilter = new GlowFilter(0xffffff, 1, 1, 1, 3, 1);
		public static var glow_Green : GlowFilter = new GlowFilter(0x66ff66, 1, 1, 1, 3, 1);
		public static var glow_Blue : GlowFilter = new GlowFilter(0x66ffff, 1, 1, 1, 3, 1);
		public static var glow_BigGreen : GlowFilter = new GlowFilter(0x66ff66, 1, 2, 2, 4, 1);
		public static var glow_BigBlue : GlowFilter = new GlowFilter(0x66ffff, 1, 2, 2, 4, 1);
		// 柔化测试
		public static var drop_shadow : DropShadowFilter = new DropShadowFilter(1.5, 45, 0, 0.5, 2, 2, 1.8);
		public static var drop_soft : DropShadowFilter = new DropShadowFilter(1.5, 45, 0x000000, 0.8, 1, 1, 2);
		public static var drop_verySoft : DropShadowFilter = new DropShadowFilter(1.5, 45, 0x000000, 0.5, 1, 1, 2);
		// 滤镜 - 阴影
		public static var drop_classic : DropShadowFilter = new DropShadowFilter(1, 45, 0x000000, 1, 1, 1, 3);
		// 茶色描边
		public static var glow_brown : GlowFilter = new GlowFilter(0x5e5335, 1, 2, 2, 7, 1);
		// 深茶色
		public static var glow_darkBrown : GlowFilter = new GlowFilter(0x310204, 1, 2, 2, 7, 1);
		public static var drop_dust : DropShadowFilter = new DropShadowFilter(1, 45, 0x000000, 0.8, 1, 1, 1);
		public static var drop_bold : DropShadowFilter = new DropShadowFilter(1, 45, ColorLib.orange, 1, 3, 3, 1);
		public static var drop_big : DropShadowFilter = new DropShadowFilter(2, 45, 0x008684, 1, 1, 1, 3);
		public static var drop_white : DropShadowFilter = new DropShadowFilter(1, 45, 0xffffff, 1, 1, 1, 3);
	}
}