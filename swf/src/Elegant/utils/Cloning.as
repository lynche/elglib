package Elegant.utils
{
	import flash.display.DisplayObjectContainer;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	
	/**
	 * 复制属性值或者存取器的值
	 * @author 浅唱
	 */
	public final class Cloning
	{
		private static var mcGetterArray:Array = ["trackAsMenu", "enabled"]
		
		public function Cloning()
		{
		
		}
		
		/**
		 * 复制属性以及存取器的值,除了...except指定的值
		 * @param	from
		 * @param	to
		 * @param	except	排除字段名称(字符串)
		 * @return
		 */
		public static function cloneAll(from:*, to:*, except:Array = null):*
		{
			return cloneVariable(from, cloneAccessor(from, to, except), except);
		}
		
		/**
		 * 从from处复制存取器值到to上,并返回to(只写或只读属性不可被复制)
		 * @param	tar
		 * @param	to
		 * @param	except	排除字段名称(字符串)
		 * @return
		 */
		public static function cloneAccessor(from:*, to:*, except:Array = null):*
		{
			if(except == null)
				except = [];
			
			except = except.concat(mcGetterArray);
			var xml:XML = describeType(from);
			var accessor:XMLList = xml..accessor;
			
			for each (var item:XML in accessor) 
			{
				var name:String = item.@name;
				if(item.@access == "readwrite" && except.indexOf(name) == -1)
				{
					to[name] = from[name];
				}
			}
			return to;
		}
		
		/**
		 * 从from处复制变量值到to上,并返回to(只可复制public方法)
		 * @param	tar
		 * @param	to
		 * @param	except	排除字段名称(字符串)
		 * @return
		 */
		public static function cloneVariable(from:*, to:*, except:Array = null):*
		{
			if(except == null)
				except = [];
			
			except = except.concat(mcGetterArray);
			var xml:XML = describeType(from);
			var variable:XMLList = xml..variable;
			
			for each (var item:XML in variable) 
			{
				var name:String = item.@name;
				if(except.indexOf(name) == -1)
				{
					to[name] = from[name];
				}
			}
			return to;
		}
		
		/**
		 * 将from中的一些属性赋值给to
		 * @param	form
		 * @param	to
		 * @param	some
		 * @return
		 */
		public static function cloneSomeVars(form:*, to:*, some:Array):*
		{
			for each (var vars:* in some) 
			{
				to[vars] = form[vars];
			}
			return to;
		}
		
		/**
		 * 复制对象
		 * 可惜的是只能复制简单对象
		 * 如array这样的
		 * @param obj
		 * @return
		 */
		public static function clone(obj:*):*
		{
			var byte:ByteArray = new ByteArray();
			byte.writeObject(obj);
			byte.position = 0;
			return byte.readObject();
		}
		
		/**
		 * 把from的子元件添加到to当中
		 * @param	from
		 * @param	to
		 * @return
		 */
		public static function convertChildren(from:DisplayObjectContainer, to:DisplayObjectContainer):DisplayObjectContainer
		{
			while(from.numChildren > 0)
			{
				to.addChild(from.removeChildAt(0));
			}
			return to;
		}
	}
}