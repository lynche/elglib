package Elegant.graphic.interfaces 
{
	import flash.display.DisplayObject;
	
	/**
	 * 形状填充
	 * @version 1.0
	 * @copyright myjob.liu@foxmail.com
	 * @author 浅唱
	 */
	public interface IDrawShape
	{
		/**
		 * 返回新的DisplayObject,包含指定的形状
		 * @param	pen	获取pen,是为了获得颜色值,粗细...等等系列样式
		 * @return
		 */
		function getShape(pen:IPen):DisplayObject
	}
}