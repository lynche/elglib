package Elegant.display
{
	import Elegant.utils.ChildrenKiller;
	import Elegant.utils.Cloning;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * 9宫格缩放的sprite
	 * 变成这个东西后虽然可以使用9宫格缩放,但是却不能响应子元件的任何事件(话说会响应的,现在不行)
	 * @author 浅唱
	 */
	public class Scale9Panel extends Container
	{
		/**
		 * 此类中唯一的显示对象
		 */
		private var bitmap:Bitmap;
		/**
		 * 目标对象
		 */
		private var _source:DisplayObject;
		
		private var _width:int;
		private var _height:int;
		private var containerMode:Boolean;
		
		private var _holdWidth:int;
		private var _holdHeight:int;
		
		/**
		 * 锁定BitmapData
		 */
		private var _lock:Boolean;
		/**
		 * 如果_scale9Grid不为null,则优先使用_scale9Grid传入的9宫格
		 * 本类不能直接从fla继承得到
		 * 
		 * @param	source
		 * @param	_scale9Grid
		 * @see Elegant.utils.Cloning#cloneAll()
		 * @example 下边是一个例子:
		 * <listing version="3.0">
		 * var spt:Sprite = new Sprite();
		 * spt.x = 50;//举例设置过属性,本类会拷贝所有存取器值与public变量到Scale9Panel,除了["scaleZ", "scaleX", "scaleY","rotationX", "rotationY", "rotationZ", "z", "scale9Grid", "width", "height"]
		 * var scale9Sprite = new Scale9Panel(spt);
		 * trace(scale9Sprite.x)//50;
		 * </listing>
		 */
		public function Scale9Panel(source:DisplayObject, _scale9Grid:Rectangle = null)
		{
			super();
			_source = source;
			_source.scaleX = _source.scaleY = 1;
			
			if(source is DisplayObjectContainer)
				containerMode = true;
			
			var _parent:DisplayObjectContainer = source.parent;
			if(_parent)
			{
				_parent.addChildAt(this, _parent.getChildIndex(_source));
				_parent.removeChild(_source);
			}
			Cloning.cloneAll(_source, this, ["scaleZ", "scaleX", "scaleY","rotationX", "rotationY", "rotationZ", "z", "scale9Grid", "width", "height"]);
			
			bitmap = new Bitmap();
			super.addChild(bitmap);
			
			_width = _source.width;
			_height = _source.height;
			
			if(_scale9Grid)
				scale9Grid = _scale9Grid;
			else if(source.scale9Grid)
				scale9Grid = source.scale9Grid;
			else updataBitmap();
		}
		
		/**
		 * 将普通的显示对象转为Scale9Panel
		 * @return
		 */
		public static function toScale9Panel(dis:DisplayObject):Scale9Panel
		{
			if (dis is Scale9Panel) return Scale9Panel(dis);
			
			var spt:DisplayObject;
			if(dis is Bitmap)
			{
				spt = new Sprite();
				Sprite(spt).addChild(dis);
			}
			else 
				spt = dis;
			
			var scale:Scale9Panel = new Scale9Panel(spt);
			return scale;
		}
		
		/**
		 * 重写设置9宫格缩放的方法
		 * 将每一格的rect都存进rectVec
		 * 方便取用
		 */
		override public function get scale9Grid():Rectangle
		{
			return _source.scale9Grid;
		}
		
		override public function set scale9Grid(value:Rectangle):void
		{
			_source.scale9Grid = value;
			_holdWidth = _source.scale9Grid.x + _source.width - _source.scale9Grid.right;
			_holdHeight = _source.scale9Grid.y + _source.height - _source.scale9Grid.bottom;
			updataBitmap();
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			if(!containerMode)
				throw Error("source 不是显示容器");
			var dis:DisplayObject = DisplayObjectContainer(_source).addChild(child);
			updataBitmap();
			return dis;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			if(!containerMode) 
				throw Error("source 不是显示容器");
			var dis:DisplayObject = DisplayObjectContainer(_source).addChildAt(child, index);
			updataBitmap();
			return dis;
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			if(!containerMode)
				throw Error("source 不是显示容器");
			var dis:DisplayObject = DisplayObjectContainer(_source).removeChild(child);
			updataBitmap();
			return dis;
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			if(!containerMode)
				throw Error("source 不是显示容器");
			
			var dis:DisplayObject = DisplayObjectContainer(_source).removeChildAt(index);
			updataBitmap();
			return dis;
		}
		
		override public function get numChildren():int
		{
			return DisplayObjectContainer(_source).numChildren;
		}
		
		/**
		 * 重写width,实现9宫格缩放
		 */
		override public function get width():Number
		{
			return super.width;
		}
		
		override public function set width(value:Number):void
		{
			if (value <= 0) value = 1;
			_width = Math.round(value);
			updataBitmap();
		}
		
		/**
		 * 重写height,实现9宫格缩放
		 */
		override public function get height():Number
		{
			return super.height;
		}
		
		override public function set height(value:Number):void
		{
			if (value <= 0) value = 1;
			_height = Math.round(value);
			updataBitmap();
		}
		/**
		 * 重写scaleX
		 */
		override public function get scaleX():Number 
		{
			return _width / _source.width;
		}
		
		override public function set scaleX(value:Number):void 
		{
			width = _source.width * value;
		}
		/**
		 * 重写scaleY
		 */
		override public function get scaleY():Number 
		{
			return _height / _source.height;
		}
		
		override public function set scaleY(value:Number):void 
		{
			height = _source.height * value;
		}
		/**
		 * 获取不缩放的区域的总宽度
		 */
		public function get holdWidth():int
		{
			return _holdWidth;
		}
		
		/**
		 * 获取不缩放的区域的总高度
		 */
		public function get holdHeight():int
		{
			return _holdHeight;
		}
		
		/**
		 * 返回scale9Panel的目标显示对象
		 */
		public function get source():DisplayObject
		{
			return _source;
		}
		/**
		 * 锁定BitmapData,如果为<code>true</code>将不再更新Bitmap
		 */
		public function get lock():Boolean 
		{
			return _lock;
		}
		
		public function set lock(value:Boolean):void 
		{
			_lock = value;
			if (value) updataBitmap();
		}
		
		/**
		 * 此段代码摘自sunbright的Zoom9Grid
		 */
		private function updataBitmap():void
		{
			//如果锁定了,则不刷新
			if (_lock) return;
			
			if(bitmap.bitmapData)
				bitmap.bitmapData.dispose();
			
			bitmap.bitmapData = new BitmapData(_width, _height, true, 0x00ffffff);
			if(_source.width == _width && _source.height == _height)
			{
				bitmap.bitmapData.draw(_source);
			}
			else if(scale9Grid == null)
			{
				var mtx:Matrix = new Matrix(_width / _source.width, 0, 0, _height / _source.height);
				bitmap.bitmapData.draw(_source, mtx);
			}
			else
			{
				var rows:Array = [0, scale9Grid.top, scale9Grid.bottom, _source.height];
				var cols:Array = [0, scale9Grid.left, scale9Grid.right, _source.width];
				
				var toRows:Array = [0, scale9Grid.top, height - _source.height + scale9Grid.bottom, height];
				var toCols:Array = [0, scale9Grid.left, width - _source.width + scale9Grid.right, width];
				
				var clipRect:Rectangle, matrix:Matrix, r:int, c:int, a:Number, d:Number;
				var r1:int, r2:int, c1:int, c2:int, tr1:int, tr2:int, tc1:int, tc2:int;
				
				for (c = 0; c < 3; c += 1)
				{
					for(r = 0; r < 3; r += 1)
					{
						r1 = rows[r];
						r2 = rows[r + 1];
						c1 = cols[c];
						c2 = cols[c + 1];
						tr1 = toRows[r];
						tr2 = toRows[r + 1];
						
						tc1 = toCols[c];
						tc2 = toCols[c + 1];
						clipRect = new Rectangle(tc1, tr1, tc2 - tc1, tr2 - tr1);
						a = c == 1 ? (clipRect.width / (c2 - c1)) : 1;
						d = r == 1 ? (clipRect.height / (r2 - r1)) : 1;
						matrix = new Matrix(a, 0, 0, d, tc1 - c1 * a, tr1 - r1 * d);
						bitmap.bitmapData.draw(_source, matrix, null, null, clipRect, true);
					}
				}
			}
		}
		
		/**
		 * 销毁
		 */
		override protected function dispose():void
		{
			if (bitmap)
			{
				super.removeChild(bitmap);
				if (bitmap.bitmapData) bitmap.bitmapData.dispose();
				bitmap = null;
			}
			super.dispose();
			ChildrenKiller.kill(DisplayObjectContainer(_source), true);
		}
	}
}