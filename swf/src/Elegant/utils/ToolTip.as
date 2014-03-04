package Elegant.utils
{
	import Elegant.baseCore.TipContainerBase;
	import Elegant.ELGManager;
	import Elegant.events.ToolTipEvent;
	import Elegant.interfaces.ITransformEffect;
	import Elegant.transformEffects.BasicTransformEffect;
	import Elegant.utils.core.Singleton;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * @eventType Elegant.events.ToolTipEvent.ON_TOOLTIP_OPEN toolTip 将要显示的时候触发
	 */
	[Event(name="onToolTipOpen",type="Elegant.events.ToolTipEvent")]
	/**
	 * @eventType Elegant.events.ToolTipEvent.ON_TOOLTIP_CLOSE toolTip 将要关闭的时候触发
	 */
	[Event(name="onToolTipClose",type="Elegant.events.ToolTipEvent")]
	
	/**
	 * 你懂的
	 * @author 浅唱
	 * @copyright myjob.liu@foxmail.com
	 * @version 1.0
	 */
	public class ToolTip extends EventDispatcher
	{
		/**
		 * 切换效果
		 */
		public var transformEffect:ITransformEffect = BasicTransformEffect.getInstance;
		/**
		 * 当鼠标移动时,tipContainer的坐标改如何移动
		 * 需要接收唯一必须参数MouseEvent
		 */
		public var onToolTipMouseMove:Function = onStageMouseMove;
		/**
		 * tip显示的默认父级
		 */
		public var tipParent:DisplayObjectContainer = ELGManager.getInstance.mainShowContainer;
		/**
		 * 存放Tip文本段的
		 */
		private var tipHash:HashMap = new HashMap(true, TipContainerBase);
		/**
		 * 当前显示的TipContainer
		 */
		private var _currentTipContainer:TipContainerBase;
		
		private var stage:Stage = ELGManager.getInstance.mainShowContainer.stage;
		
		public function ToolTip()
		{
		
		}
		
		/**
		 * 不解释
		 */
		public static function get getInstance():ToolTip
		{
			return Singleton.getInstanceOrCreate(ToolTip);
		}
		
		/**
		 * 获取 当前显示的TipContainer
		 */
		public function get currentTipContainer():TipContainerBase
		{
			return _currentTipContainer;
		}
		
		/**
		 * 为可交互对象添加ToolTip
		 * @param	target
		 * @param	tipContainer
		 */
		public function addToolTip(target:InteractiveObject, tipContainer:TipContainerBase):void
		{
			tipHash.add(target, tipContainer);
			target.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOver, false, 0, true);
			target.addEventListener(MouseEvent.ROLL_OUT, onMouseRollOut, false, 0, true);
		}
		
		/**
		 * 为可交互对象删除ToolTip
		 * @param	target
		 * @param	tipContainer
		 */
		public function removeToolTip(target:InteractiveObject):void
		{
			tipHash.reduce(target);
			target.removeEventListener(MouseEvent.ROLL_OVER, onMouseRollOver);
			target.removeEventListener(MouseEvent.ROLL_OUT, onMouseRollOut);
		}
		
		/**
		 * 判断对象是否有ToolTip
		 * @param	target
		 * @return	返回对象是否有ToolTip
		 */
		public function hasToolTip(target:InteractiveObject):Boolean
		{
			return tipHash.has(target);
		}
		
		/**
		 * 获取TipContainerBase对象
		 * @param	target
		 * @return
		 */
		public function getToolTip(target:InteractiveObject):TipContainerBase
		{
			return tipHash.get(target);
		}
		
		/**
		 * 销毁
		 */
		public function dispose():void
		{
			Singleton.disposeSome(ToolTip);
			tipHash.eachKey(removeToolTip);
			tipHash.reputHash(true);
		}
		
		//-------------Event Handler------------------------
		/**
		 * 目标鼠标滑过时触发
		 * @param	e
		 */
		private function onMouseRollOver(e:MouseEvent):void
		{
			_currentTipContainer = tipHash.get(e.currentTarget);
			var disEvent:ToolTipEvent = new ToolTipEvent(ToolTipEvent.ON_TOOLTIP_OPEN, InteractiveObject(e.currentTarget), true);
			dispatchEvent(disEvent);
			if (disEvent.isDefaultPrevented())
			{
				return;
			}
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, _currentTipContainer.useOwnPosition ? _currentTipContainer.ownPositionOnMouseMove : onToolTipMouseMove);
			stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE, false, false, stage.mouseX, stage.mouseY));
			transformEffect.show(_currentTipContainer, tipParent);
		}
		
		/**
		 * 目标鼠标滑出时触发
		 * @param	e
		 */
		private function onMouseRollOut(e:MouseEvent):void
		{
			if (_currentTipContainer == null)
				return;
			var disEvent:ToolTipEvent = new ToolTipEvent(ToolTipEvent.ON_TOOLTIP_CLOSE, InteractiveObject(e.currentTarget), true);
			dispatchEvent(disEvent);
			if (disEvent.isDefaultPrevented())
			{
				_currentTipContainer = null;
				return;
			}
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, _currentTipContainer.useOwnPosition ? _currentTipContainer.ownPositionOnMouseMove : onToolTipMouseMove);
			transformEffect.close(_currentTipContainer);
			_currentTipContainer = null;
		}
		
		/**
		 * stage侦听到鼠标移动时触发
		 * @param	e
		 */
		private function onStageMouseMove(e:MouseEvent):void
		{
			if (_currentTipContainer.parent == null) return;
			var point:Point = _currentTipContainer.parent.globalToLocal(new Point());
			_currentTipContainer.x = e.stageX + point.x + 20;
			_currentTipContainer.y = e.stageY + point.y + 20;
			
			if (_currentTipContainer.x + _currentTipContainer.width > stage.stageWidth)
			{
				_currentTipContainer.x = stage.stageWidth - _currentTipContainer.width;
			}
			if (_currentTipContainer.y + _currentTipContainer.height > stage.stageHeight)
			{
				_currentTipContainer.y = stage.stageHeight - _currentTipContainer.height;
			}
			e.updateAfterEvent();
		}
	}
}