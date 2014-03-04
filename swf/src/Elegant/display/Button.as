package Elegant.display
{
	import Elegant.config.ELGFla;
	import Elegant.ELGManager;
	import Elegant.utils.Cloning;
	import Elegant.utils.Filter;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * @eventType flash.events.MouseEvent.CLICK 点击按钮时
	 */
	[Event(name="click",type="flash.events.MouseEvent")]
	/**
	 * 按钮
	 * @author 浅唱
	 */
	public class Button extends FLASkinContainer
	{
		ELGFla static const className:String = "Button";
		/**
		 * @private	各位观众你们是不需要知道这个滴
		 */
		ELGFla static const BUTTON_DOWN_STATE:String = "DIS_Btn_down";
		/**
		 * @private	各位观众你们是不需要知道这个滴
		 */
		ELGFla static const BUTTON_OVER_STATE:String = "DIS_Btn_over";
		/**
		 * @private	各位观众你们是不需要知道这个滴
		 */
		ELGFla static const BUTTON_UP_STATE:String = "DIS_Btn_up";
		/**
		 * @private	各位观众你们是不需要知道这个滴
		 */
		ELGFla static const TXT_LABEL:String = "TXF_Btn_Label";
		
		protected var _downState:DisplayObject;
		protected var _overState:DisplayObject;
		protected var _upState:DisplayObject;
		protected var _label:TextField;
		
		protected var _enabled:Boolean;
		protected var _lock:Boolean;
		public var itemID:int;
		
		public function Button(autoConverUI:Boolean=true)
		{
			super(autoConverUI);
			buttonMode = true;
			useHandCursor = true;
			mouseChildren = false;
			enabled = true;
			_lock = false;
		}
		
		/**
		 * @throws Error 必须有命名为命名规则的元件
		 * @inheritDoc
		 */
		override public function converUI():void
		{
			_upState = getChildByName(Button.ELGFla::BUTTON_UP_STATE);
			if(_upState == null)
				throw Error("必须有命名为" + Button.ELGFla::BUTTON_UP_STATE + "的元件");
			
			_downState = getChildByName(Button.ELGFla::BUTTON_DOWN_STATE);
			_overState = getChildByName(Button.ELGFla::BUTTON_OVER_STATE);
			label = TextField(getChildByName(Button.ELGFla::TXT_LABEL));
			
			if (_overState) _overState.visible = false;
			if (_downState) _downState.visible = false;
		}
		
		/**
		 * 返回新的button
		 * @param	_upSatet
		 * @param	_overState
		 * @param	_downState
		 * @param	_downState
		 */
		public static function toButton(_upSatet:DisplayObject, _overState:DisplayObject = null, _downState:DisplayObject = null, _label:TextField = null):Button
		{
			var bt:Button = new Button(false);
			bt.upState = _upSatet;
			bt.overState = _overState;
			bt.downState = _downState;
			bt.label = _label;
			return bt;
		}
		
		/**
		 * 从含有命名规则的容器中返回新的Button
		 * @param	container
		 * @return
		 */
		public static function toButtonFromMC(container:DisplayObjectContainer):Button
		{
			var btn:Button = new Button(false);
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
		//--------MouseEvent handlers------------------------------------------------------
		/**
		 * 鼠标弹起
		 * @param	e
		 */
		protected function onMouseUpHandler(e:MouseEvent):void
		{
			if (_lock) return;
			if(_downState && contains(_downState))
			{
				_downState.visible = false;
			}
			if (_upState == null) return;
			
			_upState.visible = true
			addEventListener(MouseEvent.ROLL_OUT, onRollOutHandler);
			addEventListener(MouseEvent.ROLL_OVER, onRollOverHandler);
			ELGManager.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
		}
		
		/**
		 * 鼠标按下
		 * @param	e
		 */
		protected function onMouseDownHandler(e:MouseEvent):void
		{
			if (_lock) return;
			if(_overState && contains(_overState))
				_overState.visible = false;
			if (contains(_upState))
				_upState.visible = false;
			if(_downState)
			{
				_downState.visible = true;
				if (_downState is MovieClip)
					MovieClip(_downState).gotoAndPlay(1);
			}
				
			removeEventListener(MouseEvent.ROLL_OUT, onRollOutHandler);
			removeEventListener(MouseEvent.ROLL_OVER, onRollOverHandler);
			if (stage) stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
		}
		
		/**
		 * 鼠标滑过
		 * @param	e
		 */
		protected function onRollOverHandler(e:MouseEvent):void
		{
			if(_overState)
			{
				_overState.visible = true;
				if(_downState && contains(_downState))
					_downState.visible = false;
				if(contains(_upState))
					_upState.visible = false;
				if (_overState is MovieClip)
					MovieClip(_overState).gotoAndPlay(1);
			}
		}
		
		/**
		 * 鼠标滑出
		 * @param	e
		 */
		protected function onRollOutHandler(e:MouseEvent):void
		{
			_upState.visible = true;
			if(_overState && contains(_overState))
				_overState.visible = false;
			if(_downState && contains(_downState))
				_downState.visible = false;
			if (_upState is MovieClip)
					MovieClip(_upState).gotoAndPlay(1);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function dispose():void
		{
			if (stage) stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			super.dispose();
			_upState = null;
			_downState = null;
			_overState = null;
		}
		
		//--------getters / setters------------------------------------------------------
		/**
		 * 指定一个用作按钮“按下”状态的可视对象的显示对象
		 */
		public function get downState():DisplayObject
		{
			return _downState;
		}
		
		public function set downState(value:DisplayObject):void
		{
			if (_downState && contains(_downState))
			{
				removeChild(_downState);
			}
			
			_downState = value;
			_downState.visible = false;
			addChildAt(_downState, 0);
		}
		
		/**
		 * 指定一个用作按钮“滑过”状态的可视对象的显示对象
		 */
		public function get overState():DisplayObject
		{
			return _overState;
		}
		
		public function set overState(value:DisplayObject):void
		{
			if (_overState && contains(_overState))
			{
				removeChild(_overState);
			}
			
			_overState = value;
			_overState.visible = false;
			addChildAt(_overState, 0);
		}
		
		/**
		 * 指定一个用作按钮“释放”状态的可视对象的显示对象
		 */
		public function get upState():DisplayObject
		{
			return _upState;
		}
		
		public function set upState(value:DisplayObject):void
		{
			var index:int;
			if (_upState && contains(_upState))
			{
				index = getChildIndex(_upState);
				removeChild(_upState);
			}
			if (value == null)
			{
				_upState = null;
				return;
			}
			
			_upState = value;
			addChildAt(_upState, index);
		}
		
		/**
		 * 是否可用
		 */
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			if(value)
			{
				Filter.unGray(this);
				addEventListener(MouseEvent.ROLL_OVER, onRollOverHandler);
				addEventListener(MouseEvent.ROLL_OUT, onRollOutHandler);
				addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			}
			else
			{
				Filter.setToGray(this);
				onMouseUpHandler(null);
				removeEventListener(MouseEvent.ROLL_OVER, onRollOverHandler);
				removeEventListener(MouseEvent.ROLL_OUT, onRollOutHandler);
				removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			}
		}
		
		/**
		 * 锁定,如果为<code>true</code>,按钮将不执行鼠标按下以及弹起函数
		 */
		public function get lock():Boolean 
		{
			return _lock;
		}
		
		public function set lock(value:Boolean):void 
		{
			_lock = value;
		}
		
		//--------INTERFACE Elegant.interfaces.IHasLabel------------------------------------------------
		/**
		 * @copy Elegant.interfaces.IHasLabel#text
		 */
		public function get text():String 
		{
			return _label.text;
		}
		
		public function set text(value:String):void 
		{
			_label.text = value;
		}
		
		/**
		 * @copy Elegant.interfaces.IHasLabel#label
		 */
		public function get label():TextField
		{
			return _label;
		}
		
		public function set label(tf:TextField):void
		{
			if (_label)
			{
				removeChild(_label);
			}
			if(tf)
			{
				tf.mouseEnabled = false;
				addChild(tf);
			}
			_label = tf;
		}
	}
}