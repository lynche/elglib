package Elegant.layout
{
	import Elegant.utils.ArrayUtil;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 布局父类,本身不提供布局
	 * 只是提供些公用的方法供子类继承
	 * @author 浅唱
	 * @version 1.0
	 */
	internal class BaseLayout extends Sprite
	{
		/**
		 * 自定义每一个item的宽高, 定位将依据该宽高
		 */
		public var userBounds:Point;
		/**
		 * 排列用的数组
		 * 数组顺序即为子元件排列顺序
		 * 数组长度始终等于numChildren
		 */
		protected var layoutArr:Array = [];
		
		private var _gap:int;
		private var _align:String;
		
		/**
		 * 维度,标识该容器中最大尺寸的宽与高
		 * 方便在子类调整位置时使用
		 * 例:在VBox中,当align为right时
		 * dimension标识最宽的物体
		 * 其他物体的定位可以为 child.x = dimension.width - child.width;
		 */
		protected var dimension:Rectangle = new Rectangle();
		
		/**
		 * 不要直接使用该类
		 * @param	gap		间距
		 */
		public function BaseLayout(gap:int)
		{
			 if (getQualifiedClassName(this) == "utils.layout.BaseLayout")
				throw Error("不要直接使用该类");
			
			_gap = gap;
		}
		
		/**
		 * 销毁
		 * @param	childCall
		 */
		public function dispose(childCall:String = null):void
		{
			killChildren(childCall);
			
			layoutArr = null;
			dimension = null;
		}
		
		/**
		 * 清除子元件
		 * @param	childCall
		 */
		public function killChildren(childCall:String = null):void
		{
			while (numChildren)
			{
				var child:DisplayObject = super.removeChildAt(0);
				if (childCall)
					child[childCall]();
			}
			layoutArr = [];
			dimension = new Rectangle();
		}
		
		/**
		 * 重写addChild,定位新元件
		 * @inheritDoc
		 */
		override public function addChild(child:DisplayObject):DisplayObject
		{
			var needLayouAll:Boolean = false;
			
			if(userBounds == null || numChildren == 0)
			{
				if (child.width > dimension.width)
				{
					dimension.width = child.width;
					needLayouAll = true;
				}
				if (child.height > dimension.height)
				{
					dimension.height = child.height;
					needLayouAll = true;
				}
			}
			
			layoutArr.push(child);
			if (needLayouAll)
			{
				layout();
			}
			else
			{
				var point:Point = nextPosition(child);
				child.x = point.x;
				child.y = point.y;
			}
			return super.addChild(child);
		}
		
		/**
		 * 重写addChildAt,定位新元件
		 * @inheritDoc
		 */
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			var needLayouAll:Boolean = false;
			if (child.width > dimension.width)
			{
				dimension.width = child.width;
				needLayouAll = true;
			}
			if (child.height > dimension.height)
			{
				dimension.height = child.height;
				needLayouAll = true;
			}
			
			layoutArr.splice(index, 0, child);
			layout();
			
			return super.addChildAt(child, index);
		}
		
		/**
		 * 重写removeChild,定位元件
		 * @inheritDoc
		 */
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			layoutArr.splice(layoutArr.indexOf(child), 1);
			
			var arr:Array = layoutArr.concat();
			
			if(arr.length)
			{
				if (child.width >= dimension.width)
				{
					ArrayUtil.quickSortProperties(arr, "width")
					dimension.width = arr[arr.length - 1].width;
				}
				if (child.height >= dimension.height)
				{
					ArrayUtil.quickSortProperties(arr, "height")
					dimension.height = arr[arr.length - 1].height;
				}
			} else {
				dimension.width = dimension.height = 0;
			}
			
			layout();
			return super.removeChild(child);
		}
		
		/**
		 * 重写removeChildAt,定位元件
		 * @inheritDoc
		 */
		override public function removeChildAt(index:int):DisplayObject
		{
			var child:DisplayObject = super.removeChildAt(index);
			layoutArr.splice(layoutArr.indexOf(child), 1);
			
			var arr:Array = layoutArr.concat();
			if (child.width >= dimension.width)
			{
				ArrayUtil.quickSortProperties(arr, "width")
				dimension.width = arr[arr.length - 1].width;
			}
			if (child.height >= dimension.height)
			{
				ArrayUtil.quickSortProperties(arr, "height")
				dimension.height = arr[arr.length - 1].height;
			}
			
			layout();
			return child;
		}
		
		/**
		 * 设置子元件排列顺序
		 * @param	child
		 * @param	index
		 */
		public function setChildLayoutIndex(child:DisplayObject, index:int):void
		{
			var oldIndex:int = layoutArr.indexOf(child);
			if (oldIndex != -1)
			{
				layoutArr.splice(index, 0, layoutArr.splice(oldIndex, 1)[0]);
			}
			layout();
		}
		
		/**
		 * 返回下一个元件应该在的位置
		 * @param	child	当前被添加的元件
		 * @param	forceIndex	获取在指定索引时的位置
		 * @return	被添加的元件应在的坐标
		 * @throws 非法的对齐方式
		 */
		public function nextPosition(child:DisplayObject, forceIndex:int = -1):Point
		{
			return new Point();
		}
		
		/**
		 * 按照自身的规则排列所有子元件
		 * @throws 非法的对齐方式
		 */
		public function layout():void
		{
			throw Error("Must be override");
		}
		
		//-----------------------------getter / setter----------------------------
		/**
		 * 设置 / 获取 布局元素之间的(垂直/ 横向)空间（以像素为单位）。
		 */
		public function get gap():int
		{
			return _gap;
		}
		
		public function set gap(value:int):void
		{
			_gap = value;
			layout();
		}
		
		/**
		 * 设置 / 获取 对齐方式(因各个子类不同而不同)
		 * 究竟使用其x,还是使用y override layout中自己决定
		 * @see #layout()
		 */
		public function get align():String
		{
			return _align;
		}
		
		public function set align(value:String):void
		{
			_align = value;
			layout();
		}
	}
}