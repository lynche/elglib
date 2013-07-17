package Elegant.events
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**
	 * 列表事件
	 * @author 浅唱
	 */
	public class ListEvent extends Event
	{
		/**
		 * @eventType	itemSelect	当前选中更换时触发
		 */
		public static const ITEM_SELECT:String = "itemSelect";
		
		private var _onSelectLabel:String;
		private var _onSelectID:int;
		private var _listItem:DisplayObject;
		/**
		 * @param	type
		 * @param	ID
		 * @param	label
		 * @param	bubbles
		 * @param	cancelable
		 */
		public function ListEvent(type:String, itemID:int, text:String, listItem:DisplayObject, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_listItem = listItem;
			_onSelectLabel = text;
			_onSelectID = itemID;
		}
		
		//--------getters / setters------------------------------------------------------
		/**
		 * 获取被选中的文本
		 */
		public function get onSelectLabel():String
		{
			return _onSelectLabel;
		}
		/**
		 * 获取被选中的ID
		 */
		public function get onSelectID():int
		{
			return _onSelectID;
		}
		/**
		 * 当前选中项
		 */
		public function get listItem():DisplayObject 
		{
			return _listItem;
		}
		/**
		 * 你懂的
		 * @return
		 */
		public override function clone():Event
		{
			return new ListEvent(type, onSelectID, onSelectLabel, listItem, bubbles, cancelable);
		}
		/**
		 * 你懂的
		 * @return
		 */
		public override function toString():String
		{
			return formatToString("ListEvent", "onSelectID", "onSelectLabel", "listItem", "type", "bubbles", "cancelable", "eventPhase");
		}
	
	}

}