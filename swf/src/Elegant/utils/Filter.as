package Elegant.utils
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	import flash.filters.*;
	/**
	 * 应用滤镜
	 * @author 浅唱
	 */
	public final class Filter
	{
		public static const BEVELEFILTER:String = "BevelFilter";
		public static const BLURFILTER:String = "BlurFilter";
		public static const DROPSHADOWFILTER:String = "DropShadowFilter";
		public static const GLOWFILTER:String = "GlowFilter";
		public static const GRADIENTBEVELFILTER:String = "GradientBevelFilter";
		public static const GRADIENTGLOWFILTER:String = "GradientGlowFilter";
		public static const COLORMATRIXFILTER:String = "ColorMatrixFilter";
		public static const CONVOLUTIONFILTER:String = "ConvolutionFilter";
		public static const DISPLACEMENTMAPFILTER:String = "DisplacementMapFilter";
		
		//置灰
		public static const gray:ColorMatrixFilter = new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0]);
		
		//变暗
		public static const dark:ColorMatrixFilter = new ColorMatrixFilter([1, 0, 0, 0, -75, 0, 1, 0, 0, -75, 0, 0, 1, 0, -75, 0, 0, 0, 1, 0]);
		
		//描边
		public static const flowerer:GlowFilter = new GlowFilter(0x000000, 1, 2, 2, 10, 1, false, false);
		
		public function Filter() 
		{
			
		}
		/**
		 * 为对象添加滤镜
		 * @param	tar
		 * @param	filterType
		 * @param	params
		 * @example setFilter(tar,Filter.BLURFILTER,{blurX:20,blurY:10});
		 */
		public static function setFilter(tar:DisplayObject, filterType:String, params:Object):void
		{
			if (hasFilter(tar, filterType)) return;
			var filter:* = new (getDefinitionByName("flash.filters."+filterType) as Class)();
			
			if (params)
			{
				for (var i:* in params)
				{
					filter[i] = params[i];
				}
			}
			
			if (tar.filters != null) 
			{
				var arr:Array = tar.filters;
				arr.push(filter);
				tar.filters = arr;
				arr = null;
			}
			else { tar.filters = [filter]; }
			
			filter = null;
		}
		/**
		 * 删除滤镜
		 * @param	tar
		 * @param	filterType
		 * @return  删除相应滤镜后对象滤镜数组
		 */
		public static function unSetFilter(tar:DisplayObject, filterType:String):Array
		{
			if (tar.filters != null)
			{
				var clas:Class = getDefinitionByName("flash.filters." + filterType) as Class;
				for (var i:int = 0; i < tar.filters.length; i += 1)
				{
					if (tar.filters[i] is clas)
					{
						clas = null;
						var arr:Array = tar.filters;
						arr.splice(i, 1);
						tar.filters = arr;
						break;
					}
				}
				clas = null;
			}
			return tar.filters;
		}
		/**
		 * 置灰
		 * @param	tar
		 */
		public static function setToGray(tar:DisplayObject):void
		{
			if (hasFilter(tar, COLORMATRIXFILTER)) return;
			if (tar.filters != null)
			{
				var arr:Array = tar.filters;
				arr.push(Filter.gray);
				tar.filters = arr;
				arr = null;
			}
			else { tar.filters = [Filter.gray]; }
		}
		/**
		 * 置暗
		 * @param	tar
		 */
		public static function setToDark(tar:DisplayObject):void
		{
			if (tar.filters != null)
			{
				var arr:Array = tar.filters;
				arr.push(Filter.dark);
				tar.filters = arr;
				arr = null;
			}
			else { tar.filters = [Filter.dark]; }
		}
		/**
		 * 取消COLORMATRIXFILTER滤镜
		 * @param	tar
		 */
		public static function unGray(tar:DisplayObject):void
		{
			unSetFilter(tar, COLORMATRIXFILTER);
		}
		/**
		 * 是否有某种滤镜
		 * @param	tar
		 * @param	filterType
		 * @return
		 */
		public static function hasFilter(tar:DisplayObject, filterType:String):Boolean
		{
			if (tar.filters.length == 0) return false;
			
			var clas:Class = getDefinitionByName("flash.filters." + filterType) as Class;
			for (var i:int = 0; i < tar.filters.length; i += 1)
			{
				if (tar.filters[i] is clas)
				{
					clas = null;
					return true;
				}
			}
			return false;
		}
		/**
		 * 清除所有滤镜
		 * @param	tar
		 */
		public static function clearFilter(tar:DisplayObject):void
		{
			tar.filters = [];
		}
	}
}