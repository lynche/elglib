package Elegant.core
{
	import Elegant.display.ToggleButton;
	import flash.events.Event;
	
	/**
	 * @eventType	flash.events.Event.CHANGE	当前选中按钮改变时触发
	 */
	[Event(name = "change", type = "flash.events.Event")]
	/**
	 * ...
	 * @author 浅唱
	 * @copyright 513151217@qq.com
	 * @version 1.0
	 */
	public class RadioGroup extends MultipleGroup
	{
		/**
		 * 当前选中的按钮
		 */
		protected var _currentBt:ToggleButton;
		/**
		 * 是否允许单选按钮被选中后再次点击时返回未选中状态
		 */
		public var allowUnSelect:Boolean;
		
		public function RadioGroup(buttons:Array = null, defaultBt:ToggleButton = null)
		{
			super(buttons);
			if (defaultBt)
			{
				defaultBt.isSelected = true;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function addToGroup(togBts:ToggleButton):int 
		{
			if (_currentBt != null && togBts.isSelected) togBts.isSelected = false;
			if (_currentBt == null && togBts.isSelected)_currentBt = togBts;
			return super.addToGroup(togBts);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function onButtonStateChange(e:Event):void
		{
			if(e.currentTarget.isSelected)
			{
				if(_currentBt)
				{
					_currentBt.removeEventListener(ToggleButton.STATE_CHANGE, onButtonStateChange);
					_currentBt.lock = false;
					_currentBt.isSelected = false;
					_currentBt.addEventListener(ToggleButton.STATE_CHANGE, onButtonStateChange);
				}
				_currentBt = ToggleButton(e.currentTarget);
				_currentBt.lock = !allowUnSelect;
				dispatchEvent(new Event(Event.CHANGE));
			}
			else
			{
				if(_currentBt == ToggleButton(e.currentTarget))
				{
					_currentBt = null;
					dispatchEvent(new Event(Event.CHANGE));
				}
			}
		}
		
		//--------getter / setter------------------------
		/**
		 * 设置 / 获取 当前被选中的按钮
		 */
		public function get currentBt():ToggleButton
		{
			return _currentBt;
		}
		
		public function set currentBt(value:ToggleButton):void
		{
			if (_buttons.indexOf(value) == -1) return;
			value.isSelected = true;
		}
	}

}