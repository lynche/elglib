package Elegant.events 
{
	import Elegant.ELGManager;
	import flash.events.Event;
	
	/**
	 * ELGFLA中的event事件
	 * @author 浅唱
	 */
	public class ELGEvent extends Event
	{
		/**
		 * 存储事件信息
		 */
		private var _msg:*;
		
		/**
		 * @param	type
		 * @param	_msg
		 * @param	bubbles
		 * @param	cancelable
		 */
		public function ELGEvent(type:String, _msg:* = null, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
			this._msg = _msg;
		}

		/**
		 * 获取事件信息
		 */
		public function get msg():* { return _msg; }
		
		/**
		 * 重写克隆,使其返回自身即可
		 * 算了吧,还是返回new的好,不然会出错滴
		 * @return 自身ELGEvent
		 */
		override public function clone():Event 
		{
			return new ELGEvent(type, _msg, bubbles, cancelable);;
		}
	}
}