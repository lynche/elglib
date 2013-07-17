package Elegant.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * 清除子元件
	 * @author 浅唱
	 */
	public class ChildrenKiller
	{
		
		public function ChildrenKiller()
		{
		
		}
		
		/**
		 * 清除子元件
		 * @param	tar
		 * @param	clearAll
		 * @return
		 */
		public static function kill(tar:DisplayObjectContainer, clearAll:Boolean=false):int
		{
			if (tar)
			{
				while (tar.numChildren > 0)
				{
					if (clearAll)
					{
						var son:DisplayObject = tar.getChildAt(0);
						if (son is DisplayObjectContainer)
							kill(DisplayObjectContainer(son), true);
					}
					tar.removeChildAt(0);
				}
				return tar.numChildren;
			}
			return 0;
		}
	}

}