package Elegant.controls.tree
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	
	/**
	 * tree的图标创建
	 * @author 小痛
	 */
	internal class IconCreator
	{
		private var _mergeIcon:BitmapData;
		private var _spreadIcon:BitmapData;
		private var _terminalIcon:BitmapData;
		
		public function IconCreator()
		{
			drawIcon();
		}
		
		/**
		 * 画出Icon
		 */
		protected function drawIcon():void
		{
			var shape:Shape = new Shape();
			var g:Graphics = shape.graphics;
			g.lineStyle(2, 0x333333);
			g.lineTo(3, 0);
			_spreadIcon = new BitmapData(3, 1, true, 0);
			_spreadIcon.draw(shape);
			
			g.clear();
			g.moveTo(0, 3);
			g.lineTo(6, 3);
			g.moveTo(3, 0);
			g.lineTo(3, 6);
			_mergeIcon = new BitmapData(6, 6, true, 0);
			_mergeIcon.draw(shape);
			
			g.clear();
			g.beginFill(0x333333);
			g.drawCircle(2, 2, 2);
			_terminalIcon = new BitmapData(4, 4, true, 0);
			_terminalIcon.draw(shape);
		}
		
		//----------------------getter / setter------------------
		/**
		 * 获取展开的Icon
		 */
		public function get spreadIcon():BitmapData
		{
			return _spreadIcon;
		}
		
		/**
		 * 获取合并的Icon
		 */
		public function get mergeIcon():BitmapData
		{
			return _mergeIcon;
		}
		
		/**
		 * 获取终端note的Icon
		 */
		public function get terminalIcon():BitmapData
		{
			return _terminalIcon;
		}
	
	}
}