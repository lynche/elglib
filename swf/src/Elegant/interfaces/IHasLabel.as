package Elegant.interfaces 
{
	import flash.text.TextField;
	/**
	 * 仅供Label以及IHasLabel引用
	 * 为了能使其方便的获得text,而不必在乎是textField还是Sprite等
	 * @see Elegant.display.Label
	 * @see Elegant.baseCore.HasLabelBase
	 * @author 浅唱
	 */
	public interface IHasLabel extends ISprite
	{
		/**
		 * 设置 / 获取 按钮中的文本显示内容
		 */
		function get text () : String;
		function set text (value:String) : void;
		/**
		 * 设置 / 获取 按钮中的文本编号
		 */
		function get itemID():int;
		function set itemID(value:int):void
		/**
		 * 返回Label的实例
		 */
		function get label():TextField
	}
}