package Elegant.display
{
	import Elegant.utils.Cloning;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * @eventType	Elegant.display.ToggleButton.STATE_CHANGE	状态改变时触发
	 */
	[Event(name="stateChange",type="Elegant.display.ToggleButton")]
	/**
	 * 粘滞按钮
	 * @author 浅唱
	 */
	public class ToggleButton extends Button
	{
		/**
		 * 状态改变时触发
		 */
		public static const STATE_CHANGE:String = "stateChange";
		
		private var _isSelected:Boolean = false;
		
		public function ToggleButton(autoConverUI:Boolean = true)
		{
			super(autoConverUI);
		}
		/**
		 * 发送状态改变事件
		 */
		private function dispatch():void 
		{
			dispatchEvent(new Event(STATE_CHANGE));
		}
		
		/**
		 * 返回button
		 * @param	_upSatet
		 * @param	_overState
		 * @param	_downState
		 * @param	_downState
		 */
		public static function toToggleButton(_upSatet:DisplayObject, _overState:DisplayObject = null, _downState:DisplayObject = null, _label:TextField = null):ToggleButton
		{
			var bt:ToggleButton = new ToggleButton(false);
			bt.upState = _upSatet;
			bt.overState = _overState;
			bt.downState = _downState;
			bt.label = _label;
			return bt;
		}
		/**
		 * 从含有命名规则的容器中返回新的ToggleButton
		 * @param	container
		 * @return
		 */
		public static function toToggleButtonFromMC(container:DisplayObjectContainer):ToggleButton
		{
			var btn:ToggleButton = new ToggleButton(false);
			Cloning.convertChildren(container, btn);
			btn.x = container.x;
			btn.y = container.y;
			
			if (container.parent)
			{
				container.parent.addChildAt(btn, container.parent.getChildIndex(container));
				container.parent.removeChild(container);
			}
			
			btn.converUI();
			return btn;
		}
		//--------MouseEvent Handler--------------------------
		/**
		 * @inheritDoc
		 */
		override protected function onMouseUpHandler(e:MouseEvent):void
		{
			if (_lock) return;
			if(!_isSelected)
				super.onMouseUpHandler(e);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function onMouseDownHandler(e:MouseEvent):void
		{
			if (_lock) return;
			_isSelected = !_isSelected;
			super.onMouseDownHandler(e);
			dispatch();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function onRollOutHandler(e:MouseEvent):void
		{
			if(!_isSelected)
				super.onRollOutHandler(e);
			else
			{
				_downState.visible = true
				if(contains(_overState))
					_overState.visible = false;
				if(contains(_upState))
					_upState.visible = false;
			}
		}
		
		//--------getter / setter---------------------------
		/**
		 * 当前该按钮是否为选中状态
		 */
		public function get isSelected():Boolean
		{
			return _isSelected;
		}
		
		public function set isSelected(value:Boolean):void
		{
			if(_isSelected == !value)
			{
				if (_lock) return;
				onMouseDownHandler(null);
				onMouseUpHandler(null);
			}
		}
	}
}