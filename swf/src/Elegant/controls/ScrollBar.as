package Elegant.controls
{
	import Elegant.config.ELGFla;
	import Elegant.display.FLASkinContainer;
	import Elegant.display.Scale9Panel;
	import Elegant.ELGManager;
	import Elegant.interfaces.ITransformEffect;
	import Elegant.transformEffects.BasicTransformEffect;
	import Elegant.utils.Cloning;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	/**
	 * @eventType	flash.events.Event.SCROLL	当前滚动条滚动时触发
	 */
	[Event(name = "scroll", type = "flash.events.Event.SCROLL")]
	/**
	 * 滚动条
	 * @author 浅唱
	 * @version 1.0
	 */
	public class ScrollBar extends FLASkinContainer
	{
		ELGFla static const className:String = "ScrollBar";
		
		/**
		 * @private	各位观众你们是不需要知道这个滴
		 */
		ELGFla static const UP_BUTTON:String = "DIS_ScrollBar_Up";
		/**
		 * @private	各位观众你们是不需要知道这个滴
		 */
		ELGFla static const DOWN_BUTTON:String = "DIS_ScrollBar_Down";
		/**
		 * @private	各位观众你们是不需要知道这个滴
		 */
		ELGFla static const DRAG_BUTTON:String = "DIS_ScrollBar_Drag";
		/**
		 * @private	各位观众你们是不需要知道这个滴
		 */
		ELGFla static const DRAG_BG:String = "DIS_ScrollBar_Bg";
		
		/**
		 * 横向
		 */
		public static const HORIZONTAL:String = "horizontal";
		/**
		 * 纵向
		 */
		public static const VERTICAL:String = "vertical";
		
		/**
		 * 
		 */
		public static var defaultStep:int = 3;
		
		/**
		 * 向上滚动按钮
		 */
		protected var _upButton:DisplayObject;
		/**
		 * 向下滚动按钮
		 */
		protected var _downButton:DisplayObject;
		/**
		 * 滚动按钮
		 */
		protected var _dragButton:DisplayObject;
		/**
		 * 滚动背景
		 */
		protected var _dragBg:Scale9Panel;
		
		/**
		 * 滚动条的目标对象
		 */
		protected var _target:DisplayObject;
		protected var updataAfterMouseMove:Boolean = true;
		/**
		 * 目标对象开始的位置
		 */
		private var _targetPoint:Point;
		/**
		 * 滚动条的方向
		 */
		protected var _direction:String;
		/**
		 * 切换效果
		 */
		public var transformEffect:ITransformEffect;
		/**
		 * 
		 */
		public var step:int = defaultStep;
		/**
		 * 用于enterFrame事件中,表明<code>true</code>时向上
		 */
		private var upOrDown:Boolean;
		/**
		 * 遮罩的范围
		 */
		private var _maskSize:int;
		/**
		 * 如果<code>autoHide</code>为<code>true</code>,则会在<code>maskSize</code>大于等于目标对象显示区域时隐藏滚动条
		 */
		private var _autoHide:Boolean;
		/**
		 * 是否为文本模式
		 */
		private var _textMode:Boolean;
		/**
		 * 鼠标点击拖拽按钮后处于的位置
		 */
		private var rePosi:Point;
		/**
		 * 是否在拖拽中,从用户点击拖拽按钮到松开之间返回true
		 */
		private var _scrolling:Boolean;
		/**
		 * 鼠标滚轮的目标对象,默认等于target,每次设置target后也会被设置为target
		 */
		private var _wheelTarget:DisplayObject;
		private var _endPosition:Number;
		private var shape:Shape;
		
		/**
		 * @eventType flash.events.Event.CHANGE 当拖拽被改变时触发
		 */
		[Event(name = "change", type = "flash.events.Event")]
		
		/**
		 * 
		 * @param	autoConverUI
		 */
		public function ScrollBar(autoConverUI:Boolean=true)
		{
			_autoHide = true;
			_direction = VERTICAL;
			super(autoConverUI);
			_maskSize = height;
			transformEffect = BasicTransformEffect.getInstance;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function converUI():void
		{
			_upButton = getChildByName(ELGFla::UP_BUTTON);
			_downButton = getChildByName(ELGFla::DOWN_BUTTON);
			_dragButton = getChildByName(ELGFla::DRAG_BUTTON);
			_dragBg = new Scale9Panel(getChildByName(ELGFla::DRAG_BG));
			setChildIndex(_dragBg, 0);
			
			if(_upButton == null)
			{
				throw Error("缺少命名规则的元件upButton 暂时4个按钮都需要 以后会改成至少需要滑块或滑动背景");
			}
			if(_downButton == null)
			{
				throw Error("缺少命名规则的元件downButton 暂时4个按钮都需要 以后会改成至少需要滑块或滑动背景");
			}
			if(_dragButton == null)
			{
				throw Error("缺少命名规则的元件dragButton 暂时4个按钮都需要 以后会改成至少需要滑块或滑动背景");
			}
			if(_dragBg == null)
			{
				throw Error("缺少命名规则的元件dragBg 暂时4个按钮都需要 以后会改成至少需要滑块或滑动背景");
			}
			_upButton.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler, false, 0, true);
			_downButton.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler, false, 0, true);
			_dragButton.addEventListener(MouseEvent.MOUSE_DOWN, onStartDrag, false, 0, true);
			_dragBg.addEventListener(MouseEvent.CLICK, onBgClick, false, 0, true);
			
			height = height;
			
			if (_upButton.hasOwnProperty("buttonMode"))_upButton["buttonMode"] = true;
			if (_downButton.hasOwnProperty("buttonMode"))_downButton["buttonMode"] = true;
			
			if(_direction == VERTICAL)
				_dragButton.y = _dragBg.y;
			else
				_dragButton.x = _dragBg.x;
		}
		
		//--------Some Fuctions--------------------------`--------------------------------
		/**
		 * 刷新target的位置
		 */
		public function updataPosition():void
		{
			if(_target == null)
				return;
			
			if(_direction == VERTICAL)
			{
				if(_textMode)
				{
					//endPosition = Math.max(_target["maxScrollV"] * ratio, 1);
					TextField(_target).scrollV = Math.max(_target["maxScrollV"] * ratio, 1);
				}
				else
				{
					endPosition = _targetPoint.y - (_target.height - _maskSize) * ratio;
				}
			}
			else
			{
				endPosition = _targetPoint.x - (_target.width - _maskSize) * ratio;
			}
		}
		
		/**
		 * 计算是否会隐藏滚动条
		 * 如果<code>autoHide</code>为<code>true</code>,则会在<code>maskSize</code>大于等于目标对象显示区域时隐藏滚动条
		 */
		public function updataAutoHide():void
		{
			if(_autoHide && _target != null)
			{
				if(_direction == VERTICAL)
				{
					//纵向时
					visible = _textMode ? _target["maxScrollV"] > 1 : (_maskSize < _target.height);
				}
				else
				{
					//横向时
					visible = (_maskSize < _target.width);
				}
			}
			else
			{
				visible = true;
			}
		}
		/**
		 * 当鼠标按下后,某些情况下会从舞台上移除scrollBar
		 * 此时会导致scrollBar找不到stage而报错
		 * 故移除前应先调用此方法
		 * ----已经没必要调用此方法了= =
		 */
		public function stopFollow():void
		{
			onStageUp(null);
		}
		/**
		 * @inheritDoc
		 */
		override protected function dispose():void
		{
			super.dispose();
			wheelTarget = null;
			_upButton.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			_downButton.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			_dragButton.removeEventListener(MouseEvent.MOUSE_DOWN, onStartDrag);
			_dragBg.removeEventListener(MouseEvent.CLICK, onBgClick);
			if(ELGManager.getInstance.mainShowContainer && ELGManager.getInstance.mainShowContainer.stage)
				ELGManager.getInstance.mainShowContainer.stage.removeEventListener(MouseEvent.MOUSE_UP, onStageUp);
		}
		
		//--------Event Handlers---------------------------------------------------------
		/**
		 * 向上 / 向下按钮被按下时触发
		 * @param	e
		 */
		private function onMouseDownHandler(e:MouseEvent):void
		{
			upOrDown = (e.currentTarget == _upButton);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageUp, false, 0, true);
		}
		
		/**
		 * 拖拽按钮被按下时触发
		 * @param	e
		 */
		protected function onStartDrag(e:MouseEvent):void
		{
			_scrolling = true;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageUp, false, 0, true);
			rePosi = new Point(_dragButton.mouseX, _dragButton.mouseY);
		}
		
		/**
		 * 场景监听到鼠标弹起事件时触发
		 * @param	e
		 */
		protected function onStageUp(e:MouseEvent):void
		{
			_scrolling = false;
			ELGManager.getInstance.mainShowContainer.stage.removeEventListener(MouseEvent.MOUSE_UP, onStageUp);
			ELGManager.getInstance.mainShowContainer.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			rePosi = null;
		}
		
		/**
		 * 背景被点击时触发
		 * @param	e
		 */
		protected function onBgClick(e:MouseEvent):void
		{
			if(_direction == VERTICAL)
			{
				//纵向
				var vy:int = Math.min(_dragBg.height + _dragBg.y - _dragButton.height, mouseY);
				transformEffect.tween(_dragButton, .3, { y:vy, onUpdate:updataPosition } );
			}
			else
			{
				//横向
				var vx:int = Math.min(_dragBg.width + _dragBg.x - _dragButton.width, mouseX);
				transformEffect.tween(_dragButton, .3, { x:vx, onUpdate:updataPosition } );
			}
		}
		
		/**
		 * 用于鼠标点击drapButton后侦听移动
		 * @param	e
		 */
		protected function onMouseMoveHandler(e:MouseEvent):void
		{
			if(_direction == HORIZONTAL)
			{
				//横向
				_dragButton.x = mouseX - rePosi.x;
				if(_dragButton.x < _dragBg.x)
					_dragButton.x = _dragBg.x;
				if((_dragButton.x + _dragButton.width) > (_dragBg.x + _dragBg.width))
					_dragButton.x = (_dragBg.x + _dragBg.width - _dragButton.width);
			}
			else
			{
				//纵向
				_dragButton.y = mouseY - rePosi.y;
				if(_dragButton.y < _dragBg.y)
					_dragButton.y = _dragBg.y;
				if((_dragButton.y + _dragButton.height) > (_dragBg.y + _dragBg.height))
					_dragButton.y = (_dragBg.y + _dragBg.height - _dragButton.height);
			}
			updataAfterMouseMove && updataPosition();
			dispatchEvent(new Event(Event.SCROLL));
			e.updateAfterEvent();
		}
		
		/**
		 * target对象鼠标滚轮侦听
		 * @param	e
		 */
		private function onTargetWheel(e:MouseEvent):void 
		{
			if (_textMode)
			{
				ratio = e.delta < 0 ? (TextField(_target).bottomScrollV  / TextField(_target).maxScrollV) : ((2 * TextField(_target).scrollV - TextField(_target).bottomScrollV) / TextField(_target).maxScrollV);
			} else {
				e.delta > 0 ? ratio -= 0.1 : ratio += 0.1;
			}
		}
		
		/**
		 * 持续修改ratio时使用
		 * @param	e
		 */
		private function onEnterFrame(e:Event):void
		{
			if(upOrDown)
				ratio -= 0.05;
			else
				ratio += 0.05;
			
			if(ratio >= 1 || ratio <= 0)
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFramePosition(e:Event):void 
		{
			if(_direction == VERTICAL)
			{
				if(_textMode)
				{
					TextField(_target).scrollV += (_endPosition - TextField(_target).scrollV) / step;
					if (TextField(_target).scrollV == _endPosition)
					{
						shape.removeEventListener(Event.ENTER_FRAME, onEnterFramePosition);
					}
				} else {
					_target.y += (_endPosition - _target.y) / step;
					if (Math.abs(_endPosition - _target.y) < 1)
					{
						shape.removeEventListener(Event.ENTER_FRAME, onEnterFramePosition);
					}
				} 
			} else {
				_target.x += (_endPosition - _target.x) / step;
				if (Math.abs(_endPosition - _target.x) < 1)
				{
					shape.removeEventListener(Event.ENTER_FRAME, onEnterFramePosition);
				}
			}
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		//--------getters / setters------------------------------------------------------
		/**
		 * 设置 / 获取 向上按钮
		 */
		public function get upButton():DisplayObject
		{
			return _upButton;
		}
		
		public function set upButton(value:DisplayObject):void
		{
			if(_upButton)
			{
				removeChild(_upButton);
				_upButton.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
				Cloning.cloneSomeVars(_upButton, value, ["x", "y"]);
			}
			
			_upButton = value;
			_upButton.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler, false, 0, true);
			addChild(_upButton);
		}
		
		/**
		 * 设置 / 获取 向下按钮
		 */
		public function get downButton():DisplayObject
		{
			return _downButton;
		}
		
		public function set downButton(value:DisplayObject):void
		{
			if(_downButton)
			{
				removeChild(_downButton);
				_downButton.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
				Cloning.cloneSomeVars(_downButton, value, ["x", "y"]);
			}
			
			_downButton = value;
			_downButton.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler, false, 0, true);
			addChild(_downButton);
		}
		
		/**
		 * 设置 / 获取 滑动按钮
		 */
		public function get dragButton():DisplayObject
		{
			return _dragButton;
		}
		
		public function set dragButton(value:DisplayObject):void
		{
			if(_dragButton)
			{
				removeChild(_dragButton);
				_dragButton.removeEventListener(MouseEvent.MOUSE_DOWN, onStartDrag);
				Cloning.cloneSomeVars(_dragButton, value, ["x", "y"]);
			}
			
			_dragButton = value;
			_dragButton.addEventListener(MouseEvent.MOUSE_DOWN, onStartDrag, false, 0, true);
			addChild(_dragButton);
		}
		
		/**
		 * 设置 / 获取 滑动背景
		 */
		public function get dragBg():DisplayObject
		{
			return _dragBg;
		}
		
		/**
		 * 设置 / 获取 滑动背景
		 */
		public function set dragBg(value:DisplayObject):void
		{
			value = Scale9Panel.toScale9Panel(value);
			if(_dragBg)
			{
				removeChild(_dragBg);
				_dragBg.removeEventListener(MouseEvent.CLICK, onBgClick);
				Cloning.cloneSomeVars(_dragBg, value, ["x", "y", "width", "height"]);
			}
			
			_dragBg = Scale9Panel(value);
			_dragBg.addEventListener(MouseEvent.CLICK, onBgClick, false, 0, true);
			addChildAt(_dragBg, 0); 
		}
		
		/**
		 * 设置 / 获取 滚动条的目标对象
		 */
		public function get target():DisplayObject
		{
			return _target;
		}
		
		public function set target(value:DisplayObject):void
		{
			if(_target)
			{
				_target.x = _targetPoint.x;
				_target.y = _targetPoint.y;
			}
			
			_target = value;
			
			if (value == null) 
			{
				visible = false;
				return;
			}
			_targetPoint = new Point(value.x, value.y);
			
			if (_target is TextField)
			{
				_textMode = true;
				_endPosition = TextField(value).scrollV;
				TextField(_target).mouseWheelEnabled = false;
			} else _textMode = false;
			
			if(_target.mask)
			{
				//纵向
				if(_direction == VERTICAL)
				{
					maskSize = _target.mask.height;
					_endPosition = (_textMode ? TextField(value).scrollV : value.y);
				}
				//横向
				else
				{
					maskSize = _target.mask.width;
					_endPosition = value.x;
				}
			}
			else
			{
				maskSize = _maskSize;
			}
			wheelTarget = _target;
			
			updataAutoHide();
			updataPosition();
		}
		
		/**
		 * 设置 / 获取 滚动条的方向
		 */
		public function get direction():String
		{
			return _direction;
		}
		
		public function set direction(value:String):void
		{
			if(value != HORIZONTAL && value != VERTICAL)
				throw ArgumentError("错误的参数");
			
			if(_direction != value)
			{
				var b:Boolean = (_direction == HORIZONTAL);
				_direction = value;
				
				var temp:int
				if(b) //横向变纵向
				{
					temp = _dragBg.width;
					_dragBg.width = _dragBg.height;
					_dragBg.height = temp;
					
					height = width;
				}
				else
				{ //纵向变横向
					temp = _dragBg.height;
					_dragBg.height = _dragBg.width;
					_dragBg.width = temp;
					
					width = height;
				}
			}
		}
		
		/**
		 * 设置 / 获取 滚动条当前所在比例
		 * ratio是0-1的小数
		 */
		public function get ratio():Number
		{
			if(_direction == HORIZONTAL)
			{
				//横向
				return (_dragButton.x - _dragBg.x) / (_dragBg.width - _dragButton.width);
			}
			else
			{
				//纵向
				return (_dragButton.y - _dragBg.y) / (_dragBg.height - _dragButton.height);
			}
		}
		
		public function set ratio(num:Number):void
		{
			if(num > 1)
				num = 1;
			if(num < 0)
				num = 0;
			
			if(_direction == HORIZONTAL)
			{
				//横向
				_dragButton.x = (_dragBg.width - _dragButton.width) * num + _dragBg.x;
			}
			else
			{
				//纵向
				_dragButton.y = (_dragBg.height - _dragButton.height) * num + _dragBg.y;
			}
			updataPosition();
		}
		/**
		 * 获取 滚动条最终所在比例
		 * ratio是0-1的小数
		 */
		public function get finalRatio():Number 
		{
			return ratio;
		}
		
		/**
		 * 遮罩的范围
		 */
		public function get maskSize():int
		{
			return _maskSize;
		}
		
		public function set maskSize(value:int):void
		{
			_maskSize = value;
			if(_target)
				autoHide = _autoHide;
		}
		
		/**
		 * 如果<code>autoHide</code>为<code>true</code>,则会在<code>maskSize</code>大于等于目标对象显示区域时隐藏滚动条
		 */
		public function get autoHide():Boolean
		{
			return _autoHide;
		}
		
		public function set autoHide(value:Boolean):void
		{
			_autoHide = value;
			updataAutoHide();
		}
		
		/**
		 * 重写设定高度
		 */
		override public function set width(value:Number):void
		{
			//横向时自动对位
			if(_direction == HORIZONTAL)
			{
				_dragBg.width = value - _upButton.width - _downButton.width;
				_upButton.x = _upButton.y = 0;
				_dragBg.y = 0;
				_dragBg.x = _upButton == null ? 0 : _upButton.width;
				_downButton.y = 0;
				_downButton.x = _dragBg.x + _dragBg.width;
				_dragButton.y = 0;
				if(_dragButton.x <= _dragBg.x)
					_dragButton.x = _dragBg.x;
			}
			else
				super.width = value;
		}
		
		/**
		 * 重写设定宽度
		 */
		override public function set height(value:Number):void
		{
			//纵向时自动对位
			if(_direction == VERTICAL)
			{
				_dragBg.height = value - _upButton.height - _downButton.height;
				_upButton.x = _upButton.y = 0;
				_dragBg.x = 0;
				_dragBg.y = _upButton == null ? 0 : _upButton.height;
				_downButton.x = 0;
				_downButton.y = _dragBg.y + _dragBg.height;
				_dragButton.x = 0;
				if(_dragButton.y <= _dragBg.y)
					_dragButton.y = _dragBg.y;
			}
			else
				super.height = value;
		}
		/**
		 * 是否在拖拽中,从用户点击拖拽按钮到松开之间返回true
		 */
		public function get scrolling():Boolean 
		{
			return _scrolling;
		}
		/**
		 * 鼠标滚轮的目标对象,默认等于target,每次设置target后也会被设置为target
		 */
		public function get wheelTarget():DisplayObject 
		{
			return _wheelTarget;
		}
		
		public function set wheelTarget(value:DisplayObject):void 
		{
			if (_wheelTarget)_wheelTarget.removeEventListener(MouseEvent.MOUSE_WHEEL, onTargetWheel);
			_wheelTarget = value;
			if (_wheelTarget)_wheelTarget.addEventListener(MouseEvent.MOUSE_WHEEL, onTargetWheel, false, 0, true);
		}
		
		public function get textMode():Boolean 
		{
			return _textMode;
		}
		
		public function set textMode(value:Boolean):void 
		{
			_textMode = value;
			updataAutoHide();
			updataPosition();
		}
		
		private function get endPosition():Number 
		{
			return _endPosition;
		}
		
		private function set endPosition(value:Number):void 
		{
			_endPosition = value;
			shape ||= new Shape();
			if (!shape.hasEventListener(Event.ENTER_FRAME))
				shape.addEventListener(Event.ENTER_FRAME, onEnterFramePosition, false, 0, true);
		}
	}
}