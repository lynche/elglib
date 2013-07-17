package Elegant.utils 
{
	import flash.display.InteractiveObject;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	/**
	 * 懒得写了............
	 * @author 浅唱
	 * @version 1.0
	 */
	public class CustomContextMenu 
	{
		/**
		 * 
		 * @param	target
		 * @param	items
		 * @param	hideBuildInItem
		 */
		public static function setContextMenu(target:InteractiveObject, items:Array, hideBuildInItem:Boolean = true):void
		{
			var contextMenu:ContextMenu = target.contextMenu;
			(contextMenu == null) && (contextMenu = new ContextMenu());
			hideBuildInItem && contextMenu.hideBuiltInItems();
			
			var item:ContextMenuItem;
			var menu:Array = [];
			var nextSeparator:Boolean = false;
			for (var i:int = 0; i < items.length; i += 1) 
			{
				if(items[i])
				{
					item = new ContextMenuItem(items[i], nextSeparator);
					nextSeparator = false;
				}
				else 
					nextSeparator = true;
				menu[i] = item;
			}
			contextMenu.customItems = menu;
			target.contextMenu = contextMenu;
		}
	}

}