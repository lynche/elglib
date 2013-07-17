package Elegant.display 
{
	import Elegant.interfaces.IConversion;
	
	/**
	 * 可以从fla定义皮肤的组件的父类
	 * @author 浅唱
	 */
	public class FLASkinContainer extends Container implements IConversion 
	{
		
		public function FLASkinContainer(autoConverUI:Boolean = true) 
		{
			super();
			if (autoConverUI) converUI();
		}
		
		/* INTERFACE Elegant.interfaces.IConversion */
		/**
		 * 该方法会在实例被声明是自动执行,当你自主调用此方法时,相当于刷新UI
		 * 你可以给一个新的子元件名称命名为规则名称,并将原有的规则名称的元件换个名字
		 * @throw Error 缺少命名规则的元件
		 * @copy Elegant.interfaces.IConversion#converUI()
		 */
		public function converUI():void 
		{
			throw new Error("must be override");
		}
		
		/**
		 * 重写改变宽度时只接受int
		 * @inheritDoc
		 */
		override public function set width(value:Number):void 
		{
			super.width = int(value);
			//for (var i:int = 0; i < numChildren; i += 1)
			//{
				//getChildAt(i).width = value;
			//}
		}
		/**
		 * 重写改变高度时只接受int
		 * @inheritDoc
		 */
		override public function set height(value:Number):void 
		{
			super.height = int(value);
			//for (var i:int = 0; i < numChildren; i += 1)
			//{
				//getChildAt(i).height = value;
			//}
		}
	}
}