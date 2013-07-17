package Elegant.graphic 
{
	import Elegant.graphic.interfaces.IDrawShape;
	

	/**
	 * 橡皮,其实跟父类ShapePen没有区别...但是画板在判断是Eraser时会将绘画draw到遮罩层
	 * @author 浅唱
	 * @copyright myjob.liu@foxmail.com
	 * @version 1.0
	 */
	public class Eraser extends ShapePen 
	{
		
		public function Eraser(thickness:Number, color:Array, ratios:Array = null, drawShape:IDrawShape = null) 
		{
			super(thickness, color, ratios, drawShape);
		}
		
	}

}