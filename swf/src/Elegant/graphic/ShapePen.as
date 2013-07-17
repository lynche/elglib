package Elegant.graphic 
{
	import Elegant.graphic.interfaces.IDrawShape;
	import flash.display.DisplayObject;

	/**
	 * 形状笔触,用实现Elegant.graphic.interfaces.IDrawShape接口的类来填充笔触的区域
	 * @author 浅唱
	 * @copyright myjob.liu@foxmail.com
	 * @version 1.0
	 * @see Elegant.graphic.interfaces.IDrawShape
	 */
	public class ShapePen extends PenBase
	{
		private var _drawShape:IDrawShape;
		/**
		 * 
		 * @param	thickness
		 * @param	color
		 * @param	ratios
		 */
		public function ShapePen(thickness:Number, color:Array, ratios:Array = null, drawShape:IDrawShape = null) 
		{
			super(thickness, color, ratios);
			_drawShape = drawShape;
		}
		
		/* INTERFACE Elegant.graphic.interfaces.IPen */
		/**
		 * @inheritDoc
		 */
		override public function draw(x:int, y:int):void 
		{
			var displayObj:DisplayObject = _drawShape.getShape(this);
			displayObj.x = x;
			displayObj.y = y;
			layer.addChild(displayObj);
		}
		
		/**
		 * 设置 / 获取 形状笔触
		 */
		public function get drawShape():IDrawShape 
		{
			return _drawShape;
		}
		
		public function set drawShape(value:IDrawShape):void 
		{
			_drawShape = value;
		}
	}
}