package Elegant.config 
{
	import flash.geom.ColorTransform;

	public class TransformLib 
	{
		public static var  normal : ColorTransform = new ColorTransform();
		public static var  white_classic : ColorTransform = new ColorTransform(1.5, 1.5, 1.5, 1);
		public static var  black_classic : ColorTransform = new ColorTransform(1, 0.4, 0.4, 1);
		public static var  red_classic : ColorTransform = new ColorTransform(1, 0.2, 0.2, 1);
	}
}
