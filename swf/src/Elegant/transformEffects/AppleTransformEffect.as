package Elegant.transformEffects 
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.TweenNano;
	import Elegant.utils.DynamicRegistration;
	import Elegant.utils.InitObject;
	import flash.display.DisplayObjectContainer;
	import Elegant.interfaces.ITransformEffect;
	import Elegant.utils.core.Singleton;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	/**
	 * 模拟苹果中的一些效果
	 * @author 浅唱
	 */
	public class AppleTransformEffect extends BasicTransformEffect 
	{
		
		public function AppleTransformEffect() 
		{
			super();
			
		}
		
		public static function get getInstance():AppleTransformEffect
		{
			return Singleton.getInstanceOrCreate(AppleTransformEffect);
		}
		
		/**
		 * 打开窗口
		 * @inheritDoc
		 */
		override public function show(dis:DisplayObject, parent:DisplayObjectContainer, objectVars:Object = null):void 
		{
			var dyReg:DynamicRegistration;
			if(dis is DisplayObjectContainer)
			{
				dyReg = new DynamicRegistration(DisplayObjectContainer(dis));
				dyReg.registration();
			}
			
			dis.scaleX = dis.scaleY = 0;
			parent.addChild(dis);
			
			tween(dis, InitObject.getNumber(objectVars, "duration", .3), { scaleX:1, scaleY:1, 
				onComplete:onTweenComplete } );
			
			function onTweenComplete():void
			{
				if (dyReg)
					dyReg.reset();
				
				var onComplete:Function = InitObject.getObject(objectVars, "onComplete") as Function;
				if (onComplete != null)
					onComplete.apply(null, InitObject.getArray(objectVars, "onCompleteParams"));
			}
		}
		
		/**
		 * 关闭窗口
		 * @inheritDoc
		 */
		override public function close(dis:DisplayObject, objectVars:Object = null):void 
		{
			var dyReg:DynamicRegistration;
			if(dis is DisplayObjectContainer)
			{
				dyReg = new DynamicRegistration(DisplayObjectContainer(dis));
				dyReg.registration();
			}
			
			tween(dis, InitObject.getNumber(objectVars, "duration", .3), { scaleX:.2, scaleY:.2, 
				onComplete:onTweenComplete } );
			
			function onTweenComplete():void
			{
				if (dyReg)
					dyReg.reset();
				
				dis.parent.removeChild(dis);
				var onComplete:Function = InitObject.getObject(objectVars, "onComplete") as Function;
				
				if (onComplete != null)
					onComplete.apply(null, InitObject.getArray(objectVars, "onCompleteParams"));
			}
		}
		
		/**
		 * 关键啊...没写完啊
		 * @inheritDoc
		 */
		override public function exchange(dis:DisplayObject, next:DisplayObject, objectVars:Object = null):void 
		{
			var parent:DisplayObjectContainer = dis.parent;
			var dyReg:DynamicRegistration, dyRegNext:DynamicRegistration;
			
			if (dis is DisplayObjectContainer)
			{
				dyReg = new DynamicRegistration(DisplayObjectContainer(dis));
				dyReg.registration();
			}
			
			if (next is DisplayObjectContainer)
			{
				dyRegNext = new DynamicRegistration(DisplayObjectContainer(next));
				dyRegNext.registration();
			}
			
			next.rotationY = 180;
			next.scaleX = next.scaleY = .5;
			parent.addChildAt(next, parent.getChildIndex(dis));
			parent.swapChildren(dis, next);
			
			var ease:Function = InitObject.getObject(objectVars, "ease") as Function;
			var time:Number = InitObject.getNumber(objectVars, "time", .5);
			
			TweenNano.to(dis, time, { rotationY:180, scaleX:.5, scaleY:.5 } );
			TweenNano.to(next, time, { rotationY:360, scaleX:1, scaleY:1 } );
			TweenMax.to(dis, time / 2, { x: -(dis.width / 3) + "", repeat:1, yoyo:true, 
				onRepeat:updateDepath, onRepeatParams:[dis, next] } );
			TweenMax.to(next, time / 2, { x:(dis.width / 3) + "", repeat:1, yoyo:true } );
		}
		
		private function updateDepath(dis:DisplayObject, next:DisplayObject):void 
		{
			dis.parent.swapChildren(dis, next);
		}
	}

}