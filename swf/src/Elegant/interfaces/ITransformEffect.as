package Elegant.interfaces 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	/**
	 * 切换效果
	 * 配合GreenSock的类可以方便的实现很多添加移除的效果
	 * @author 浅唱
	 */
	public interface ITransformEffect
	{
		/**
		 * 向parent中添加显示对象
		 * @param	dis
		 * @param	parent
		 * @param	onComplete
		 * @param	onCompleteParams
		 */
		function show(dis:DisplayObject, parent:DisplayObjectContainer, objectVars:Object = null):void
		/**
		 * 将显示对象从显示列表中移除
		 * @param	dis
		 * @param	onComplete
		 * @param	onCompleteParams
		 */
		function close(dis:DisplayObject, objectVars:Object = null):void
		/**
		 * 将对象从显示列表中移除并添加另外一个对象
		 * 如过<code>delay</code>为-1则是等待第一个显示对象移除后添加
		 * @param	dis
		 * @param	next
		 * @param	delay
		 * @param	onComplete
		 * @param	onCompleteParams
		 */
		function exchange(dis:DisplayObject, next:DisplayObject, objectVars:Object = null):void
		/**
		 * 将对象从当前值过渡到objectVars中指定的值
		 * @param	target	目标
		 * @param	time	经历的时间
		 * @param	objectVars	需要改变的属性最终值
		 */
		function tween(target:Object, time:Number, objectVars:Object):void
	}
}