package Elegant.controls
{
	import Elegant.config.ELGFla;
	import Elegant.display.FLASkinContainer;
	import Elegant.display.List;
	import Elegant.display.Scale9Panel;
	import Elegant.ELGManager;
	import Elegant.events.ListEvent;
	import Elegant.interfaces.IConversion;
	import Elegant.interfaces.ITransformEffect;
	import Elegant.transformEffects.BasicTransformEffect;
	import Elegant.utils.ArrayUtil;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	/**
	 * @eventType	Elegant.events.ListEvent.ITEM_SELECT	当前选中更换时触发
	 */
	[Event(name="itemSelect",type="Elegant.events.ListEvent")]
	/**
	 * 下拉菜单
	 * @version 1.0
	 * @author 浅唱
	 */
	public class Combobox extends FLASkinContainer implements IConversion
	{
		/**
		 * 类名称, 获取命名规则时需要
		 */
		ELGFla static const className:String = "Combobox";
		/**
		 * @private	各位观众你们是不需要知道这个滴
		 */
		ELGFla static const PULL_BT_NAME:String = "SIP_Pull_Bt";
		/**
		 * @private	各位观众你们是不需要知道这个滴
		 */
		ELGFla static const PULL_BG_NAME:String = "DIS_Pull_Bg";
		/**
		 * @private	各位观众你们是不需要知道这个滴
		 */
		ELGFla static const LABEL_NAME:String = "TXF_Label";
		/**
		 * @private	各位观众你们是不需要知道这个滴
		 */
		ELGFla static const LIST_NAME:String = "LIST_list";
		
		protected var pullBt:DisplayObject;
		protected var pullBg:Scale9Panel;
		protected var resultTxt:TextField;
		protected var itemList:List;
		
		protected var _onSelectID:int = -1;
		
		//pullBg与list的宽度差
		private var tempChaWidth:int;
		/**
		 * 在没有任何选项被选中之前文本中显示的文字
		 */
		protected var _defaultText:String = "";
		/**
		 * 切换效果
		 */
		public var transformEffect:ITransformEffect;
		
		/**
		 * list相对位移
		 */
		private var _listOffset:Point = new Point();
		
		public function Combobox(autoConverUI:Boolean=true)
		{
			super(autoConverUI);
			transformEffect = BasicTransformEffect.getInstance;
		}
		
		/**
		 * @throws Error 必须有命名为命名规则的元件
		 * @inheritDoc
		 */
		override public function converUI():void
		{
			pullBt = this.getChildByName(Combobox.ELGFla::PULL_BT_NAME);
			pullBg = Scale9Panel.toScale9Panel(this.getChildByName(Combobox.ELGFla::PULL_BG_NAME));
			
			if(pullBg == null)
				throw new Error("必须有命名为 " + Combobox.ELGFla::PULL_BG_NAME + " 的元件");
			
			resultTxt = TextField(this.getChildByName(Combobox.ELGFla::LABEL_NAME));
			resultTxt.mouseEnabled = false;
			resultTxt.mouseWheelEnabled = false;
			setChildIndex(resultTxt, numChildren - 1);
			
			itemList = List(this.getChildByName(Combobox.ELGFla::LIST_NAME));
			itemList.addEventListener(ListEvent.ITEM_SELECT, onListSelect);
			tempChaWidth = pullBg.width - itemList.width;
			width = pullBg.width;
			
			removeChild(itemList);
			
			pullBg.addEventListener(MouseEvent.CLICK, onCLick);
			
			pullBg.x = pullBg.y = 0;
			if(pullBt)
			{
				pullBt.addEventListener(MouseEvent.CLICK, onCLick);
				//pullBt.x = pullBg.width - pullBt.width;
				//pullBt.y = Math.abs(pullBg.height - pullBt.height) / 2;
			}
		}
		
		/**
		 * 设置是否高亮显示文本,默认为<code>false</code>
		 * @param	highLightMode
		 * @param	highLightColor
		 */
		public function setHighLight(highLightMode:Boolean, highLightColor:uint=0):void
		{
			itemList.setHighLight(highLightMode, highLightColor);
		}
		
		/**
		 * @copy Elegant.display.List#add()
		 * @see Elegant.display.List#add()
		 */
		public function add(obj:Object, reflush:Boolean=true):void
		{
			itemList.add(obj, reflush);
		}
		
		/**
		 * 从列表中删除某元素
		 * @param	obj
		 * @param	reflush	是否刷新列表
		 * @see Elegant.display.List#reduce()
		 */
		public function reduce(obj:Object, reflush:Boolean):Object
		{
			return itemList.reduce(obj, reflush);
		}
		
		/**
		 * 取消选择并显示默认的文本
		 */
		public function showDefaultText():void
		{
			_onSelectID = -1;
			resultTxt.text = _defaultText;
		}
		
		//--------------Event Handler--------------------------------------
		/**
		 * 侦听List发送的事件,并进行处理
		 * @param	e
		 */
		private function onListSelect(e:ListEvent):void
		{
			e.stopImmediatePropagation();
			resultTxt.text = e.onSelectLabel;
			_onSelectID = e.onSelectID;
			onCLick(null);
			dispatchEvent(new ListEvent(ListEvent.ITEM_SELECT, e.onSelectID, e.onSelectLabel, e.listItem));
		}
		
		/**
		 * 显示或隐藏列表
		 * @param	e
		 */
		private function onCLick(e:MouseEvent):void
		{
			if(itemList.showing)
			{
				if(itemList.scrollBar)
				{
					if (itemList.scrollBar.scrolling) return;
					itemList.scrollBar.stopFollow();
				}
				transformEffect.close(itemList);
				itemList.removeEventListener(MouseEvent.ROLL_OUT, onCLick);
			}
			else
			{
				transformEffect.show(itemList, this);
				setChildIndex(itemList, 0);
				itemList.addEventListener(MouseEvent.ROLL_OUT, onCLick);
			}
		}
		
		//--------getters / setters------------------------------------------------------
		/**
		 * 列表文本的颜色
		 * @copy flash.display.TextField#textColor()
		 * @see flash.display.TextField#textColor()
		 */
		public function get itemTextColor():uint
		{
			return itemList.textColor;
		}
		
		public function set itemTextColor(value:uint):void
		{
			itemList.textColor = value;
		}
		
		/**
		 * 当前显示文本的颜色
		 * @copy flash.display.TextField#textColor()
		 * @see flash.display.TextField#textColor()
		 */
		public function get textColor():uint
		{
			return resultTxt.textColor;
		}
		
		public function set textColor(value:uint):void
		{
			resultTxt.textColor = value;
		}
		/**
		 * 获得list的引用
		 */
		public function get list():List
		{
			return itemList;
		}
		
		/**
		 * 列表在显示滚动条前最多显示条目
		 */
		public function get maxContent():int
		{
			return itemList.maxContent;
		}
		
		public function set maxContent(value:int):void
		{
			itemList.maxContent = value;
		}
		
		/**
		 * 在没有任何选项被选中之前文本中显示的文字
		 */
		public function set defaultText(value:String):void
		{
			_defaultText = (value == null ? "" : value);
			if(onSelectID == -1)
				resultTxt.text = _defaultText;
		}
		
		public function get defaultText():String
		{
			return _defaultText;
		}
		
		/**
		 * @return 返回当前被选中的项的文本
		 */
		public function get onSelectText():String
		{
			return resultTxt.text;
		}
		
		/**
		 * @return 返回当前被选中的项的ID
		 */
		public function get onSelectID():int
		{
			return _onSelectID;
		}
		
		public function set onSelectID(sid:int):void
		{
			if (_onSelectID == sid) return;
			var index:int = ArrayUtil.indexInArray(data, sid, "itemID");
			if (index == -1)
			{
				_onSelectID = -1;
				defaultText = _defaultText;
			} else {
				_onSelectID = sid;
				resultTxt.text = data[index].text;
			}
			dispatchEvent(new ListEvent(ListEvent.ITEM_SELECT, _onSelectID, resultTxt.text, null));
		}
		
		/**
		 * @copy Elegant.display.List#data()
		 * @see Elegant.display.List#data()
		 */
		public function get data():Array
		{
			return itemList.data;
		}
		
		public function set data(value:Array):void
		{
			itemList.data = value;
			//pullBg.width = itemList.width;
			//if(pullBt)
				//pullBt.x = pullBg.width - pullBt.width;
		}
		
		/**
		 * 重写改变宽度,改变某些元件的宽度
		 * fuck this function 为啥改变后就不居中了呢......
		 * @inheritDoc
		 */
		override public function set width(value:Number):void
		{
			if(pullBg.width == value)
				return;
			
			itemList.width = value - tempChaWidth;
			pullBg.width = value;
			resultTxt.width = value;
			if(pullBt)
			{
				pullBt.x = pullBg.width - pullBt.width;
				resultTxt.width -= pullBt.width;
			}
		}
		
		/**
		 * 重写改变高度时,改变某些元件的高度
		 * @inheritDoc
		 */
		override public function set height(value:Number):void
		{
			pullBg.height = value;
		}
		
		/**
		 * @copy Elegant.display.List#space();
		 */
		public function get space():int
		{
			return itemList.space;
		}
		
		/**
		 * @copy Elegant.display.List#space();
		 */
		public function set space(value:int):void
		{
			itemList.space = value;
		}
		/**
		 * list的相对位移
		 */
		public function get listOffset():Point 
		{
			return _listOffset;
		}
		
		public function set listOffset(value:Point):void 
		{
			itemList.x -= _listOffset.x;
			itemList.x += value.x;
			itemList.y -= _listOffset.y;
			itemList.y += value.y;
			_listOffset = value;
		}
		
		//----------------Dispose------------------------------------
		/**
		 * 销毁Combobox中的所有引用及子元件
		 * @inheritDoc
		 */
		override protected function dispose():void
		{
			super.dispose();
			ELGManager.getInstance.disposeSome(itemList);
			ELGManager.getInstance.disposeSome(pullBg);
			resultTxt = null;
			if(pullBt)
				pullBt.removeEventListener(MouseEvent.CLICK, onCLick);
			pullBt = null;
			pullBg = null;
			itemList = null;
		}
	}
}