package Elegant.graphic.shape 
{
	import Elegant.graphic.interfaces.IPen;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	

	/**
	 * 不透明圆形
	 * @author 浅唱
	 * @copyright myjob.liu@foxmail.com
	 * @version 1.0
	 */
	public class CircleShape extends DrawShapeBase
	{
		public function CircleShape() 
		{
			
		}
		/**
		 * @inheritDoc
		 */
		override public function getShape(pen:IPen):DisplayObject 
		{
			var displayObj:Sprite = new Sprite();
			var graphic:Graphics = displayObj.graphics;
			
			if (pen.color.length > 1)
			{
				graphic.beginGradientFill(pen.gradientType, pen.color, pen.alphas, pen.ratios, null, pen.spreadMethod, pen.interpolationMethod, pen.focalPointRatio);
			} else {
				graphic.beginFill(pen.color[0],  pen.alphas[0]);
			}
			
			graphic.drawCircle(-pen.thickness, -pen.thickness, pen.thickness);
			return displayObj;
		}
	}
}