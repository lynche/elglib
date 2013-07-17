package Elegant.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @version 1.0
	 * @copyright 513151217@qq.com
	 * @author 浅唱
	 */
	public class PopUpEvent extends Event 
	{
		/**
		 * Alert被关闭时调度
		 */
		public static const ALERT_SHUT_DOWN:String = "alertShutDown";
		
		private var _funcIndex:int;
		
		/**
		 * Alert被关闭时调度
		 * @param	type
		 * @param	funcIndex	调用Alert.show方法时,传入flag参数的位置
		 * @param	bubbles
		 * @param	cancelable
		 */
		public function PopUpEvent(type:String, funcIndex:int, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			_funcIndex = funcIndex;
		} 
		
		public override function clone():Event 
		{ 
			return new PopUpEvent(type, _funcIndex, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("PopUpEvent", "funcIndex", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get funcIndex():int 
		{
			return _funcIndex;
		}
		
	}
	
}