package Elegant.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	/**
	 * VBox 容器将其子项放在同一垂直列上
	 * @author 浅唱
	 * @version 1.0
	 */
	public class VBox extends BaseLayout
	{
		/**
		 * 左对齐 默认
		 */
		public static const LEFT:String = "left";
		/**
		 * 右对齐
		 */
		public static const RIGHT:String = "right";
		/**
		 * 中心对齐
		 */
		public static const CENTER:String = "center";
		
		/**
		 * VBox 容器将其子项放在同一垂直列上
		 */
		public function VBox(gap:int)
		{
			super(gap);
			align = LEFT;
		}
		
		/**
		 * forceIndex无效
		 * @inheritDoc
		 */
		override public function nextPosition(child:DisplayObject, forceIndex:int = -1):Point
		{
			var point:Point;
			var gap:int = this.gap;
			var height:Number = userBounds ? ((userBounds.y + gap) * numChildren - gap) : this.height;
			if (numChildren == 0)
				gap = 0;
			
			switch (align)
			{
				case LEFT: 
					point = new Point(0, height + gap);
					break;
				case RIGHT: 
					point = new Point(dimension.width - child.width, height + gap);
					break;
				case CENTER: 
					point = new Point((dimension.width - child.width) / 2, height + gap);
					break;
				default: 
					throw Error("非法的对齐方式");
			}
			return point;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function layout():void
		{
			var tempHeight:int = 0;
			var length:int = layoutArr.length;
			
			for (var i:int = 0; i < length; i += 1)
			{
				if (align == LEFT)
					layoutArr[i].x = 0;
				else if (align == RIGHT)
					layoutArr[i].x = dimension.width - layoutArr[i].width;
				else if (align == CENTER)
					layoutArr[i].x = (dimension.width - layoutArr[i].width) / 2;
				else
					throw Error("非法的对齐方式");
				
				layoutArr[i].y = userBounds ? userBounds.y * i : tempHeight;
				tempHeight += layoutArr[i].height + gap;
			}
		}
	}
}