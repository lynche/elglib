package Elegant.graphic.shape 
{
	import Elegant.graphic.interfaces.IDrawShape;
	import Elegant.graphic.interfaces.IPen;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * 为形状画笔提供形状,据说sprite的效率比shape要高= =
	 * @author 浅唱
	 * @copyright myjob.liu@foxmail.com
	 * @version 1.0
	 */
	internal class DrawShapeBase extends Sprite implements IDrawShape 
	{
		/**
		 * 不提供任何形状,需要子类来实现
		 */
		public function DrawShapeBase() 
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		public function getShape(pen:IPen):DisplayObject
		{
			return null;
		}
	}
}