package Elegant.utils
{
	import flash.utils.Dictionary;
	import flash.utils.flash_proxy;
	import flash.utils.getDefinitionByName;
	import flash.utils.Proxy;
	
	/**
	 * 哈希表
	 * 支持直接.语法添加与删除对象
	 * 目前不具备真正的HashMap功能...也不打算写了
	 * 够我自己用^^
	 * @author 浅唱
	 */
	public dynamic final class HashMap extends Proxy
	{
		private var hashDic:Dictionary;
		private var _length:int = 0;
		/**
		 * 限制,限制该哈希表中只能存储restrict给定的类型的值
		 */
		public var restrict:Class;
		
		/**
		 * 哈希表
		 * @param	weakKeys	是否使用弱引用
		 * @param	_restrict	限制,限制该哈希表中只能存储restrict给定的类型的值
		 */
		public function HashMap(weakKeys:Boolean = false, _restrict:Class = null)
		{
			hashDic = new Dictionary(weakKeys);
			restrict = _restrict;
		}
		
		/**
		 * 添加键值到哈希表
		 * @param	key
		 * @param	value
		 * @return	如果key以前有值的话会返回该值,
		 */
		public function add(key:*, value:*):*
		{
			if (restrict && !(value is restrict))
				throw new ArgumentError("参数value值必须为 " + restrict + " 类型");
			
			var temp:* = get(key);
			if (temp == null)
			{
				_length += 1;
			}
			hashDic[key] = value;
			return temp;
		}
		
		/**
		 * 从哈希表中删除键值,并返回key对应的值
		 * @param	key
		 * @return	key对应的值
		 */
		public function reduce(key:*):*
		{
			var temp:* = hashDic[key];
			if (temp)
			{
				_length -= 1;
				delete hashDic[key];
			}
			return temp;
		}
		
		/**
		 * 使用名称前缀+哈希表长度的方式存储值
		 * @param	value	值
		 * @param	namePrefix	名称前缀
		 * @return	新的长度
		 */
		public function push(value:*, namePrefix:String = ""):int
		{
			add(namePrefix + _length, value);
			return _length;
		}
		
		/**
		 * 返回哈希表中是否有这个key
		 * @param	key
		 * @return
		 */
		public function has(key:*):Boolean
		{
			return (hashDic[key] != undefined)
		}
		
		/**
		 * 通过key获取值
		 * @param	key
		 * @return	key对应的值
		 */
		public function get(key:*):*
		{
			return hashDic[key];
		}
		
		/**
		 * Call func(key) for each key.
		 * @param func the function to call
		 */
		public function eachKey(func:Function, extreParams:Array = null):void
		{
			extreParams ||= [];
			for (var i:* in hashDic)
			{
				var arr:Array = [i].concat(extreParams);
				func.apply(null, arr);
			}
		}
		
		/**
		 * Call func(value) for each value.
		 * @param func 调用的方法
		 */
		public function eachValue(func:Function, extreParams:Array = null):void
		{
			extreParams ||= [];
			for each (var i:* in hashDic)
			{
				var arr:Array = [i].concat(extreParams);
				func.apply(null, arr);
			}
		}
		
		/**
		 * 收集每一个对象的方法返回值或者属性并返回
		 * @param	attribute	属性名称或方法名称
		 * @param	funcMode	如果funcMode为<code>true</code>,则为调用方法,否则收集其属性,默认为<code>false</code>
		 * @param	funcParams	funcMode为<code>true</code>时有效,调用方法时的参数
		 * @return	Array 调用的方法或者属性返回的值的集合
		 */
		public function eachAttribute(attribute:String, funcMode:Boolean = false, funcParams:Array = null):Array
		{
			var tempArr:Array = [];
			var i:* = null;
			//如果是调用方法
			if (funcMode)
			{
				switch (attribute)
				{
					//如果是直接调用apply或者call方法,则调用apply
					case "apply": 
					case "call": 
						for each (i in hashDic)
						{
							if (i is Function)
								tempArr.push(i["apply"](null, funcParams));
						}
						break;
					//否则,对attribute指定方法调用apply方法
					default: 
						for each (i in hashDic)
						{
							tempArr.push(i[attribute]["apply"](null, funcParams));
						}
				}
			}
			else
			{
				for each (i in hashDic)
				{
					tempArr.push(i[attribute]);
				}
			}
			return tempArr;
		}
		
		/**
		 * Returns an Array of the values in this HashMap.
		 */
		public function getValues():Array
		{
			var temp:Array = new Array(length);
			var index:int = 0;
			for each (var i:*in hashDic)
			{
				temp[index] = i;
				index++;
			}
			return temp;
		}
		
		/**
		 * Returns an Array of the keys in this HashMap.
		 */
		public function getKeys():Array
		{
			var temp:Array = new Array(length);
			var index:int = 0;
			for (var i:* in hashDic)
			{
				temp[index] = i;
				index++;
			}
			return temp;
		}
		
		/**
		 * Clears this HashMap so that it contains no keys no values.
		 */
		public function reputHash(toNull:Boolean = false, weakKeys:Boolean = true):void
		{
			eachKey(reduce);
			
			if (toNull)
				hashDic = null;
			else
				hashDic = new Dictionary(weakKeys);
		}
		
		/**
		 * Return a same copy of HashMap object
		 */
		public function clone():HashMap
		{
			var temp:HashMap = new HashMap();
			for (var i:* in hashDic)
			{
				temp.add(i, hashDic[i]);
			}
			return temp;
		}
		
		public function getDict():Dictionary
		{
			return hashDic;
		}
		
		public function toString():String
		{
			var keys:Array = getKeys();
			var values:Array = getValues();
			var str:String = "";
			for (var i:int = 0; i < keys.length; i += 1)
			{
				str += "Keys: " + keys[i] + " Values:" + values[i] + "\n";
			}
			return str;
		}
		
		/**
		 * @return 返回哈希表的长度
		 */
		public function get length():int
		{
			return _length;
		}
		
		/**
		 * @private
		 */
		override flash_proxy function setProperty(name:*, value:*):void
		{
			add(name, value);
		}
		
		/**
		 * @private
		 */
		override flash_proxy function deleteProperty(name:*):Boolean
		{
			return reduce(name) == null;
		}
		
		/**
		 * @private
		 */
		override flash_proxy function getProperty(name:*):*
		{
			return get(name);
		}
		
		/**
		 * @private
		 */
		override flash_proxy function hasProperty(name:*):Boolean
		{
			return has(name);
		}
	}
}