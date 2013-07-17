package Elegant.utils
{
	
	/**
	 * 来自AWAY3D中的Init
	 * 额...稍作修改
	 * @author 浅唱
	 * @copyright myjob.liu@foxmail.com
	 * @version 1.0
	 */
	public class InitObject
	{
		public static var autoDelete:Boolean = true;
		
		public function InitObject()
		{
		
		}
		
		public static function getArray(_init:Object, name:String, def:Array = null):Array
		{
			if (_init == null)
				return def;
			
			if (!(name in _init))
				return def;
			
			var result:Array = _init[name];
			
			if (autoDelete)
				delete _init[name];
			
			return result;
		}
		
		public static function getInt(_init:Object, name:String, def:int, bounds:Object = null):int
		{
			if (_init == null)
				return def;
			
			if (!(name in _init))
				return def;
			
			var result:int = _init[name];
			
			if (bounds != null)
			{
				var min:int;
				var max:int;
				if ("min" in bounds)
				{
					min = bounds["min"];
					if (result < min)
						result = min;
				}
				if ("max" in bounds)
				{
					max = bounds["max"];
					if (result > max)
						result = max;
				}
			}
			
			if (autoDelete)
				delete _init[name];
			
			return result;
		}
		
		public static function getUint(_init:Object, name:String, def:uint, bounds:Object = null):uint
		{
			if (_init == null)
				return def;
			
			if (!(name in _init))
				return def;
			
			var result:uint = _init[name];
			
			if (bounds != null)
			{
				if ("min" in bounds)
				{
					var min:uint = bounds["min"];
					if (result < min)
						result = min;
				}
				if ("max" in bounds)
				{
					var max:uint = bounds["max"];
					if (result > max)
						result = max;
				}
			}
			
			if (autoDelete)
				delete _init[name];
			
			return result;
		}
		
		public static function getNumber(_init:Object, name:String, def:Number, bounds:Object = null):Number
		{
			if (_init == null)
				return def;
			
			if (!(name in _init))
				return def;
			
			var result:Number = _init[name];
			
			if (bounds != null)
			{
				if ("min" in bounds)
				{
					var min:Number = bounds["min"];
					if (result < min)
						result = min;
				}
				if ("max" in bounds)
				{
					var max:Number = bounds["max"];
					if (result > max)
						result = max;
				}
			}
			
			if (autoDelete)
				delete _init[name];
			
			return result;
		}
		
		public static function getString(_init:Object, name:String, def:String = null):String
		{
			if (_init == null)
				return def;
			
			if (!(name in _init))
				return def;
			
			var result:String = _init[name];
			
			if (autoDelete)
				delete _init[name];
			
			return result;
		}
		
		public static function getBoolean(_init:Object, name:String, def:Boolean = false):Boolean
		{
			if (_init == null)
				return def;
			
			if (!(name in _init))
				return def;
			
			var result:Boolean = _init[name];
			
			if (autoDelete)
				delete _init[name];
			
			return result;
		}
		
		public static function getObject(_init:Object, name:String, def:Object = null, type:Class = null):Object
		{
			if (_init == null)
				return def;
			
			if (!(name in _init))
				return def;
			
			var result:Object = _init[name];
			
			if (autoDelete)
				delete _init[name];
			
			if (result == null)
				return def;
			
			if (type != null)
			{
				if (!(result is type))
					throw new Error("Parameter \"" + name + "\" is not of class " + type + ": " + result);
			}
			return result;
		}
	}

}