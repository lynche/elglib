package Elegant.graphicUI 
{
	import Elegant.controls.Alert;
	import Elegant.display.Label;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author 小痛
	 */
	public class AlertGUI extends Alert 
	{
		
		public function AlertGUI() 
		{
			super(false);
			
			drawUI();
		}
		
		/**
		 * 自画UI
		 */
		protected function drawUI():void 
		{
			var bg:Sprite = new Sprite();
			bg.graphics.beginFill(0xcccccc);
			bg.graphics.drawRoundRect(0, 0, 350, 150, 10, 10);
			bg.cacheAsBitmap = true;
			_alertBg = bg;
			addChild(bg);
			
			var label:Label = new Label();
			label.x = 25;
			label.y = 50;
			label.width = 300;
			label.multiline = true;
			label.autoSize = "center";
			_label = label;
			addChild(_label);
			
			Alert.alertBt = ButtonGUI;
			btY = 100;
		}
	}

}