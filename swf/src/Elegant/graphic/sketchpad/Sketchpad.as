package Elegant.graphic.sketchpad 
{
	import Elegant.display.Container;
	import Elegant.graphic.interfaces.IPen;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * 画板
	 * @author 浅唱
	 * @copyright myjob.liu@foxmail.com
	 * @version 1.0
	 */
	public class Sketchpad
	{
		/**
		 * 笔触
		 */
		private var _currentPen:IPen;
		/**
		 * 画板容器包容所有的Layer
		 */
		private var _container:Sprite = new Container();
		/**
		 * 当前层
		 */
		private var _currentLayer:DisplayObjectContainer;
		
		public function Sketchpad() 
		{
			super();
			_container.addEventListener(MouseEvent.CLICK, onContainerClickHandler);
		}
		//-------------------------Event Handler-------------------------------------
		/**
		 * 面板容器被点击
		 * 如果有画笔则绘图
		 * 如果画笔为null则调用greensock的TransformManager
		 * @param	e
		 */
		private function onContainerClickHandler(e:MouseEvent):void 
		{
			if (_currentPen)
			{
				
			}
		}
		
		//--------------------------getter / setter----------------------------------
		/**
		 * 设置 / 获取 画板当前笔触
		 */
		public function get currentPen():IPen 
		{
			return _currentPen;
		}
		
		public function set currentPen(value:IPen):void 
		{
			_currentPen = value;
		}
		
		/**
		 * 获取 画板容器
		 */
		public function get container():DisplayObjectContainer 
		{
			return _container;
		}
		/**
		 * 获取 画板当前层
		 */
		public function get currentLayer():DisplayObjectContainer 
		{
			return _currentLayer;
		}
	}

}