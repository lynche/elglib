package Elegant.display
{
	import Elegant.utils.InitObject;
	import Elegant.utils.McCtrler;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.FrameLabel;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * @eventType	flash.events.Event.COMPLETE	play或playLabel动画播放完毕触发
	 */
	[Event(name = "complete", type = "flash.events.Event")]
	
	/**
	 * SpriteSheet
	 * @author 浅唱
	 */
	public class SpriteSheet extends Sprite
	{
		protected var cache:Vector.<BitmapData>;
		protected var _bitmap:Bitmap;
		protected var _bitmapData:BitmapData;
		protected var _currentLabels:Array
		protected var _sheetHeight:int;
		protected var _sheetWidth:int;
		protected var _currentFrame:int;
		protected var autoToFirst:Boolean;
		
		/**
		 * 
		 * @param	bitmapData
		 * @param	objectVars	<li><strong> sheetWidth : int</strong> - 每一块的宽</li> 
		 * 						<li><strong> sheetHeight : int</strong> - 每一块的高</li> 
		 */
		public function SpriteSheet(bitmapData:BitmapData, objectVars:Object = null)
		{
			super();
			mouseChildren = false;
			_bitmapData = bitmapData;
			_sheetWidth = InitObject.getInt(objectVars, "sheetWidth", 100);
			_sheetHeight = InitObject.getInt(objectVars, "sheetHeight", 100);
			_currentLabels = [];
			
			_bitmap = new Bitmap();
			addChild(bitmap);
			
			cacheBitmapData();
		}
		
		/**
		 * 帧数从1开始计数,为跟Mc一致
		 * @param	from		从哪帧开始播放
		 * @param	to			播放到哪一帧
		 * @param	repeat		重复播放次数
		 * @param	autoToFirst	播放完成后跳转到from帧
		 * @return
		 */
		public function play(from:uint = 1, to:int = int.MAX_VALUE, repeat:int = -1, autoToFirst:Boolean = false):McCtrler
		{
			this.autoToFirst = autoToFirst;
			
			to = to > totalFrames ? totalFrames : to;
			if (to < 1)
				return null;
			
			gotoAndStop(from);
			
			if(to != from)
				return McCtrler.toFrame(this, to, comeonBaby, { thisArg:this, repeat:repeat, afterCallParams:[from, to] } );
			else
				McCtrler.destroy(this);
			return null;
		}
		
		/**
		 * 播放指定的标签
		 * 调用后会立即跳转到指定的标签第一帧,并循环播放该标签
		 * @param	label
		 * @param	repeat		重复播放次数
		 * @param	autoToFirst	播放完成后跳转到指定的标签第一帧
		 * @return
		 */
		public function playLabel(label:String, repeat:int = -1, autoToFirst:Boolean = false):McCtrler
		{
			var from:int = McCtrler.getFrameByLabel(this, label);
			var to:int = McCtrler.getLastFrameByLabel(this, label);
			
			return play(from, to, repeat, autoToFirst);
		}
		
		/**
		 * 停止
		 */
		public function stop():void
		{
			McCtrler.destroy(this);
		}
		
		/**
		 * 跳转到某帧
		 * @param	frame
		 */
		public function gotoAndStop(frame:uint):void
		{
			frame = frame > totalFrames ? totalFrames : frame;
			
			_currentFrame = frame;
			_bitmap.bitmapData = cache[frame - 1];
		}
		
		/**
		 * 下一帧
		 */
		public function nextFrame():void
		{
			gotoAndStop(_currentFrame + 1);
		}
		
		/**
		 * 上一帧
		 */
		public function prevFrame():void
		{
			gotoAndStop(_currentFrame - 1);
		}
		
		/**
		 * 给标签命名
		 * @param	frame
		 * @param	frameLabel
		 */
		public function named(frame:int, frameLabel:String):void
		{
			var label:FrameLabel;
			var length:int = _currentLabels.length;
			for (var i:int = 0; i < length; i++)
			{
				if (_currentLabels[i].frame == frame)
					break;
			}
			label = new FrameLabel(frameLabel, frame);
			_currentLabels[i] = label;
		}
		
		/**
		 * 取消某帧的命名
		 * @param	frame
		 */
		public function unnamed(frame:int):void
		{
			var length:int = _currentLabels.length;
			for (var i:int = 0; i < length; i++)
			{
				if (_currentLabels[i].frame == frame)
				{
					_currentLabels.splice(i, 1);
					break;
				}
			}
		}
		
		/**
		 * 缓存位图,用于之后的渲染
		 */
		protected function cacheBitmapData():void
		{
			if (_bitmapData == null)
				return;
			
			var htotal:int = _bitmapData.width == _sheetWidth ? 0 : int(_bitmapData.width / _sheetWidth);
			var vtotal:int = _bitmapData.height == _sheetHeight ? 0 : int(_bitmapData.height / _sheetHeight);
			
			cache = new Vector.<BitmapData>();
			htotal ||= 1;
			vtotal ||= 1;
			
			var point:Point = new Point();
			var rect:Rectangle = new Rectangle(0, 0, _sheetWidth, _sheetHeight);
			for (var i:int = 0; i < vtotal; i++)
			{
				for (var j:int = 0; j < htotal; j++)
				{
					var bmd:BitmapData = new BitmapData(_sheetWidth, _sheetHeight, true, 0);
					rect.x = j * _sheetWidth;
					rect.y = i * _sheetHeight;
					bmd.copyPixels(_bitmapData, rect, point);
					cache.push(bmd);
				}
			}
			gotoAndStop(1);
		}
		
		/**
		 * McCtrler 播放完成后会调用该方法,以调度Complete事件
		 * 在写Player类的时候可以继承此类,并重写gotoAndStop方法及此方法,以达到播放完动作之后回到站立姿态
		 * @see #gotoAndStop()
		 */
		protected function comeonBaby(from:int, to:int):void
		{
			if (autoToFirst)
				gotoAndStop(from);
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * 销毁
		 */
		public function dispose():void 
		{
			stop();
			
			var length:int = cache.length;
			for (var i:int = 0; i < length; i++) 
			{
				cache[i].dispose();
				cache[i] = null;
			}
			_currentLabels = null;
			cache = null;
			_bitmap = null;
			_bitmapData = null;
			removeChildAt(0);
		}
		
		/**
		 * 获取动画图片
		 * @return
		 */
		public function getFrameBmd(frame:uint):BitmapData
		{
			if (frame > totalFrames)
				frame = 1;
			return cache[frame];
		}
		//----------------------------getter / setter----------------------
		/**
		 * 设置 / 获取 每一块sheet的宽
		 */
		public function get sheetWidth():int
		{
			return _sheetWidth;
		}
		
		public function set sheetWidth(value:int):void
		{
			_sheetWidth = value;
			cacheBitmapData();
		}
		
		/**
		 * 设置 / 获取 每一块sheet的高
		 */
		public function get sheetHeight():int
		{
			return _sheetHeight;
		}
		
		public function set sheetHeight(value:int):void
		{
			_sheetHeight = value;
			cacheBitmapData();
		}
		
		/**
		 * 设置 / 获取 sheet作为数据源的原始图像数据
		 */
		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}
		
		public function set bitmapData(value:BitmapData):void
		{
			_bitmapData = value;
			cacheBitmapData();
		}
		
		/**
		 * 获取显示的bitmap
		 */
		public function get bitmap():Bitmap
		{
			return _bitmap;
		}
		
		/**
		 * 获取当前帧数，从1计数
		 */
		public function get currentFrame():int
		{
			return _currentFrame;
		}
		
		/**
		 * 获取总帧数
		 */
		public function get totalFrames():int
		{
			return cache.length;
		}
		
		/**
		 * 获取当前所有标签
		 */
		public function get currentLabels():Array
		{
			return _currentLabels;
		}
		
		/**
		 * 获取当前正在显示的BitmapData数据
		 */
		public function get currentBitmapdata():BitmapData
		{
			return cache ? cache[_currentFrame - 1] : null;
		}
		
		/**
		 * 设置 / 获取 每帧的bitmapData
		 */
		public function get frameCache():Vector.<BitmapData> 
		{
			return cache;
		}
		
		public function set frameCache(value:Vector.<BitmapData>):void 
		{
			cache = value;
		}
	}

}