package Elegant
{
	import Elegant.controls.Alert;
	import Elegant.graphicUI.AlertGUI;
	import Elegant.manager.PopUpManager;
	import Elegant.utils.core.Singleton;
	import Elegant.utils.HashMap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ELGFLA的管理,用于初始化以及销毁
	 * @author 浅唱
	 */
	public final class ELGManager
	{
		/**
		 * 获取ELGMAnager的舞台(不一定是Stage,可以是任何DisplayObjectContainer)
		 * 主要用于PopupManager
		 */
		public var mainShowContainer:DisplayObjectContainer;
		public static var stage:Stage;
		
		private var disposeDic:HashMap;
		private var groupDic:HashMap;
		private var pool:HashMap; //废弃对象池
		private static var _instance:ELGManager;
		
		public function ELGManager(sin:Single)
		{
			if (sin == null)
				throw new ArgumentError("错误的参数,单例模式");
		}
		
		/**
		 * 不解释
		 */
		public static function get getInstance():ELGManager
		{
			if (_instance == null)
			{
				throw Error("请首先调用ELGManager的init方法初始化");
			}
			return _instance;
		}
		
		/**
		 * 是否已经初始化
		 * @return
		 */
		public static function hasInit():Boolean
		{
			return _instance != null;
		}
		
		/**
		 * 由此开始初始化,这将帮助你初始化ELG一切必要的东西
		 * @param	_MainShowContainer
		 * @param	alertConstructor String 或 Class
		 */
		public static function init(_MainShowContainer:DisplayObjectContainer, alertConstructor:* = null):void
		{
			_instance = new ELGManager(new Single);
			_instance.disposeDic = new HashMap();
			_instance.disposeDic.restrict = Function;
			_instance.groupDic = new HashMap();
			_instance.pool = new HashMap();
			
			_instance.mainShowContainer = _MainShowContainer;
			stage = _MainShowContainer.stage;
			PopUpManager.init();
			
			if (!alertConstructor)
				Alert.alertConstructor = AlertGUI;
			if (alertConstructor is String)
				Alert.alertConstructor = ApplicationDomain.currentDomain.hasDefinition(alertConstructor) ? (ApplicationDomain.currentDomain.getDefinition(alertConstructor) as Class) : null;
			else if (alertConstructor is Class)
				Alert.alertConstructor = alertConstructor;
			
			getInstance.addToDispose(Singleton, Singleton.disposeAll);
		}
		
		/*****************************************销毁相关**********************************/ /**
		 * 添加入你想要在调用DisposeAll时销毁的对象的销毁方法
		 * 虽然key为*号类型,但这里推荐使用对象本身作为key
		 * 
		 * 若对象已经加入到了dispose中又想加入group,可以参数func为null,但group不为null
		 * @param	key
		 * @param	func
		 * @see Elegant.utils.HashMap#add()
		 */
		public function addToDispose(key:*, func:Function, group:String = null):void
		{
			if (func == null)
			{
				if (group == null)
					return;
				else if (!disposeDic.has(key))
					return;
				else
					func = disposeDic.get(key);
			}
			disposeDic.add(key, func);
			if (group)
			{
				if (!groupDic.has(group))
					groupDic.add(group, []);
				groupDic.get(group).push(key);
			}
		}
		
		/**
		 * @param	key
		 * @return 字典中是否有该键值
		 * @see Elegant.utils.HashMap#has()
		 */
		public function hasInDispose(key:*):Boolean
		{
			return disposeDic.has(key);
		}
		
		/**
		 * 从销毁列表中删除某项,但是不调用他的销毁方法
		 * @param	key
		 * @see Elegant.utils.HashMap#reduce()
		 */
		public function removeFromDispose(key:*):Function
		{
			if (disposeDic == null)
				return null;
			return disposeDic.reduce(key);
		}
		
		/**
		 * @return 获取销毁字典的长度
		 * @see Elegant.utils.HashMap#length
		 */
		public function getDicLength():int
		{
			return disposeDic.length;
		}
		
		/**
		 * 销毁某个对象
		 * 无论是否层加入过dispose,只要调用此方法并且addToPool为true,就会将其加入废弃对象池
		 * @param	key
		 * @param	addToPool	是否将对象加入到废弃对象池,以便以后再次使用
		 */
		public function disposeSome(key:*, addPool:Boolean = false):void
		{
			var func:Function = removeFromDispose(key);
			if (func != null)
				func.apply();
			
			if (addPool)
				addToPool(key);
		}
		
		/**
		 * 销毁对象组
		 * @param	key
		 */
		public function disposeGroup(group:String, addToPool:Boolean = false):void
		{
			var arr:Array = groupDic.get(group);
			if (arr)
			{
				for (var i:int = 0; i < arr.length; i++)
				{
					disposeSome(arr[i], addToPool);
				}
				groupDic.reduce(group);
			}
		}
		
		/**
		 * 使用哈希表的长度加名称后缀作为键值确保没有重复key
		 * @param	func	销毁对象的方法
		 * @param	namePrefix	key值前缀
		 * @see Elegant.utils.HashMap#push()
		 */
		public function pushToDispose(func:Function, namePrefix:String = ""):void
		{
			if (func == null)
				return;
			disposeDic.push(func, namePrefix);
		}
		
		/**
		 * 销毁全部由ELG创造的类
		 */
		public function disposeAll():void
		{
			disposeDic.eachAttribute("apply", true);
			disposeDic.reputHash(true);
			disposeDic = null;
			groupDic.reputHash(true);
			groupDic = null;
			pool = null;
			mainShowContainer = null;
			_instance = null;
			Alert.alertConstructor = null;
		}
		
		/**
		 * 加入到对象池
		 * @param	any
		 */
		public function addToPool(any:*):void
		{
			var arr:Array = pool.get(any.constructor);
			if (arr == null)
			{
				arr = [];
				pool.add(any.constructor, arr);
			}
			
			if (arr.indexOf(any) == -1)
			{
				arr[arr.length] = any;
			}
		}
		
		/**
		 * 加入到对象池
		 * @param	any
		 */
		public function destroyPool(any:*):void
		{
			if (pool.has(any.constructor))
			{
				pool.reduce(any.constructor);
			}
		}
		
		/**
		 * 从废弃对象池中获取对象
		 * 如果没有废弃对象,且creatNew为true, 则返回新的对象
		 * 如果没有废弃对象,且creatNew为false, 则返回null
		 * @param	ref
		 * @param	creatNew
		 * @return
		 */
		public function getInstanceFromPool(ref:Class, creatNew:Boolean = false):*
		{
			var arr:Array = pool.get(ref);
			if (arr != null && arr.length > 0)
			{
				return arr.pop();
			}
			else
			{
				if (creatNew)
					return new ref();
				else
					return null;
			}
		}
		
		/**
		 * 获取某类池中对象的数量
		 * @param	ref
		 * @return
		 */
		public function getPoolLength(ref:Class):int
		{
			var arr:Array = pool.get(ref);
			if (arr != null)
			{
				return arr.length;
			}
			return 0;
		}
		
		/**
		 * 获取某类池
		 * @param	ref
		 * @return
		 */
		public function getPool(ref:Class):Array
		{
			var arr:Array = pool.get(ref);
			if (arr != null)
			{
				return arr;
			}
			return null;
		}
	}
}

class Single
{
}