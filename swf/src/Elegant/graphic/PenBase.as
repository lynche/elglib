package Elegant.graphic 
{
	import Elegant.graphic.interfaces.IPen;
	import flash.display.DisplayObjectContainer;
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	
	/**
	 * 笔触的父类
	 * @author 浅唱
	 * @copyright myjob.liu@foxmail.com
	 * @version 1.0
	 */
	internal class PenBase implements IPen
	{
		/**
		 * 绘制目标层
		 */
		private var _layer:DisplayObjectContainer;
		
		/**
		 * 画笔填充的颜色
		 */
		private var _color:Array;
		private var _alphas:Array;
		/**
		 * 画笔粗细
		 * 在圆形画笔中指的是圆的半径
		 */
		private var _thickness:Number;
		/**
		 * 颜色填充区域 0 - 255
		 */
		private var _ratios:Array;
		
		private var _gradientType:String = GradientType.LINEAR;
		private var _spreadMethod:String = SpreadMethod.PAD;
		private var _interpolationMethod:String = InterpolationMethod.RGB;
		private var _focalPointRatio:Number = 0;
		
		/**
		 * 本类不惨与直接的绘制,只是提供一个笔触的父类
		 * @param	thickness
		 * @param	color
		 * @param	ratios
		 */
		public function PenBase(thickness:Number, color:Array, ratios:Array = null) 
		{
			_thickness = thickness;
			_color = color;
			_ratios = ratios;
		}
		
		/* INTERFACE Elegant.graphic.interfaces.IPen */
		/**
		 * 不实现任何笔触
		 * @inheritDoc
		 */
		public function draw(x:int, y:int):void
		{
			
		}
		
		//-----------------------------getter / setter------------------------
		/**
		 * @inheritDoc
		 */
		public function get layer():DisplayObjectContainer 
		{
			return _layer;
		}
		
		public function set layer(value:DisplayObjectContainer):void 
		{
			_layer = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get thickness():Number 
		{
			return _thickness;
		}
		
		public function set thickness(value:Number):void 
		{
			_thickness = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get color():Array 
		{
			return _color;
		}
		
		public function set color(value:Array):void 
		{
			_color = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get alphas():Array 
		{
			return _alphas;
		}
		
		public function set alphas(value:Array):void 
		{
			_alphas = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get ratios():Array 
		{
			return _ratios;
		}
		
		public function set ratios(value:Array):void 
		{
			_ratios = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get gradientType():String 
		{
			return _gradientType;
		}
		
		public function set gradientType(value:String):void 
		{
			_gradientType = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get spreadMethod():String 
		{
			return _spreadMethod;
		}
		
		public function set spreadMethod(value:String):void 
		{
			_spreadMethod = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get interpolationMethod():String 
		{
			return _interpolationMethod;
		}
		
		public function set interpolationMethod(value:String):void 
		{
			_interpolationMethod = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get focalPointRatio():Number 
		{
			return focalPointRatio;
		}
		
		public function set focalPointRatio(value:Number):void 
		{
			focalPointRatio = value;
		}
	}
}