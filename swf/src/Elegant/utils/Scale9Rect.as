package Elegant.utils
{
	import Elegant.display.Scale9Panel;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	/**
	 * 使用9宫格时的一些工具
	 * @author 浅唱
	 */
	public final class Scale9Rect
	{
		
		public function Scale9Rect()
		{
		
		}
		
		/**
		 * 获取9宫格缩放时，设置大小后被缩放的区域等于width，height后整个对象的大小与位置
		 * (填充内心获取外部)
		 * @param	whTarget
		 * @param	width
		 * @param	height
		 * @return
		 */
		public static function getRealRect(whTarget:DisplayObject, width:int, height:int):Rectangle
		{
			var rect:Rectangle;
			var scaleX:Number = whTarget.scaleX;
			var scaleY:Number = whTarget.scaleY;
			if(whTarget is Scale9Panel)
			{
				rect = whTarget["source"].getRect(whTarget["source"]);
			}
			else
			{
				whTarget.scaleX = whTarget.scaleY = 1;
				rect = whTarget.getRect(whTarget);
			}
			var scale9:Rectangle = whTarget.scale9Grid;
			if(scale9)
			{
				var result:Rectangle;
				if(rect.containsRect(scale9))
				{
					result = new Rectangle(0, 0, width + scale9.x + rect.right - scale9.right, height + scale9.y + rect.bottom - scale9.bottom);
					
					if(!(whTarget is Scale9Panel))
					{
						whTarget.scaleX = scaleX;
						whTarget.scaleY = scaleY;
					}
				}
				else
					throw Error("scale9Grid无效");
				return result;
			}
			else
			{
				rect.width = width;
				rect.height = height;
				if (scaleX) whTarget.scaleX = scaleX;
				if (scaleY) whTarget.scaleY = scaleY;
			}
			return rect;
		}
	}

}