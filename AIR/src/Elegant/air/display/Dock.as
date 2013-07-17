package Elegant.air.display
{
	import Elegant.ELGManager;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemTrayIcon;
	import flash.display.NativeWindow;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.NativeWindowDisplayState;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowDisplayStateEvent;
	
	public class Dock extends EventDispatcher
	{
		public static var toolTip:String = "ElgLib Author 浅唱"; 
		
		private var dockImages:BitmapData;
		private var window:NativeWindow;
		private var menuItem:Array;
		
		public function Dock(dockImages:BitmapData, menuItem:Array)
		{
			// constructor code
			window = ELGManager.getInstance.mainShowContainer.stage.nativeWindow;
			this.dockImage = dockImage;
			this.menuItem = menuItem;
			prepareForSystray();
		}
		
		/**
		 * 设置基本属性。
		 * @Author: S.Radovanovic
		 */
		private function prepareForSystray():void
		{
			// windows 支持系统托盘图标， 苹果系统同样也支持， 上网可以找到相应的方法
			if(NativeApplication.supportsSystemTrayIcon)
			{
				setSystemTrayProperties();
				// 设置系统托盘菜单           
				SystemTrayIcon(NativeApplication.nativeApplication.icon).menu = createSystrayRootMenu();
			}
		}
		
		/**
		 * 创建系统托盘菜单
		 *
		 * @Author: S.Radovanovic
		 */
		private function createSystrayRootMenu():NativeMenu
		{
			// 添加菜单元件，每个元件响应相应的方法
			var menu:NativeMenu = new NativeMenu();
			var openNativeMenuItem:NativeMenuItem = new NativeMenuItem("恢复");
			var exitNativeMenuItem:NativeMenuItem = new NativeMenuItem("退出");
			// 当用户双击元件时发生的事件
			openNativeMenuItem.addEventListener(Event.SELECT, undock);
			exitNativeMenuItem.addEventListener(Event.SELECT, closeApp);
			// 把菜单元件添加到菜单中;
			menu.addItem(openNativeMenuItem);
			menu.addItem(new NativeMenuItem("", true));
			menu.addItem(exitNativeMenuItem);
			
			var item:NativeMenuItem;
			for (var i:int = 0; i < menuItem.length; i += 1) 
			{
				item = new NativeMenuItem(menuItem[i], Boolean(menuItem[i]));
				menu.addItem(item);
			}
			
			return menu;
		}
		
		/**
		 * 设置隐藏和激活的一些事件侦听
		 *
		 * @Author: S.Radovanovic
		 */
		private function setSystemTrayProperties():void
		{
			// 当鼠标悬停在系统托盘图标上时显示文字。       
			SystemTrayIcon(NativeApplication.nativeApplication.icon).tooltip = toolTip;
			// 双击系统托盘图标打开程序
			SystemTrayIcon(NativeApplication.nativeApplication.icon).addEventListener(MouseEvent.CLICK, undock);
			// 侦听窗口显示状态的改变，这样就可以捕获最小化事件     ;
			window.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING, nwMinimized);
		}
		
		//捕获最小化事件;
		/**
		 * 窗口的状态改变时执行合适的动作。
		 * 当用户点击最小化按钮，隐藏程序到系统托盘
		 *
		 * @Author: S.Radovanovic
		 */
		private function nwMinimized(displayStateEvent:NativeWindowDisplayStateEvent):void
		{
			if(displayStateEvent.afterDisplayState == NativeWindowDisplayState.MINIMIZED)
			{
				displayStateEvent.preventDefault();
				// 当按下最小化按钮是，要阻止默认的最小化发生;
				dock();
			}
		}
		
		/**
		 * 在系统托盘中显示程序图标
		 * @Author: S.Radovanovic
		 */
		public function dock():void
		{
			// 隐藏当前窗口
			window.visible = false;
			// 设置 bitmaps 数组，在系统托盘中显示程序图标。
			NativeApplication.nativeApplication.icon.bitmaps = [dockImage];
			dispatchEvent(new Event("DOCK"));
		}
		
		/**
		 * 重新显示程序窗口
		 * @Author: S.Radovanovic
		 */
		public function undock(evt:Event):void
		{
			// 把窗口设置为可见， 并确保程序在最前端。
			window.visible = true;
			window.orderToFront();
			dispatchEvent(new Event("UNDOCK"));
			// 清空 bitmaps 数组，同时清空了系统托盘中的程序图标。;
			//NativeApplication.nativeApplication.icon.bitmaps=[];
		}
		
		//关闭程序
		private function closeApp(evt:Event):void
		{
			window.close();
		}
	}
}