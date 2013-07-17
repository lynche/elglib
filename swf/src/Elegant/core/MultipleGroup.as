package Elegant.core 
{
	import Elegant.display.ToggleButton;
	import Elegant.ELGManager;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * @eventType	flash.events.Event.CHANGE	当前选中按钮改变时触发
	 */
	[Event(name = "change", type = "flash.events.Event")]
	/**
	 * ...
	 * @author 浅唱
	 * @copyright myjob.liu@foxmail.com
	 * @version 1.0
	 */
	public class MultipleGroup extends EventDispatcher
	{
		/**
		 * 组内包括的按钮
		 */
		protected var _buttons:Array;
		
		public function MultipleGroup(buttons:Array = null)
		{
			if (buttons == null) buttons = [];
			for (var i:int = 0; i < buttons.length; i++) 
			{
				var item:ToggleButton = buttons[i];
				item.itemID = i;
				item.addEventListener(ToggleButton.STATE_CHANGE, onButtonStateChange);
			}
			_buttons = buttons;
			ELGManager.getInstance.addToDispose(this, dispose);
		}
		
		/**
		 * 加入group
		 * @param	togBts
		 * @return	返回按钮在当前组的索引
		 */
		public function addToGroup(togBts:ToggleButton):int
		{
			var index:int = indexInGroup(togBts);
			if (index == -1)
			{
				togBts.itemID = _buttons.length;
				_buttons.push(togBts);
				togBts.addEventListener(ToggleButton.STATE_CHANGE, onButtonStateChange);
			} else return index;
			return _buttons.length - 1;
		}
		/**
		 * 从组中删除
		 * @param	togBts
		 * @return	被删除的ToggleButton
		 */
		public function reduceFromGroup(togBts:ToggleButton):ToggleButton
		{
			var tlg:ToggleButton;
			var index:int = indexInGroup(togBts);
			if (index >= 0)
			{
				tlg = _buttons[index];
				_buttons.splice(index, 1);
				togBts.removeEventListener(ToggleButton.STATE_CHANGE, onButtonStateChange);
			} else return null;
			return tlg;
		}
		/**
		 * 
		 * @param	togBts
		 * @return	返回对象在group中的索引,如果不在组中则返回-1;
		 */
		public function indexInGroup(togBts:ToggleButton):int
		{
			return _buttons.indexOf(togBts);
		}
		
		/**
		 * 获取被选中的按钮
		 * @return
		 */
		public function getSelected():Vector.<ToggleButton>
		{
			var bts:Vector.<ToggleButton> = new Vector.<ToggleButton>();
			var l:int = _buttons.length;
			
			for (var i:int = 0; i < l; i++) 
			{
				if (_buttons[i].isSelected)
					bts.push(_buttons[i]);
			}
			return bts;
		}
		
		/**
		 * 销毁
		 */
		protected function dispose():void 
		{
			for (var i:int = 0; i < _buttons.length; i++) 
			{
				_buttons[i].removeEventListener(ToggleButton.STATE_CHANGE, onButtonStateChange);
				//ELGManager.getInstance.disposeSome(_buttons[i]);
			}
			_buttons = null;
		}
		
		//--------Event Handler--------------------------
		/**
		 * 改变组内按钮状态时触发
		 * @param	e
		 */
		protected function onButtonStateChange(e:Event):void 
		{
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		//--------getter / setter------------------------
		/**
		 * @return	Array	这个组下的所有按钮
		 */
		public function get buttons():Array 
		{
			return _buttons;
		}
		
		/**
		 * 返回Boolean数组,内容为组内各按钮的选中状态
		 */
		public function get values():Array
		{
			var result:Array = [];
			for (var i:int = 0; i < _buttons.length; i++) 
			{
				var item:ToggleButton = _buttons[i];
				result[i] = item.isSelected;
			}
			return result;
		}
	}
}