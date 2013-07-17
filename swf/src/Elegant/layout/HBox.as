package Elegant.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	/**
	 * VBox 容器将其子项放在同一横排上
	 * @author 浅唱
	 * @version 1.0
	 */
	public class HBox extends BaseLayout
	{
		/**
		 * 上对齐
		 */
		public static const TOP:String = "top";
		/**
		 * 下对齐 默认
		 */
		public static const BOTTOM:String = "bottom";
		/**
		 * 中心对齐
		 */
		public static const MIDDLE:String = "middle";
		
		/**
		 * VBox 容器将其子项放在同一横排上
		 */
		public function HBox(gap:int)
		{
			super(gap);
			align = BOTTOM;
		}
		
		/**
		 * forceIndex无效
		 * @inheritDoc
		 */
		override protected function nextPosition(child:DisplayObject, forceIndex:int = -1):Point
		{
			var point:Point;
			var gap:int = this.gap;
			var width:Number = userBounds ? ((userBounds.x + gap) * numChildren - gap) : this.width;
			if (numChildren == 0)
				gap = 0;
			
			switch (align)
			{
				case TOP: 
					point = new Point(width + gap, 0);
					break;
				case BOTTOM: 
					point = new Point(width + gap, dimension.height - child.height);
					break;
				case MIDDLE: 
					point = new Point(width + gap, (dimension.height - child.height) / 2);
					break;
				default: 
					throw Error("非法的对齐方式");
			}
			return point;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function layout():void
		{
			var tempWidth:int = 0;
			var length:int = layoutArr.length;
			
			for (var i:int = 0; i < length; i += 1)
			{
				switch (align)
				{
					case TOP: 
						layoutArr[i].y = 0;
						break;
					case BOTTOM: 
						layoutArr[i].y = dimension.height - layoutArr[i].height;
						break;
					case MIDDLE: 
						layoutArr[i].y = (dimension.height - layoutArr[i].height) / 2;
						break;
					default: 
						throw Error("非法的对齐方式");
				}
				
				layoutArr[i].x = userBounds ? userBounds.x * i : tempWidth;
				tempWidth += layoutArr[i].width + gap;
			}
		}
	}
}