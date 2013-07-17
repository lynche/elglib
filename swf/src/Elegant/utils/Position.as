package Elegant.utils 
{
	import Elegant.ELGManager;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Point;
	/**
	 * 定位
	 * @author 小痛
	 * @copyright myjob.liu@foxmail.com
	 * @version 1.0
	 */
	public class Position 
	{
		/**
		 * 将显示对象居中
		 * @param	target			要居中的对象
		 * @param	useStageXY		使其相对舞台居中,当定位时对象没有被加入到任何父级,则会相对于舞台定位
		 */
		public static function toCenter(target:DisplayObject, useStageXY:Boolean = false):void
		{
			var w:int;
			var h:int;
			var point:Point = new Point();
			
			if(!target.parent || useStageXY)
			{
				var stage:Stage = ELGManager.getInstance.mainShowContainer.stage;
				w = stage.stageWidth;
				h = stage.stageHeight;
				
				if(target.parent)
					point = target.parent.localToGlobal(point);
				
			} else {
				w = target.parent.width;
				h = target.parent.height;
			}
			target.x = ((w - target.width) >> 1) - point.x;
			target.y = ((h - target.height) >> 1) - point.y;
		}
	}

}