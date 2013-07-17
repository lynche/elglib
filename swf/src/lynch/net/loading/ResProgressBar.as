package lynch.net.loading
{
	import com.greensock.TweenNano;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import lynch.net.loading.interfaces.IProgressBar;
	
	/**
	 * 加载进度条
	 * @author Lynch
	 */
	public class ResProgressBar implements IProgressBar
	{
		private var addChildDelayCall:TweenNano;
		/**
		 * @param	parent
		 * @param	delay	延迟几秒后,将进度条添加到parent, 目的在于时间内加载完成了的话,就不需要显示进度条了
		 */
		public function ResProgressBar(parent:DisplayObjectContainer, delay:Number = 0)
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			if (parent)
				addChildDelayCall = TweenNano.delayedCall(delay, parent.addChild, [this]);
		}
		
		private function onAddToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			stage.addEventListener(Event.RESIZE, onResize);
			
			onResize(null);
		}
		
		private function onResize(e:Event):void
		{
			x = stage.stageWidth >> 1;
			y = stage.stageHeight >> 1;
		}
		
		/* INTERFACE core.loading.interfaces.IProgressBar */ /**
		 * @inheritDoc
		 */
		public function updata(ratio:Number, bytesLoaded:int, bytesTotal:int, name:String):void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function dispose():void
		{
			addChildDelayCall && (addChildDelayCall.kill());
			
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			if (parent)
			{
				stage.removeEventListener(Event.RESIZE, onResize);
				parent.removeChild(this);
			}
		}
	}
}