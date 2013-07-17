package Elegant.baseCore 
{
	import Elegant.config.ELGFla;
	import Elegant.display.FLASkinContainer;
	import Elegant.display.Label;
	import Elegant.ELGManager;
	import Elegant.interfaces.IConversion;
	import Elegant.interfaces.IHasLabel;
	import Elegant.utils.Cloning;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * 一个拥有命名规则的TextField的面板
	 * 其实还是sprite ╮(╯▽╰)╭
	 * @author 浅唱
	 */
	public class HasLabelBase extends FLASkinContainer implements IConversion, IHasLabel 
	{
		ELGFla static const className:String = "HasLabelBase";
		/**
		 * 文本命名
		 */
		ELGFla static const LABEL_NAME:String = "TXF_Label";
		
		private var _label:Label;
		public function HasLabelBase(someLabel:Label = null) 
		{
			super(someLabel == null);
			if (someLabel)
			{
				_label = someLabel;
				var tf:TextField = TextField(getChildByName(HasLabelBase.ELGFla::LABEL_NAME));
				if (tf)
				{
					Cloning.cloneAll(tf, _label, ["scaleZ", "rotationX", "rotationY", "rotationZ", "z"]);
					removeChild(tf);
				}
				addChild(_label);
				_label.height += 2;
			}
		}
		/**
		 * @throws	必须有命名规则的TextField
		 * @inheritDoc
		 */
		override public function converUI():void 
		{
			_label = Label.toLabel(TextField(this.getChildByName(HasLabelBase.ELGFla::LABEL_NAME)));
			if (_label == null) 
				throw new Error("必须有命名为 " + HasLabelBase.ELGFla::className + " 的TextField");
		}
		/**
		 * 重写设置子元件接受鼠标事件
		 * 多此一举是为了当文本显示鼠标手型的时候
		 * 依然可以响应高亮事件
		 * @inheritDoc
		 */
		override public function set mouseChildren(value:Boolean):void 
		{
			super.mouseChildren = value;
			if (value)
			{
				removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
				removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			} else {
				if (_label.highLightMode)
				{
					addEventListener(MouseEvent.ROLL_OVER, onRollOver);
					addEventListener(MouseEvent.ROLL_OUT, onRollOut);
				} else {
					removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
					removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
				}
			}
		}
		private function onRollOver(e:MouseEvent):void 
		{
			_label.realTextColor = _label.textColor;
			_label.textColor = _label.highLightColor;
		}
		
		private function onRollOut(e:MouseEvent):void 
		{
			_label.textColor = _label.realTextColor;
		}
		/**
		 * 设置是否高亮显示文本,默认为<code>false</code>
		 * @param	highLightMode
		 * @param	highLightColor
		 */
		public function setHighLight(highLightMode:Boolean, highLightColor:uint = 0):void
		{
			if (_label.highLightMode == highLightMode) return;
			_label.highLightMode = highLightMode;
			_label.highLightColor = highLightColor;
			mouseChildren = mouseChildren;
		}
		
		//--------INTERFACE Elegant.interfaces.IHasLabel------------------------------------------------
		/**
		 * @copy Elegant.interfaces.IHasLabel#text
		 */
		public function get text():String 
		{
			return _label.text;
		}
		public function set text(str:String):void 
		{
			if (str == null) str = "";
			_label.text = str;
		}
		/**
		 * @copy Elegant.interfaces.IHasLabel#itemID
		 */
		public function get itemID():int 
		{
			return int(_label.itemID);
		}
		/**
		 * @copy Elegant.interfaces.IHasLabel#itemID
		 */
		public function set itemID(value:int):void 
		{
			_label.itemID = value;
		}
		/**
		 * @copy Elegant.interfaces.IHasLabel#label
		 */
		public function get label():TextField { return _label; }
		
		/**
		 * @return	返回一个新的HasLabelBase
		 */
		public function clone():HasLabelBase
		{
			return Cloning.clone(this);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function dispose():void 
		{
			super.dispose();
			ELGManager.getInstance.disposeSome(_label);
			_label = null;
		}
	}
}