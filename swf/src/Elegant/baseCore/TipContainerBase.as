package Elegant.baseCore 
{
	import Elegant.display.Container;
	import Elegant.display.Label;
	import Elegant.ELGManager;
	import Elegant.utils.InitObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	

	/**
	 * ...
	 * @author 浅唱
	 * @copyright myjob.liu@foxmail.com
	 * @version 1.0
	 */
	public class TipContainerBase extends Container 
	{
		/**
		 * 是否在mouseMove的时候使用自己的定位方法
		 */
		public var useOwnPosition:Boolean = false;
		protected var label:Label;
		
		/**
		 * @param	vars	<li><strong> defaultLabel : Boolean</strong> - 是否使用默认的Label,基本没用，属于测试用的比较多</li>
		 * 					<li><strong> text : String</strong> - 默认文本显示的文字</li>
		 */
		public function TipContainerBase(vars:Object = null)
		{
			super();
			cacheAsBitmap = true;
			mouseChildren = mouseEnabled = false;
			
			if(InitObject.getBoolean(vars, "defaultLabel", false))
			{
				label = new Label();
				label.textColor = 0xffffff;
				label.autoSize = "left";
				addChild(label);
				tipLabel = InitObject.getString(vars, "text", "");
			}
		}
		/**
		 * @inheritDoc
		 */
		override protected function dispose():void 
		{
			ELGManager.getInstance.disposeSome(label);
			super.dispose();
		}
		
		/**
		 * 设置 / 获取 显示tip的文字
		 */
		public function get tipLabel():String 
		{
			return label.htmlText;
		}
		
		public function set tipLabel(value:String):void 
		{
			label.htmlText = value;
			updataBG();
		}
		/**
		 * 更新背景,通过override来制作满足你需要的背景
		 */
		public function updataBG():void
		{
			graphics.clear();
			graphics.lineStyle(2, 0xffffff, .7);
			graphics.beginFill(0x000000, .3);
			graphics.drawRoundRect( -10, -10, width + 20, height + 20, 10, 10);
			graphics.endFill();
		}
		/**
		 * 在mouseMove的时候自己的定位方法
		 * 该super仅仅限制tip不会出屏幕
		 * 以及调用e.updateAfterEvent();
		 * @param	e
		 */
		public function ownPositionOnMouseMove(e:MouseEvent):void
		{
			var point:Point = parent.globalToLocal(new Point());
			if (x + width + point.x > stage.stageWidth)
			{
				x = stage.stageWidth - width - point.x;
			}
			if (x + point.x < 0) x =  -point.x;
			if (y + height + point.y > stage.stageHeight)
			{
				y = stage.stageHeight - height - point.y;
			}
			if (y + point.y < 0) y =  -point.y;
			e.updateAfterEvent();
		}
	}
}