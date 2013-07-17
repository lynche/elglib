package Elegant.events 
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	
	/**
	 * ToolTip调度时使用的事件
	 * @version 1.0
	 * @copyright myjob.liu@foxmail.com
	 * @author 浅唱
	 */
	public class ToolTipEvent extends Event 
	{
		private var _tipTarget:InteractiveObject;
		/**
		 * 将要显示的时候触发
		 */
		public static const ON_TOOLTIP_OPEN:String = "onToolTipOpen";
		/**
		 * 将要关闭的时候触发
		 */
		public static const ON_TOOLTIP_CLOSE:String = "onToolTipClose";
		
		public function ToolTipEvent(type:String, tipTarget:InteractiveObject, cancelable:Boolean=false) 
		{ 
			super(type, false, cancelable);
			_tipTarget = tipTarget;
		} 
		
		public override function clone():Event 
		{ 
			return new ToolTipEvent(type, _tipTarget, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ToolTipEvent", "tipTarget", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		/**
		 * 显示或隐藏ToolTip的目标对象
		 */
		public function get tipTarget():InteractiveObject 
		{
			return _tipTarget;
		}
		
	}
	
}