package Elegant.utils 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * 动态注册点
	 * @author 浅唱
	 */
	public class DynamicRegistration 
	{
		private var _gapPoint:Point;
		private var disContainer:DisplayObjectContainer;
		private var rect:Rectangle;
		
		public function DynamicRegistration(disContainer:DisplayObjectContainer) 
		{
			this.disContainer = disContainer;
			if (disContainer.numChildren == 0)
			{
				trace("a DisplayObjectContainer without any child no need to use this Class");
			}
			
			rect = disContainer.getRect(disContainer);
		}
		
		/**
		 * 改变注册点
		 * @param	point	默认改变到中心
		 * @param	doNow
		 * @return
		 */
		public function registration(point:Point = null, doNow:Boolean = true):Point
		{
			if (_gapPoint)
			{
				reset();
			}
			
			point ||= new Point(rect.width * .5, rect.height * .5);
			_gapPoint = new Point(rect.x + point.x, rect.y + point.y);
			
			if (doNow)
			{
				var i:int = disContainer.numChildren;
				var child:DisplayObject;
				while (--i >= 0) 
				{
					child = disContainer.getChildAt(i);
					child.x -= gapPoint.x;
					child.y -= gapPoint.y;
				}
				
				disContainer.x += gapPoint.x * disContainer.scaleX;
				disContainer.y += gapPoint.y * disContainer.scaleX;
			}
			return _gapPoint;
		}
		
		/**
		 * 复原到之前的注册点
		 */
		public function reset():void
		{
			if (gapPoint == null)
			{
				trace("no registration no reset!")
				return;
			}
			
			var i:int = disContainer.numChildren;
			var child:DisplayObject;
			
			while (--i >= 0) 
			{
				child = disContainer.getChildAt(i);
				child.x += gapPoint.x;
				child.y += gapPoint.y;
			}
			
			disContainer.x -= gapPoint.x * disContainer.scaleX;
			disContainer.y -= gapPoint.y * disContainer.scaleY;
			_gapPoint = null;
		}
		
		//------------------------------getter / setter------------------
		
		/**
		 * 获取新注册点与原注册点的相对位置
		 */
		public function get gapPoint():Point 
		{
			return _gapPoint;
		}
		
	}

}