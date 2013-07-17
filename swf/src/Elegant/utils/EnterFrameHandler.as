package Elegant.utils 
{
	import Elegant.ELGManager;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author 小痛
	 */
	public final class EnterFrameHandler 
	{
		private var shape:Shape;
		private var calls:Vector.<Function>;
		private static var _instance:EnterFrameHandler;
		
		public function EnterFrameHandler() 
		{
			shape = new Shape;
			calls = new Vector.<Function>();
			
			if(ELGManager.hasInit())
				ELGManager.getInstance.addToDispose(this, dispose);
		}
		
		public static function add(func:Function):void
		{
			_instance ||= new EnterFrameHandler;
			
			if (_instance.calls.indexOf(func) != -1)
				return;
			
			_instance.calls.push(func);
			
			if(!_instance.shape.hasEventListener(Event.ENTER_FRAME))
				_instance.shape.addEventListener(Event.ENTER_FRAME, _instance.onRenderTime);
		}
		
		public static function remove(func:Function):void
		{
			var i:int = _instance.calls.indexOf(func);
			if (i != -1)
			{
				_instance.calls.splice(i, 1);
				
				if (_instance.calls.length == 0)
					_instance.shape.removeEventListener(Event.ENTER_FRAME, _instance.onRenderTime);
			}
		}
		
		private function dispose():void
		{
			shape.removeEventListener(Event.ENTER_FRAME, onRenderTime);
			shape = null;
			
			calls = null;
		}
		
		private function onRenderTime(e:Event):void 
		{
			var t:int = getTimer();
			var c:Vector.<Function> = calls;
			for each (var f:Function in c) 
				f.call(null, t);
		}
	}

}