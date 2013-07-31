package Elegant.layout
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author 浅唱
	 */
	public class BlockBox extends BaseLayout
	{
		/**
		 * 横向 默认
		 * $$$ $$
		 * $$$
		 * $$$
		 */
		public static const HORIZONTAL:String = "horizontal";
		/**
		 * 纵向
		 * $$$
		 * $$$
		 * $$$
		 *
		 * $
		 * $
		 */
		public static const VERTICAL:String = "vertical";
		/**
		 * 横向排序 纵向优先
		 * $$$ $
		 * $$$ $
		 * $$$
		 */
		public static const HORIZONTAL_VFIRST:String = "horizontal_Vfirst";
		/**
		 * 纵向排序 横向优先
		 * $$$
		 * $$$
		 * $$$
		 *
		 * $$
		 */
		public static const VERTICAL_VFIRST:String = "vertical_Hfirst";
		
		/**
		 * 锁定当removeChild的时候重新定位所有
		 */
		public var locked:Boolean;
		/**
		 * 块之间的间距
		 */
		private var _blockGap:int;
		
		private var _hSize:int;
		private var _vSize:int;
		private var block:int;
		
		private var gdX:int;
		private var gdY:int;
		private var blockGdX:int;
		private var blockGdY:int;
		
		/**
		 * 
		 * @param	hSize
		 * @param	vSize
		 * @param	gap			间距
		 * @param	blockGap	块间距
		 */
		public function BlockBox(hSize:int, vSize:int, gap:int = 5, blockGap:int = 10)
		{
			super(gap);
			align = HORIZONTAL;
			
			_hSize = hSize;
			_vSize = vSize;
			_blockGap = blockGap;
			
			block = hSize * vSize;
		}
		
		/**
		 * child属性无效
		 * @inheritDoc
		 */
		override public function nextPosition(child:DisplayObject, forceIndex:int = -1):Point
		{
			var point:Point = new Point();
			var index:int = forceIndex == -1 ? numChildren : forceIndex;
			
			switch (align)
			{
				case HORIZONTAL: 
					point.x = int(index % _hSize) * gdX + int(index / block) * blockGdX;
					point.y = int(index / _hSize) % _vSize * gdY;
					break;
				case VERTICAL: 
					point.x = int(index / _vSize) % _hSize * gdX;
					point.y = int(index % _vSize) * gdY + int(index / block) * blockGdY;
					break;
				case HORIZONTAL_VFIRST: 
					point.x = int(index / _vSize) % _hSize * gdX + int(index / block) * blockGdX;
					point.y = int(index % _vSize) * gdY;
					break;
				case VERTICAL_VFIRST: 
					point.x = int(index % _hSize) * gdX;
					point.y = int(index / _hSize) % _vSize * gdY + int(index / block) * blockGdY;
					break;
			}
			return point;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function layout():void
		{
			if (locked)
				return;
			
			gdX = gap + (userBounds ? userBounds.x : dimension.width);
			gdY = gap + (userBounds ? userBounds.y : dimension.height);
			blockGdX = blockGap + _hSize * gdX;
			blockGdY = blockGap + _vSize * gdY;
			
			var length:int = layoutArr.length;
			
			for (var i:int = 0; i < length; i += 1)
			{
				var point:Point = nextPosition(null, i);
				layoutArr[i].x = point.x;
				layoutArr[i].y = point.y;
			}
		}
		
		//--------------------------------getter / setter-------------------
		
		/**
		 *  设置 / 获取 每个block中每行放入child的数量
		 */
		public function get hSize():int
		{
			return _hSize;
		}
		
		public function set hSize(value:int):void
		{
			_hSize = value;
			block = _hSize * _vSize;
			
			layout();
		}
		
		/**
		 *  设置 / 获取 每个block中每列放入child的数量
		 */
		public function get vSize():int
		{
			return _vSize;
		}
		
		public function set vSize(value:int):void
		{
			_vSize = value;
			block = _hSize * _vSize;
			
			layout();
		}
		
		/**
		 * 设置 / 获取 block之间的距离
		 */
		public function get blockGap():int
		{
			return _blockGap;
		}
		
		public function set blockGap(value:int):void
		{
			_blockGap = value;
			
			layout();
		}
	}

}