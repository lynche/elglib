package Elegant.utils 
{
	import Elegant.debug.Debug;
	import Elegant.ELGManager;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.describeType;
	
	/**
	 * 加上ctrl或者alt后经常性不好使............╮(╯▽╰)╭
	 * 额...原来是被浏览器劫持了
	 * @author 浅唱
	 * @copyright myjob.liu@foxmail.com
	 * @version 1.0
	 */
	public final class KeyboardListener 
	{
		private static var _instance:KeyboardListener;
		
		public static const CTRL:String = "ctrl";
		public static const SHIFT:String = "shift";
		public static const ALT:String = "alt";
		
		private static const CTRL_REG:RegExp = new RegExp(CTRL + "\\s*" + "\\+\\s*");
		private static const SHIFT_REG:RegExp = new RegExp(SHIFT + "\\s*" + "\\+\\s*");
		private static const ALT_REG:RegExp = new RegExp(ALT + "\\s*" + "\\+\\s*");
		
		/**
		 * 存放侦听器的数组
		 */
		private var listenerHash:HashMap;
		/**
		 * 存放侦听器的数组,用于keyUp事件
		 */
		private var upListenerHash:HashMap;
		
		/**
		 * 只是为了方便添加键盘事件的侦听
		 * 不需要你来实例化的
		 */
		public function KeyboardListener() 
		{
			listenerHash = new HashMap(true, KeyBoardCell);
			upListenerHash = new HashMap(true, KeyBoardCell);
			ELGManager.getInstance.mainShowContainer.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyUpDownHandler);
			ELGManager.getInstance.mainShowContainer.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUpDownHandler);
			ELGManager.getInstance.addToDispose(this, dispose);
		}
		
		/**
		 * 销毁
		 */
		private function dispose():void 
		{
			ELGManager.getInstance.mainShowContainer.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyUpDownHandler);
			ELGManager.getInstance.mainShowContainer.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUpDownHandler);
			_instance.listenerHash.reputHash(true);
			_instance.upListenerHash.reputHash(true);
			_instance.listenerHash = _instance.upListenerHash = null;
			_instance = null;
		}
		
		//--------Event Handler------------------------
		/**
		 * 键盘按下事件
		 * @param	e
		 */
		private function onKeyUpDownHandler(e:KeyboardEvent):void 
		{
			var keyStr:String = "";

			keyStr += e.ctrlKey ? CTRL + " + " : "";
			keyStr += e.shiftKey ? SHIFT + " + " : "";
			keyStr += e.altKey ? ALT + " + " : "";
			keyStr += e.keyCode;
			
			var lishash:HashMap = (e.type == "keyDown" ? listenerHash : upListenerHash);
			if (!lishash.has(keyStr)) return;
			var listeners:Array = lishash.get(keyStr).listeners;
			
			if (listeners)
			{
				for each (var i:* in listeners) 
				{
					i.call(null, e);
				}
			}
		}
		
		//--------Static Function------------------------
		/**
		 * 添加侦听
		 * 如 ctrl + e
		 * 如 e
		 * ...
		 * @param	trigger
		 * @param	listener
		 * @param	isKeyDown 键盘按下时触发还是
		 */
		public static function addKeyBoardListener(trigger:String, listener:Function, isKeyDown:Boolean = true):void
		{
			trigger = reputTrigger(trigger);
			
			Debug.append("KeyboardListener 添加键盘侦听: " + trigger);
			//是否初始化
			_instance ||= new KeyboardListener();
			
			var lishash:HashMap = isKeyDown ? _instance.listenerHash : _instance.upListenerHash;
			var tempCell:KeyBoardCell = lishash.get(trigger);
			if (tempCell == null) tempCell = new KeyBoardCell();
			tempCell.listeners.push(listener);
			_instance.listenerHash.add(trigger, tempCell);
		}
		
		/**
		 * 移除侦听
		 * @param	trigger
		 * @param	listener
		 */
		public static function removeKeyBoardListener(trigger:String, listener:Function, isKeyDown:Boolean = true):void
		{
			trigger = reputTrigger(trigger);
			
			var lishash:HashMap = isKeyDown ? _instance.listenerHash : _instance.upListenerHash;
			var tempCell:KeyBoardCell = lishash.get(trigger);
			tempCell.listeners.splice(tempCell.listeners.indexOf(listener), 1);
			if (tempCell.listeners.length == 0) _instance.listenerHash.reduce(trigger);
			if (_instance.listenerHash.length == 0) _instance.dispose();
		}
		
		/**
		 * 是否有此侦听
		 * @param	trigger
		 * @param	listener	如果该值为Null,则返回所有trigger值是否有被侦听
		 */
		public static function hasKeyBoardListener(trigger:String, listener:Function = null, isKeyDown:Boolean = true):Boolean
		{
			if (!_instance) return false;
			
			trigger = reputTrigger(trigger);
			var lishash:HashMap = isKeyDown ? _instance.listenerHash : _instance.upListenerHash;
			var tempCell:KeyBoardCell = lishash.listenerHash.get(trigger);
			if (listener == null) return tempCell != null;
			else return (tempCell != null) && (tempCell.listeners.indexOf(listener) != -1);
		}
		
		/**
		 * 
		 * @param	trigger
		 * @return
		 */
		private static function reputTrigger(trigger:String):String
		{
			//小写全部
			trigger = trigger.toLowerCase();
			//匹配ctrl shift alt
			var ctrl:String = trigger.search(KeyboardListener.CTRL_REG) >= 0 ? "ctrl + " : "";
			var shift:String = trigger.search(KeyboardListener.SHIFT_REG) >= 0 ? "shift + " : "";
			var alt:String = trigger.search(KeyboardListener.ALT_REG) >= 0 ? "alt + " : "";
			//过滤掉ctrl shift alt
			trigger = trigger.replace(KeyboardListener.CTRL_REG, "").replace(KeyboardListener.SHIFT_REG, "").replace(KeyboardListener.ALT_REG, "");
			
			var code:int = isNaN(Number(trigger)) ? trigger.toUpperCase().charCodeAt(0) : int(trigger);
			trigger = code + "";
			
			trigger = ctrl + shift + alt + trigger;
			return trigger;
		}
		
		//--------getter / setter------------------------
		/**
		 * 不解释
		 * @return Keyboard
		 */
		public static function get getInstance():KeyboardListener 
		{
			return _instance;
		}
		
	}
}
class KeyBoardCell
{
	public var listeners:Array = [];
}