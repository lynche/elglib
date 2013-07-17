package Elegant.utils.core
{
	import Elegant.utils.HashMap;
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 此类是一个统一的单例实现
	 *
	 * @author flashyiyi
	 *
	 */
	public class Singleton extends EventDispatcher
	{
		private static var dict:HashMap;
		
		public function Singleton()
		{
			throw IllegalOperationError("实例化我干嘛= =!");
		}
		
		/**
		 * 扔掉所有单例存放
		 */
		public static function disposeAll():void
		{
			dict.reputHash(true);
			dict = null;
		}
		
		/**
		 * 丢弃某个类的实例
		 * @param	ref
		 */
		public static function disposeSome(ref:Class):void
		{
			dict.reduce(ref);
		}
		
		/**
		 * 获取单例类，若不存在则返回空
		 *
		 * @param ref	继承自Singleton的类
		 * @return
		 *
		 */
		public static function getInstance(ref:Class):*
		{
			dict  ||= new HashMap();
			return dict.get(ref);
		}
		
		/**
		 * 获取单例类，若不存在则创建
		 *
		 * @param ref	继承自Singleton的类
		 * @return
		 *
		 */
		public static function getInstanceOrCreate(ref:Class):*
		{
			dict ||= new HashMap();
			if (!dict.has(ref))
				dict.add(ref, new ref());
			
			return dict.get(ref);
		}
		
		/**
		 * 创建单例类，若已创建则报错
		 *
		 * @param ref	继承自Singleton的类
		 * @return
		 *
		 */
		public static function create(ref:Class):*
		{
			dict ||= new HashMap();
			var t:* = new ref();
			dict.add(ref, new ref());
			return t;
		}
	}
}