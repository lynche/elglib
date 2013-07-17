package Elegant.interfaces 
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	
	/**
	 * ...
	 * @version 1.0
	 * @copyright myjob.liu@foxmail.com
	 * @author 浅唱
	 */
	public interface ISprite extends IDisplayObjectContainer
	{
		/**
		 *  @copy flash.display.Sprite#buttonMode
		 */
		function set buttonMode(value:Boolean):void
		function get buttonMode():Boolean;
		
		/**
		 *  @copy flash.display.Sprite#dropTarget
		 */
		function get dropTarget():DisplayObject;
		
		/**
		 *  @copy flash.display.Sprite#graphics
		 */
		function get graphics():Graphics;
		
		/**
		 *  @copy flash.display.Sprite#hitArea
		 */
		function set hitArea(value:Sprite):void
		function get hitArea():Sprite;
		
		/**
		 *  @copy flash.display.Sprite#soundTransform
		 */
		function set soundTransform(value:SoundTransform):void
		function get soundTransform():SoundTransform;
		
		/**
		 *  @copy flash.display.Sprite#useHandCursor
		 */
		function set useHandCursor(value:Boolean):void
		function get useHandCursor():Boolean;
		
		/**
		 *  @copy flash.display.Sprite#startDrag()
		 */
		function startDrag(lockCenter:Boolean = false, bounds:Rectangle = null):void 
		
		/**
		 *  @copy flash.display.Sprite#stopDrag()
		 */
		function stopDrag():void
	}
}