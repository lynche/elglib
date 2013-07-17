package Elegant.utils
{
	import Elegant.utils.HashMap;
	import Elegant.utils.InitObject;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	/**
	 * 影片剪辑的控制
	 * @author 浅唱
	 */
	public class McCtrler
	{
		/**
		 * 默认帧频 默认值120 实际上不会超过flashPlayer当前的帧频
		 */
		public static var defaultFrameRate:int = 120;
		
		private static var shape:Shape = new Shape();
		private static var calls:Vector.<Function> = new Vector.<Function>;
		private static var paused:Vector.<Function>;
		
		internal static var mcHash:HashMap = new HashMap();
		
		internal var targetMc:*;
		internal var prevOrNext:Function;
		
		public var equal:int;
		public var afterCall:Function;
		public var afterCallParams:Array;
		
		private var _frameRate:int;
		private var rframe:int;
		private var t:Number;
		private var repeat:int;
		
		/**
		 * 影片剪辑的控制
		 * @param	targetMc
		 * @param	prevOrNext
		 * @param	equal
		 */
		public function McCtrler(targetMc:* = null, prevOrNext:Function = null, equal:int = 0)
		{
			this.targetMc = targetMc;
			this.prevOrNext = prevOrNext;
			this.equal = equal;
			frameRate = defaultFrameRate;
		}
		
		/**
		 * 停止所有
		 * @param	except	排除(mc || SpriteSheet)
		 */
		public static function stopAll(except:Array):void
		{
			var l:int = calls.length;
			
			if(except != null)
			{
				paused = new Vector.<Function>();
				var temp:Array = [];
				var el:int = except.length;
				while (--el >= 0)
				{
					if(mcHash.has(except[el]))
						temp[el] = mcHash.get(except[el]).onEnterFrameHandler;
				}
				
				while (--l >= 0)
				{
					var i:int = temp.indexOf(calls[l]);
					if (i == -1)
					{
						paused.push(calls.splice(l, 1)[0]);
					} else {
						temp.splice(i, 1);
						
						if (temp.length == 0)
						{
							paused = paused.concat(calls.splice(0, --l));
							return;
						}
					}
				}
			} else {
				paused = calls;
				calls = new Vector.<Function>();
			}
				
		}
		
		/**
		 * 继续播放
		 */
		public static function resume():void
		{
			calls = calls.concat(paused);
			paused = null;
			
			if (calls.length && !shape.hasEventListener(Event.ENTER_FRAME))
				shape.addEventListener(Event.ENTER_FRAME, onRenderTime);
		}
		
		/**
		 * 播放MC到某一帧
		 * @param	mc
		 * @param	frame	默认:-1 表示播放到mc的最后一帧
		 * @param	afterCall
		 * @param	objectVars
		 * 			<li> afterCallParams : Array - 默认: null</li>
		 * 			<li> repeat : int - 重复次数,若要一直循环需设为-1 默认: 0</li>
		 */
		public static function toFrame(mc:*, frame:int = -1, afterCall:Function = null, objectVars:Object = null):McCtrler
		{
			if (mcHash.has(mc))
				destroy(mc);
			
			if (frame == -1)
				frame = mc.totalFrames;
			
			var mcCtrler:McCtrler = new McCtrler;
			mcCtrler.repeat = InitObject.getInt(objectVars, "repeat", 0);
			mcCtrler.t = 0;
			mcCtrler.targetMc = mc;
			mcCtrler.rframe = mc.currentFrame;
			mcCtrler.prevOrNext = (mc.currentFrame < frame ? mc.nextFrame : mc.prevFrame);
			mcCtrler.equal = frame;
			
			mcCtrler.afterCall = afterCall;
			mcCtrler.afterCallParams = InitObject.getArray(objectVars, "afterCallParams");
			mcCtrler.order();
			
			mcHash.add(mc, mcCtrler);
			return mcCtrler;
		}
		
		/**
		 * 播放MC到某一帧标签
		 * @param	mc
		 * @param	label
		 * @param	afterCall
		 * @param	objectVars
		 * 			<li> afterCallParams : Array - 默认: null</li>
		 * 			<li> repeat : int - 重复次数,若要一直循环需设为-1 默认: 0</li>
		 * 			<li> atFirstFrame : Boolean - 用于指定到某一帧标签的最后一帧或是第一帧 默认: true</li>
		 */
		public static function toLabel(mc:*, label:String, afterCall:Function = null, objectVars:Object = null):McCtrler
		{
			var labels:Array = mc.currentLabels;
			var index:int = getFrameByLabel(mc, label);
			if (index == -1)
				return null;
			
			var frame:int = InitObject.getBoolean(objectVars, "atFirstFrame", true) ? index : getLastFrameByLabel(mc, label);
			return McCtrler.toFrame(mc, frame, afterCall, objectVars);
		}
		
		/**
		 * 根据帧标签返回帧(帧标签中的第一帧)
		 * 找不到帧标签则返回第一帧
		 * @param	mc
		 * @param	label
		 * @return
		 */
		public static function getFrameByLabel(mc:*, label:String):int
		{
			var cls:Array = mc.currentLabels;
			
			for each (var item:* in cls) 
			{
				if (item.name == label)
				{
					return item.frame;
				}
			}
			return 1;
		}
		
		/**
		 * 根据帧标签返回帧(帧标签中的最后一帧)
		 * 若找不到帧标签则返回最后一帧
		 * @param	mc
		 * @param	label
		 * @return
		 */
		public static function getLastFrameByLabel(mc:*, label:String):int
		{
			var cls:Array = mc.currentLabels;
			var i:int;
			
			for each (var item:* in cls) 
			{
				if (item.name == label)
				{
					if (i < cls.length - 1)
					{
						return cls[i + 1].frame - 1;
					}
					return mc.totalFrames;
				}
				++i;
			}
			return mc.totalFrames;
		}
		
		/**
		 * 销毁对某个mc的控制
		 * @param	mc
		 */
		public static function destroy(mc:*, callComplete:Boolean = false):void
		{
			if (mcHash == null) return;
			var mcCtrler:McCtrler = mcHash.get(mc);
			if (mcCtrler)
			{
				mcCtrler.refuse(callComplete);
			}
		}
		
		private static function onRenderTime(e:Event):void 
		{
			var p:int = getTimer();
			for each (var f:Function in calls) 
			{
				f.call(null, p);
			}
			if (f == null)
				shape.removeEventListener(Event.ENTER_FRAME, onRenderTime);
		}
		
		/**
		 * 停止所有容器内的MC
		 */
		public static function stopAllMCInContainer(mc:DisplayObjectContainer):void
		{
			var l:int = mc.numChildren;
			for (var i:int = 0; i < l; i++) 
			{
				var d:DisplayObject = mc.getChildAt(i);
				if (d is DisplayObjectContainer)
				{
					stopAllMCInContainer(DisplayObjectContainer(d));
					
					if (d is MovieClip)
						MovieClip(d).stop();
				}
			}
		}
		
		/**
		 * 执行
		 */
		public function order():void
		{
			calls.push(onEnterFrameHandler);
			
			if(!shape.hasEventListener(Event.ENTER_FRAME))
				shape.addEventListener(Event.ENTER_FRAME, onRenderTime);
			//targetMc.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}
		
		/**
		 * 终止
		 * @param	callComplete
		 */
		public function refuse(callComplete:Boolean = false):void
		{
			mcHash.reduce(targetMc);
			
			var i:int;
			if (paused)
			{
				i = paused.indexOf(onEnterFrameHandler);
				if (i != -1)
					paused.splice(i, 1);
			}
			i = calls.indexOf(onEnterFrameHandler);
			if (i != -1)
				calls.splice(i, 1);
			
			//targetMc.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			targetMc = null;
			prevOrNext = null;
			
			var afCall:Function = afterCall;
			var afCallParams:Array = afterCallParams;
			afterCall = null;
			afterCallParams = null;
			
			if (callComplete && afCall != null)
			{
				afCall.apply(null, afCallParams);
			}
		}
		
		private function onEnterFrameHandler(s:int):void
		{
			if (s - t < _frameRate)
				return;
			
			t = s;
			
			if (targetMc.currentFrame == equal)
			{
				if (repeat--)
				{
					targetMc.gotoAndStop(rframe);
					targetMc.dispatchEvent(new Event("repeat"));
				} else {
					refuse(true);
				}
			}
			else
			{
				prevOrNext();
			}
		}
		
		/**
		 * 设置 / 获取 帧频
		 */
		public function get frameRate():int 
		{
			return 1000 / _frameRate;
		}
		
		public function set frameRate(value:int):void 
		{
			_frameRate = 1000 / value;
		}
	}

}