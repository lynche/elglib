package Elegant.graphicUI 
{
	import Elegant.display.Button;
	import Elegant.display.Label;
	import flash.display.GradientType;
	import flash.display.Sprite;
	
	/**
	/**
	 * ...
	 * @author 浅唱
	 * @copyright 513151217@qq.com
	 * @version 1.0
	 */
	public class ButtonGUI extends Button 
	{
		
		public function ButtonGUI() 
		{
			super(false);
			drawUI();
		}
		
		/**
		 * 自画UI
		 */
		protected function drawUI():void 
		{
			var sptUp:Sprite = new Sprite();
			sptUp.graphics.beginFill(0);
			sptUp.graphics.drawRect(0, 0, 80, 30);
			sptUp.graphics.beginGradientFill(GradientType.LINEAR, [0x999999, 0xcccccc], [1, 1], [0, 255]);
			sptUp.graphics.drawRect(1, 1, 78, 28);
			sptUp.graphics.endFill();
			this.upState = sptUp;
			
			var sptDown:Sprite = new Sprite();
			sptDown.graphics.beginFill(0);
			sptDown.graphics.drawRect(0, 0, 80, 30);
			sptDown.graphics.beginGradientFill(GradientType.LINEAR, [0x0, 0x333333], [1, 1], [0, 255]);
			sptDown.graphics.drawRect(1, 1, 78, 28);
			sptDown.graphics.endFill();
			this.downState = sptDown;
			
			var sptOver:Sprite = new Sprite();
			sptOver.graphics.beginFill(0);
			sptOver.graphics.drawRect(0, 0, 80, 30);
			sptOver.graphics.beginGradientFill(GradientType.LINEAR, [0x333333, 0x666666], [1, 1], [0, 255]);
			sptOver.graphics.drawRect(1, 1, 78, 28);
			sptOver.graphics.endFill();
			this.overState = sptOver;
			
			sptUp.cacheAsBitmap = sptDown.cacheAsBitmap = sptOver.cacheAsBitmap = true;
			
			var txt:Label = new Label();
			txt.textColor = 0xffffff;
			txt.cacheAsBitmap = true;
			txt.width = 1;
			txt.height = 25;
			txt.y = 5;
			txt.multiline = false;
			txt.autoSize = "center";
			this.label = txt;
		}
	}
}