package Elegant.display
{
	import Elegant.baseCore.HasLabelBase;
	import Elegant.config.ELGFla;
	import Elegant.controls.ScrollBar;
	import Elegant.ELGManager;
	import Elegant.events.ListEvent;
	import Elegant.interfaces.IConversion;
	import Elegant.interfaces.IHasLabel;
	import Elegant.utils.ChildrenKiller;
	import Elegant.utils.Scale9Rect;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * @eventType Elegant.events.ListEvent.ITEM_SELECT
	 * @copy Elegant.events.ListEvent#ITEM_SELECT
	 */
	[Event(name = "itemSelect", type = "Elegant.events.ListEvent")]
	/**
	 * 列表
	 * @author 浅唱
	 * @version 1.0
	 */
	public class List extends FLASkinContainer implements IConversion
	{
		ELGFla static const className:String = "List";
		/**
		 * @private	各位观众你们是不需要知道这个滴
		 */
		ELGFla static const LIST_BG:String = "DIS_List_Bg";
		/**
		 * @private	各位观众你们是不需要知道这个滴
		 */
		ELGFla static const ITEM:String = "IHASLABEL_List_Item";
		/**
		 * @private	各位观众你们是不需要知道这个滴
		 */
		ELGFla static const SCROLL_BAR:String = "SCR_List_ScrBar";
		
		/**
		 * 该类一定是实现IHasLabel接口(继承自HasLabelBase)的类
		 */
		public var ListItem:Class;
		/**
		 * 背景显示对象
		 */
		private var listBG:Scale9Panel;
		/**
		 * 滚动条
		 */
		private var _scrollBar:ScrollBar;
		/**
		 * 显示滚动条前最多有多少条记录
		 */
		private var _maxContent:uint = 10;
		/**
		 * 存放内容的数组
		 * 内容格式:
		 * [{text:显示的名字,itemID:编号}]
		 */
		private var _data:Array;
		/**
		 * 存放所有的item
		 * 长度始终等于data的长度
		 */
		private var _itemVec:Vector.<IHasLabel>;
		/**
		 * 存放HasLabelBase对象的显示容器
		 */
		protected var itemContainer:Sprite;
		/**
		 * 存放HasLabelBase对象的显示容器的遮罩
		 */
		private var itemMasker:Sprite;
		/**
		 * 设置间隔
		 */
		private var _space:int;
		/**
		 * @private	记录设置的宽度
		 */
		private var _tempWidth:int
		/**
		 * 鼠标经过时是否高亮显示Label
		 * @see Elegant.display.Label#_highLightMode
		 */
		private var _highLightMode:Boolean;
		/**
		 * 鼠标经过时高亮显示label的颜色
		 */
		private var _highLightColor:uint;
		private var _textColor:uint = uint.MAX_VALUE;
		private var _scrollBarOffset:Point;
		public function List(autoConverUI:Boolean = true)
		{
			super(autoConverUI);
			_itemVec = new Vector.<IHasLabel>(0, false);
			_data = [];
		}
		
		/**
		 * @throws	List中命名为命名规则名称的元件必须必须实现IHasLabel接口
		 * @inheritDoc
		 */
		override public function converUI():void
		{
			listBG = Scale9Panel.toScale9Panel(this.getChildByName(ELGFla::LIST_BG));
			_tempWidth = listBG.width;
			
			var tempItem:DisplayObject = this.getChildByName(ELGFla::ITEM);
			if (tempItem == null) throw new Error("必须有命名为 " + ELGFla::ITEM + " 的元件");
			if(!(tempItem is IHasLabel))
				throw new Error("List中命名为 " + ELGFla::ITEM + " 的元件必须实现IHasLabel接口");
			
			ListItem = Class(tempItem["constructor"]);
			removeChild(tempItem);
			
			_scrollBar = ScrollBar(this.getChildByName(ELGFla::SCROLL_BAR));
			
			itemContainer = new Sprite();
			itemMasker = new Sprite;
			addChild(itemContainer);
			addChild(itemMasker);
			itemContainer.mask = itemMasker;
			
			if(listBG.scale9Grid)
			{
				itemContainer.x = listBG.scale9Grid.x;
				itemContainer.y = listBG.scale9Grid.y;
			}
			if (_scrollBar)
			{
				_scrollBarOffset = new Point(scrollBar.x - listBG.getRect(this).right, 0);
				this.setChildIndex(scrollBar, numChildren - 1);
				_scrollBar.target = itemContainer;
				_scrollBar.wheelTarget = this;
			}
			setMaskRect();
		}
		
		/**
		 * 获取存放内容的数组
		 * 内容格式:
		 * [{text:显示的名字,itemID:编号,...args}]
		 */
		public function get data():Array
		{
			return _data;
		}
		
		/**
		 * 写入存放内容的数组并刷新显示列表
		 * 内容格式:
		 * [{label:显示的名字,ID:编号}]
		 */
		public function set data(value:Array):void
		{
			ChildrenKiller.kill(itemContainer, true);
			if(_itemVec)
				while(_itemVec.length > 0)
				{
					ELGManager.getInstance.disposeSome(_itemVec.pop());
				}
			_itemVec = new Vector.<IHasLabel>(value.length, false);
			
			_data = [];
			for(var i:int = 0; i < value.length; i += 1)
			{
				add(value[i], i == (value.length - 1));
			}
		}
		
		/**
		 * 增加一个元素到列表
		 * @param	obj	增加到列表的东东,格式为{label:显示的名字,ID:编号}
		 * @param	reflush	是否刷新列表
		 */
		public function add(obj:Object, reflush:Boolean = true):void
		{
			var last:int = _data.length;
			_data[last] = obj;
			
			var item:IHasLabel = new ListItem();
			if (!obj.hasOwnProperty("itemID")) obj.itemID = last;
			for (var i:* in obj) 
			{
				item[i] = obj[i];
			}
			
			if (item is HasLabelBase) HasLabelBase(item).setHighLight(_highLightMode, _highLightColor);
			else if (item.label is Label) Label(item.label).setHighLight(_highLightMode, _highLightColor);
			
			(_textColor == uint.MAX_VALUE) || (item.label.textColor = _textColor);
			//item.x = (_tempWidth - item.width) / 2;
			if(last > 0)
				item.y = (_itemVec[0].height + space) * last;
			item.addEventListener(MouseEvent.CLICK, onItemClick);
			itemContainer.addChild(DisplayObject(item));
			_itemVec[last] = item;
			if(reflush)
			{
				maxContent = _maxContent;
				if (_scrollBar)_scrollBar.updataAutoHide();
			}
		}
		
		protected function onItemClick(e:MouseEvent):void
		{
			dispatchEvent(new ListEvent(ListEvent.ITEM_SELECT, e.currentTarget.itemID, e.currentTarget.text, DisplayObject(e.currentTarget)));
		}
		
		/**
		 * 从列表中删除某元素
		 * @param	obj
		 * @param	reflush	是否刷新列表
		 */
		public function reduce(obj:Object, reflush:Boolean):Object
		{
			for(var i:int = 0; i < _data.length; i += 1)
			{
				if(_data[i].label == obj.label && _data[i].ID == obj.ID)
				{
					var objResult:Object = _data.splice(i, 1);
					reflush && (maxContent = _maxContent);
					return objResult;
				}
			}
			return null;
		}
		
		/**
		 * 设置mask的位置大小,使其等于rect中的值(其中宽高等于)
		 * @param	rect
		 */
		private function setMaskRect():void
		{
			itemMasker.graphics.clear();
			itemMasker.graphics.beginFill(0, 1);
			itemMasker.graphics.drawRect(itemContainer.x, itemContainer.y, contentWidth - itemContainer.x, contentHeight);
			itemMasker.graphics.endFill();
			if (_scrollBar)
			{
				_scrollBar.height = itemMasker.height;
				_scrollBar.maskSize = itemMasker.height;
				_scrollBar.updataAutoHide();
			}
		}
		
		//--------getters / setters------------------------------------------------------
		/**
		 * 获取列表x位置
		 */
		public function get itemX():int
		{
			return itemContainer.x;
		}
		
		/**
		 * 设置列表x位置
		 */
		public function set itemX(value:int):void
		{
			itemMasker.x = itemContainer.x = value;
		}
		
		/**
		 * 获取列表y位置
		 */
		public function get itemY():int
		{
			return itemContainer.y;
		}
		
		/**
		 * 设置列表y位置
		 */
		public function set itemY(value:int):void
		{
			itemMasker.y = itemContainer.y = value;
		}
		
		/**
		 * 重写改变宽度时只接受int,且只改变子元件高度,不改变scale
		 * @inheritDoc
		 */
		override public function set width(value:Number):void
		{
			value = Math.round(value);
			if(_tempWidth == value)
				return;
			
			listBG.width = value;
			_tempWidth = value;
			setMaskRect();
			
			if (_scrollBar)
				_scrollBar.x = _scrollBarOffset.x + listBG.getRect(this).right;
			
			if(_itemVec == null || _itemVec.length == 0)
				return;
			
			for(var i:int = 0; i < _itemVec.length; i += 1)
			{
				_itemVec[i].x = (value - _itemVec[i].width) / 2;
			}
		}
		
		/**
		 * 不可设定高度
		 * @throws Error 此组件不能设置高度,如想改变每页最多显示个数,可设置maxContent
		 * @see #maxContent
		 */
		override public function set height(value:Number):void
		{
			throw Error("此组件不能设置高度,如想改变每页最多显示个数,可设置maxContent");
		}
		
		/**
		 * 获取内容宽度
		 */
		public function get contentWidth():Number
		{
			return listBG.width;
		}
		
		/**
		 * 获取内容高度
		 */
		public function get contentHeight():Number
		{
			if(_itemVec && _itemVec.length > 0)
			{
				//使最多显示数量不多于当前最大数量
				var _tempMaxContent:int = Math.min(_maxContent, _itemVec.length);
				return (_itemVec[0].height + space) * _tempMaxContent;
			}
			return 0;
		}
		
		/**
		 * 获取在显示滚动条前最多显示的条目
		 */
		public function get maxContent():uint
		{
			return _maxContent;
		}
		
		/**
		 * 设置在显示滚动条前最多显示的条目
		 * 当设置height的时候也会改变此项的值
		 */
		public function set maxContent(value:uint):void
		{
			_maxContent = value;
			setMaskRect();
			if(_itemVec && _itemVec.length > 0)
			{
				var rect:Rectangle = Scale9Rect.getRealRect(listBG, contentWidth, contentHeight);
				listBG.height = rect.bottom;
			}
			else
			{
				listBG.height = 0;
			}
		}
		
		/**
		 * 获取列表之间的间隔,默认为0
		 */
		public function get space():int
		{
			return _space;
		}
		
		/**
		 * 设置列表之间的间隔,默认为0
		 */
		public function set space(value:int):void
		{
			if(_space == value)
				return;
			_space = value;
			if (_itemVec == null || _itemVec.length == 0) return;
			var itemHeight:int = _itemVec[0].height;
			for(var i:int = 1; i < _itemVec.length; i += 1)
			{
				_itemVec[i].y = (itemHeight + value) * i;
			}
			maxContent = _maxContent;
		}
		
		/**
		 * 获取文本的默认颜色
		 */
		public function get textColor():uint
		{
			return _textColor;
		}
		
		/**
		 * 设置文本的默认颜色
		 */
		public function set textColor(value:uint):void
		{
			_textColor = value;
			for(var i:int = 0; i < _itemVec.length; i += 1)
			{
				_itemVec[i].label.textColor = value;
			}
		}
		/**
		 * 设置 / 获取 item的位置偏移
		 * 等于分别设置itemX,itemX
		 * @see #itemX
		 * @see #itemY
		 */
		public function get itemOffset():Point 
		{
			return new Point(itemContainer.x, itemContainer.y);
		}
		
		public function set itemOffset(value:Point):void 
		{
			itemX = value.x;
			itemY = value.y;
		}
		/**
		 * 设置 / 获取 滚动条的位置偏移
		 */
		public function get scrollBarOffset():Point 
		{
			return _scrollBarOffset;
		}
		
		public function set scrollBarOffset(value:Point):void 
		{
			_scrollBarOffset = new Point(value.x - _scrollBarOffset.x, value.y - _scrollBarOffset.y);;
			_scrollBar.x += _scrollBarOffset.x;
			_scrollBar.y += _scrollBarOffset.y;
			_scrollBarOffset = value;
		}
		
		/**
		 * 获取滚动条的实例
		 */
		public function get scrollBar():ScrollBar 
		{
			return _scrollBar;
		}
		
		/**
		 * 获取所有的item
		 * 长度始终等于data的长度
		 */
		public function get itemVec():Vector.<IHasLabel> 
		{
			return _itemVec;
		}
		
		/**
		 * 设置是否高亮显示文本,默认为<code>false</code>
		 * 只有实现IHasLabel接口,并且返回label是Label时才好使
		 * @param	highLightMode
		 * @param	highLightColor
		 */
		public function setHighLight(highLightMode:Boolean, highLightColor:uint=0):void
		{
			_highLightColor = highLightColor;
			_highLightMode = highLightMode;
			
			if (_itemVec.length > 0)
			{
				var i:int = 0;
				if (_itemVec[0] is HasLabelBase)
				{
					for(; i < _itemVec.length; i += 1)
					{
						HasLabelBase(_itemVec[i]).setHighLight(highLightMode, highLightColor);
					}
				}
				else if (_itemVec[0].label is Label)
				{
					for(; i < _itemVec.length; i += 1)
					{
						Label(_itemVec[i].label).setHighLight(highLightMode, highLightColor);
					}
				}
			}
		}
		
		/**
		 * 卸载List中所有的引用及子元件
		 * @inheritDoc
		 */
		override protected function dispose():void
		{
			super.dispose();
			ListItem = null;
			ELGManager.getInstance.disposeSome(listBG);
			listBG = null;
			_data = null;
			ChildrenKiller.kill(itemContainer, true);
			itemContainer = null;
			itemMasker.graphics.clear();
			itemMasker = null;
			if(_itemVec)
				while(_itemVec.length > 0)
				{
					ELGManager.getInstance.disposeSome(_itemVec.pop());
				}
			_itemVec = null;
		}
	}
}