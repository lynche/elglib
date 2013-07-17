package Elegant.controls
{
	import Elegant.controls.ScrollBar;
	import Elegant.utils.ArrayUtil;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * 
	 * @author 浅唱
	 */
	public class ToggleScrollBar extends ScrollBar
	{
		public var ease:Function;
		
		private var _togglePoint:Array;
		private var _togglePointIndex:int;
		
		public function ToggleScrollBar(autoConverUI:Boolean = true)
		{
			super(autoConverUI);
		}
		
		override protected function onStageUp(e:MouseEvent):void
		{
			if (_togglePoint)
				transformEffect.tween(this, .1, {ratio: finalRatio, ease: ease});
			dispatchEvent(new Event(Event.CHANGE));
			super.onStageUp(e);
		}
		
		//----------------------------------getter / setter------------------------
		override public function get finalRatio():Number
		{
			var prop:String = (direction == ScrollBar.HORIZONTAL ? "x" : "y");
			var index:int = 0;
			while (_togglePoint[index][prop] <= dragButton[prop])
			{
				index += 1;
				if (index >= _togglePoint.length)
					break;
			}
			index -= 1;
			_togglePointIndex = index;
			
			if (_direction == HORIZONTAL)
			{
				//横向
				return (_togglePoint[index].x - _dragBg.x) / (_dragBg.width - _dragButton.width);
			}
			else
			{
				//纵向
				return (_togglePoint[index].y - _dragBg.y) / (_dragBg.height - _dragButton.height);
			}
		}
		
		public function get togglePoint():Array
		{
			return _togglePoint;
		}
		
		public function set togglePoint(value:Array):void
		{
			_togglePoint = value;
			var porp:String = (direction == ScrollBar.HORIZONTAL ? "x" : "y");
			ArrayUtil.quickSortProperties(_togglePoint, porp);
			if (_togglePoint[0][porp] != 0)
			{
				_togglePoint.unshift(new Point());
			}
		}
		
		public function get togglePointIndex():int
		{
			return _togglePointIndex;
		}
	}

}