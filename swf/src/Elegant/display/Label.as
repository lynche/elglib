package Elegant.display 
{
	import Elegant.ELGManager;
	import Elegant.utils.Cloning;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * 文本
	 * @author 浅唱
	 */
	public class Label extends TextField
	{
		/**
		 * 标示ID,供记录使用
		 **/
		private var _itemID:int;
		/**
		 * 是否高亮显示
		 */
		private var _highLightMode:Boolean;
		/**
		 * 记录侦听的数组
		 */
		private var listenerArr:Array;
		/**
		 * 是否已调用过dispose方法
		 */
		protected var _disposed:Boolean;
		/**
		 * 存储text原本颜色
		 */
		public var realTextColor:uint;
		/**
		 * 鼠标经过时高亮的颜色
		 */
		public var highLightColor:uint;
		
		public function Label() 
		{
			super();
			defaultTextFormat = new TextFormat("宋体", 12);
			mouseWheelEnabled = false;
			ELGManager.getInstance.addToDispose(this, dispose);
		}
		/**
		 * 添加侦听器,默认引用类型为弱引用
		 * @inheritDoc
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):void
		{
			if (listenerArr == null) listenerArr = [];
			listenerArr.push( { Type:type, Listener:listener } );
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		/**
		 * 设置鼠标经过时高亮显示
		 * @param	mode
		 * @param	color
		 */
		public function setHighLight(mode:Boolean, color:uint):void
		{
			highLightMode = mode;
			highLightColor = color;
		}
		/**
		 * 将TextField转换为Label
		 * @param	tf
		 * @return 返回一个Label
		 */
		public static function toLabel(tf:TextField):Label
		{
			var label:Label = new Label();
			Cloning.cloneAll(tf, label, ["scaleZ", "rotationX", "rotationY", "rotationZ", "z"]);
			label.height += 2;
			if (tf.parent)
			{
				tf.parent.addChildAt(label, tf.parent.getChildIndex(tf));
				tf.parent.removeChild(tf);
			}
			return label;
		}
		//-----------------MouseEvent Handler--------------------------------------
		/**
		 * 鼠标经过时高亮显示文本
		 * @param	e
		 */
		private function onRollOver(e:MouseEvent):void 
		{
			realTextColor = textColor;
			textColor = highLightColor;
		}
		/**
		 * 鼠标移出时取消高亮显示文本
		 * @param	e
		 */
		private function onRollOut(e:MouseEvent):void 
		{
			textColor = realTextColor;
		}
		
		//--------getters / setters------------------------------------------------------
		/**
		 * @copy Elegant.interfaces.IHasLabel#get itemID()
		 */
		public function get itemID():int { return _itemID; }
		/**
		 * @copy Elegant.interfaces.IHasLabel#set itemID
		 */
		public function set itemID(value:int):void 
		{
			_itemID = value;
		}
		/**
		 * @copy Elegant.interfaces.IHasLabel#get label()
		 */
		public function get label():TextField { return this; }
		
		/**
		 * 重写set x,使其只接受整数
		 * @inheritDoc
		 */
		override public function set x(value:Number):void 
		{
			super.x = value >> 0;
		}
		/**
		 * 重写set y,使其只接受整数
		 * @inheritDoc
		 */
		override public function set y(value:Number):void 
		{
			super.y = value >> 0;
		}
		
		/**
		 * 获取鼠标经过时是否高亮显示,默认为<code>false</code>
		 */
		public function get highLightMode():Boolean { return _highLightMode; }
		/**
		 * 设置鼠标经过时是否高亮显示,默认为<code>false</code>
		 */
		public function set highLightMode(value:Boolean):void 
		{
			_highLightMode = value;
			if (_highLightMode)
			{
				this.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
				this.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			} else {
				this.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
				this.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			}
		}
		/**
		 * 是否调用过dispose方法
		 */
		public function get disposed():Boolean 
		{
			return _disposed;
		}
		
		/**
		 * @return	返回一个新的Label
		 */
		public function clone():Label
		{
			var lb:Label = new Label();
			Cloning.cloneAll(this, lb, ["scaleZ", "rotationX", "rotationY", "rotationZ", "z"]);
			lb.height += 2;
			return lb;
		}
		/**
		 * 销毁
		 */
		private function dispose():void
		{
			if (_disposed) return;
			
			//自动删除侦听
			if (listenerArr != null)
			{
				for (var i:int = 0; i < listenerArr.length; i += 1)
				{
					this.removeEventListener(listenerArr[i].Type, listenerArr[i].Listener);
				}
				this.listenerArr = null;
			}
			_disposed = true;
		}
	}
}