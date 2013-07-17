package Elegant.display
{
	import com.greensock.TweenNano;
	import Elegant.baseCore.TipContainerBase;
	import Elegant.ELGManager;
	import Elegant.utils.ToolTip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	/**
	 * 直接继承自sprite
	 * 为容器类的父类
	 * @author 浅唱
	 */
	public class Container extends Sprite
	{
		/**
		 * 标示,供记录使用
		 **/
		public var marked:String;
		/**
		 * 通过直接设置Container.toolTip来增加的Tooltip的默认效果
		 * 用静态的话方便,但是不能每个container用不同的效果
		 * 不用静态的话...换效果就是麻烦点...纠结
		 */
		public var tipContainer:Class = TipContainerBase;
		/**
		 * 存放侦听类型与侦听器的数组
		 */
		protected var listenerArr:Array;
		/**
		 * 是否在显示
		 */
		protected var _showing:Boolean;
		/**
		 * 是否可拖拽
		 */
		private var _dragEnabled:Boolean;
		private var dragXY:Point;
		
		/**
		 * 拖拽是否允许拖出屏幕
		 * 为true时,可以拖拽出屏幕范围,
		 * 为false时将被限定在屏幕范围内
		 */
		public var dragAllowOutScreen:Boolean = false;
		/**
		 * dragAllowOutScreen = false 时拖拽时定位用的
		 */
		private var parnetPoint:Point;
		/**
		 * 当鼠标点击时是否可以自动到父级最前
		 */
		private var _autoToTOP:Boolean;
		
		private var _toolTip:String;
		
		public var smoothing:Boolean = true;
		
		/**
		 * @param	group 加入到diposeGroup的名称
		 */
		public function Container(group:String = null)
		{
			super();
			listenerArr = [];
			ELGManager.getInstance.addToDispose(this, dispose, group);
		}
		
		/**
		 * 添加侦听器,默认引用类型为弱引用
		 * @inheritDoc
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):void
		{
			listenerArr ||= [];
			
			var l:int = listenerArr.length;
			for (var i:int = 0; i < l; i++) 
			{
				var item:Object = listenerArr[i];
				if(item.Type == type && item.Listener == listener && item.UseCapture == useCapture)
					break;
			}
			
			listenerArr[i] = {Type: type, Listener: listener, UseCapture: useCapture};
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		//--------getters / setters------------------------------------------------------
		/**
		 * 重写set x,使其smoothing为true时只接受整数
		 * @inheritDoc
		 */
		override public function set x(value:Number):void
		{
			super.x = smoothing ? int(value) : value;
		}
		
		/**
		 * 重写set y,使其smoothing为true时只接受整数
		 * @inheritDoc
		 */
		override public function set y(value:Number):void
		{
			super.y = smoothing ? int(value) : value;
		}
		
		/**
		 * 是否在显示中(不一定是指本身在显示列表中,亦可能是代表一种状态的开与关)
		 * 默认为是否在舞台中
		 */
		public function get showing():Boolean
		{
			_showing = (this.stage != null);
			return _showing;
		}
		
		/**
		 * 设置 / 获取 是否可被鼠标拖动
		 */
		public function get dragEnabled():Boolean
		{
			return _dragEnabled;
		}
		
		public function set dragEnabled(value:Boolean):void
		{
			_dragEnabled = value;
			if (value)
			{
				addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			}
			else
			{
				removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
				ELGManager.getInstance.mainShowContainer.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
				ELGManager.getInstance.mainShowContainer.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			}
		}
		
		/**
		 * 设置 / 获取 鼠标点击后是否自动到父级最前端
		 */
		public function get autoToTOP():Boolean
		{
			return _autoToTOP;
		}
		
		public function set autoToTOP(value:Boolean):void
		{
			_autoToTOP = value;
			if (value)
			{
				addEventListener(MouseEvent.MOUSE_DOWN, onAutoToTOP, false, 1);
			}
			else
			{
				removeEventListener(MouseEvent.MOUSE_DOWN, onAutoToTOP);
			}
		}
		
		/**
		 * 设置 / 获取 ToolTip文本
		 */
		public function get toolTip():String
		{
			return _toolTip;
		}
		
		public function set toolTip(value:String):void
		{
			_toolTip = value;
			if (_toolTip)
			{
				ToolTip.getInstance.addToolTip(this, new tipContainer(_toolTip));
			}
			else
			{
				ToolTip.getInstance.removeToolTip(this);
			}
		}
		
		//---------------Event Handler------------------------------------
		/**
		 * 自动到父级最前端
		 * @param	e
		 */
		private function onAutoToTOP(e:MouseEvent):void
		{
			parent.setChildIndex(this, parent.numChildren - 1);
		}
		
		private function onMouseDownHandler(e:MouseEvent):void
		{
			if (e.target != this)
				return;
			
			parnetPoint = parent.globalToLocal(new Point());
			dragXY = new Point(mouseX - parnetPoint.x, mouseY - parnetPoint.y);
			
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler, false, 0, true);
		}
		
		/**
		 * 当鼠标弹起时停止拖拽
		 * 有时候需要鼠标移出舞台时即可停止拖拽
		 * 可以自己添加如下代码,Event.MOUSE_LEAVE是不行滴
		 * addEventListener(MouseEvent.MOUSE_OUT, onMouseUpHandler);
		 * @param	e
		 */
		private function onMouseUpHandler(e:MouseEvent):void
		{
			if (!dragAllowOutScreen)
			{
				var toX:int = x;
				var toY:int = y;
				
				(x + width - parnetPoint.x > stage.stageWidth) && (toX = stage.stageWidth - width + parnetPoint.x);
				(y + height - parnetPoint.y > stage.stageHeight) && (toY = stage.stageHeight - height + parnetPoint.y);
				(x - parnetPoint.x < 0) && (toX = parnetPoint.x);
				(y - parnetPoint.y < 0) && (toY = parnetPoint.y);
				
				TweenNano.to(this, .3, { x:toX, y:toY } );
			}
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseUpHandler);
			dragXY = null;
		}
		
		/**
		 * 鼠标按下并移动时触发拖拽
		 * @param	e
		 */
		private function onMouseMoveHandler(e:MouseEvent):void
		{
			x = stage.mouseX - dragXY.x;
			y = stage.mouseY - dragXY.y;
			
			e.updateAfterEvent();
		}
		
		/**
		 * 删除时处理
		 * 卸载所有的侦听
		 */
		protected function dispose():void
		{
			/*	Nothing To Dispose except listeners	*/
			//自动删除侦听
			if (listenerArr != null)
			{
				for each (var item:Object in listenerArr) 
				{
					removeEventListener(item.Type, item.Listener, item.UseCapture);
				}
				
				listenerArr = null;
			}
			
			dragEnabled = false;
			_autoToTOP = false;
		}
	}
}