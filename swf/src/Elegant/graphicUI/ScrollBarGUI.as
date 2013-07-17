package Elegant.graphicUI 
{
	import Elegant.controls.ScrollBar;
	import flash.display.GradientType;
	import flash.display.Sprite;
	

	/**
	 * ...
	 * @author 浅唱
	 * @copyright myjob.liu@foxmail.com
	 * @version 1.0
	 */
	public class ScrollBarGUI extends ScrollBar 
	{
		
		public function ScrollBarGUI() 
		{
			super(false);
			drawUI();
		}
		/**
		 * 自画UI
		 */
		protected function drawUI():void
		{
			var upBtn:Sprite = new Sprite();
			var downBtn:Sprite = new Sprite();
			
			upBtn.graphics.beginFill(0);
			upBtn.graphics.drawRect(0, 0, 14, 17);
			upBtn.graphics.beginGradientFill(GradientType.LINEAR, [0x787878, 0x111111], [1, 1], [0, 255]);
			upBtn.graphics.drawRect(1, 1, 12, 15);
			downBtn.graphics.copyFrom(upBtn.graphics);
			
			upBtn.graphics.beginFill(0xffffff);
			upBtn.graphics.moveTo(6, 6);
			upBtn.graphics.lineTo(9, 12);
			upBtn.graphics.lineTo(3, 12);
			upBtn.graphics.endFill();
			
			downBtn.graphics.beginFill(0xffffff);
			downBtn.graphics.moveTo(6, 12);
			downBtn.graphics.lineTo(9, 6);
			downBtn.graphics.lineTo(3, 6);
			downBtn.graphics.endFill();
			upButton = upBtn;
			downButton = downBtn;
			
			var dragBg:Sprite = new Sprite();
			dragBg.graphics.beginFill(0);
			dragBg.graphics.drawRect(0, 0, 14, 300);
			dragBg.graphics.beginFill(0xaaaaaa);
			dragBg.graphics.drawRect(1, 1, 12, 298);
			dragBg.graphics.endFill();
			this.dragBg = dragBg;
			
			var dragBt:Sprite = new Sprite();
			dragBt.graphics.beginFill(0);
			dragBt.graphics.drawRect(0, 0, 14, 20);
			dragBt.graphics.beginGradientFill(GradientType.LINEAR, [0x787878, 0x111111], [1, 1], [0, 255]);
			dragBt.graphics.drawRect(1, 1, 12, 18);
			dragBt.graphics.endFill();
			this.dragButton = dragBt;
			
			upBtn.cacheAsBitmap = downBtn.cacheAsBitmap = dragBg.cacheAsBitmap = dragBt.cacheAsBitmap = true;
			height = 300;
		}
	}
}