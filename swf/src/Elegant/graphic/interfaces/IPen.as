package Elegant.graphic.interfaces 
{
	import flash.display.DisplayObjectContainer;
	
	/**
	 * 笔触接口
	 * @version 1.0
	 * @copyright myjob.liu@foxmail.com
	 * @author 浅唱
	 */
	public interface IPen 
	{
		/**
		 * 以x, y位置为中心绘制自身
		 * @param	x
		 * @param	y
		 */
		function draw(x:int, y:int):void
		
		/**
		 * 设置 / 获取 画笔粗细
		 * 在圆形画笔中指的是圆的半径
		 */
		function get thickness():Number 
		function set thickness(value:Number):void 
		
		/**
		 * 设置 / 获取 画笔填充的颜色
		 */
		function get color():Array 
		function set color(value:Array):void 
		
		/**
		 * 设置 / 获取 画笔填充的透明度
		 */
		function get alphas():Array 
		function set alphas(value:Array):void 
		
		/**
		 * 设置 / 获取 颜色填充区域 0 - 255
		 */
		function get ratios():Array 
		function set ratios(value:Array):void 
		
		/**
		 * 设置 / 获取 绘制目标层
		 */
		function get layer():DisplayObjectContainer 
		function set layer(value:DisplayObjectContainer):void 
		
		/**
		 * 设置 / 获取 用于指定要使用哪种渐变类型的 GradientType 类的值：GradientType.LINEAR 或 GradientType.RADIAL。
		 */
		function get gradientType():String;
		function set gradientType(value:String):void;
		
		/**
		 * 设置 / 获取 (default = "pad") — 用于指定要使用哪种 spread 方法的 SpreadMethod 类的值：SpreadMethod.PAD、SpreadMethod.REFLECT 或 SpreadMethod.REPEAT。
		 */
		function get spreadMethod():String;
		function set spreadMethod(value:String):void;
		
		/**
		 * 设置 / 获取  (default = "rgb") — 用于指定要使用哪个值的 InterpolationMethod 类的值：InterpolationMethod.LINEAR_RGB 或 InterpolationMethod.RGB
		 * 例如，假设有两种颜色之间的简单线性渐变（spreadMethod 参数设置为 SpreadMethod.REFLECT）。
		 */
		function get interpolationMethod():String;
		function set interpolationMethod(value:String):void;
		
		/**
		 * 设置 / 获取   (default = 0) — 一个控制渐变的焦点位置的数字。
		 * 0 表示焦点位于中心。
		 * 1 表示焦点位于渐变圆的一条边界上。
		 * -1 表示焦点位于渐变圆的另一条边界上。
		 * 小于 -1 或大于 1 的值将舍入为 -1 或 1。
		 */
		function get focalPointRatio():Number;
		function set focalPointRatio(value:Number):void;
	}
}