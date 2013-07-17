package Elegant.controls 
{
	import Elegant.config.ELGFla;
	import Elegant.display.FLASkinContainer;
	import Elegant.ELGManager;
	import Elegant.events.PopUpEvent;
	import Elegant.interfaces.IHasLabel;
	import Elegant.manager.PopUpManager;
	import Elegant.utils.InitObject;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author 浅唱
	 * @copyright 513151217@qq.com
	 * @version 1.0
	 */
	public class Alert extends FLASkinContainer 
	{
		ELGFla static const className:String = "Alert";
		
		/**
		 * Alert 背景命名
		 */
		ELGFla static const ALERT_BG:String = "DIS_Alert_Bg";
		/**
		 * Alert 按钮命名
		 */
		ELGFla static const ALERT_BT:String = "HASLABEL_Alert_Bt";
		/**
		 * Alert 文本框命名
		 */
		ELGFla static const ALERT_LABEL:String = "TXF_Alert_Label";
		/**
		 * Alert 标题文本命名
		 */
		ELGFla static const ALERT_TITLE_LABEL:String = "TXF_Alert_title";
		
		/**
		 * 弹出框的按钮(必须)
		 */
		public static var alertBt:Class;
		/**
		 * 弹出框的背景(必须)
		 */
		protected var _alertBg:DisplayObject;
		/**
		 * 弹出框的文本(必须)
		 */
		protected var _label:TextField;
		/**
		 * 弹出框的标题文本
		 */
		protected var _title:TextField;
		/**
		 * 关闭按钮(如右上角的X...当然,位置随便)
		 */
		protected var closeBt:InteractiveObject;
		
		/**
		 * 弹出框的类名称
		 */
		public static var alertConstructor:Class;
		/**
		 * 文本到按钮的距离
		 */
		protected var btY:int;
		/**
		 * 一半按钮宽度
		 */
		private static var flagBtHelfWidth:int;
		/**
		 * 该alert的回调函数
		 */
		public var callBack:Function;
		/**
		 * 弹出框位置,默认<code>"MC"</code>
		 * @see	Elegant.manager.PopUpManager#createPopUp()
		 */
		public var position:String = "MC";
		/**
		 * 参数Object
		 */
		public var objectVars:Object
		/**
		 * @eventType Elegant.events.PopUpEvent.ALERT_SHUT_DOWN 点击按钮时触发
		 */
		[Event(name = "alertShutDown", type = "Elegant.events.PopUpEvent")]
		
		public function Alert(autoConverUI:Boolean = true)
		{
			super(autoConverUI);
		}
		/**
		 * @inheritDoc
		 */
		override public function converUI():void 
		{
			var tempAlertBt:IHasLabel = IHasLabel(getChildByName(ELGFla::ALERT_BT));
			
			_alertBg = getChildByName(ELGFla::ALERT_BG);
			_label = TextField(getChildByName(ELGFla::ALERT_LABEL));
			_title = TextField(getChildByName(ELGFla::ALERT_TITLE_LABEL));
			
			if (_alertBg == null || tempAlertBt == null || _label == null) throw Error("缺少命名规则的元件");
			
			setChildIndex(_label, numChildren - 1);
			_label.mouseEnabled = false;
			if (_title) setChildIndex(_title, numChildren - 1);
			
			alertBt = tempAlertBt["constructor"];
			removeChild(DisplayObject(tempAlertBt));
			btY = tempAlertBt.y;
			flagBtHelfWidth = tempAlertBt.width >> 1;
		}
		/**
		 * 我擦哩...由于用fla里的UI的话无法直接new出这个类,这里写两种准备,一个elgfla的,一个graphics的...
		 * 
		 * 2011.2.13 大事不妙,这里如果执意用fla做skin的思想的话...估计就我自己会用了,还是改用graphics吧
		 * 2011.2.16 ......................写完了.
		 * @param	label
		 * @param	flags
		 * @param	callBack
		 * @param	objectVars	其余同PopUpManager
		 * 			<li><strong> title : String</strong> - 标题文本</li>
		 * 			<li><strong> position : String</strong> - 位置信息</li>
		 * 			<li><strong> modal : Boolean</strong> - 是否模式,默认<code>true</code></li>
		 * 			<li><strong> params : Array</strong> - 回调时的额外参数,默认<code>null</code></li>
		 * 			<li><strong> parent : DisplayObjectConatiner</strong> - 弹出框父级,默认<code>null</code></li>
		 * @return
		 * @see	Elegant.manager.PopUpManager#createPopUp()
		 */
		public static function show(labelStr:String, flags:Array = null, callBack:Function = null, objectVars:Object = null):Alert
		{
			var alert:Alert = new alertConstructor();
			alert.label.htmlText = labelStr;
			alert.callBack = callBack;
			
			var modal:Boolean = true;
			if(objectVars != null)
			{
				var titleStr:String = filterVars("title");
				if (alert.title) alert.title.htmlText =  titleStr == null ? "" : titleStr;
				
				if (objectVars.position) alert.position = filterVars("position");
				if (objectVars.modal) modal = filterVars("modal");
				alert.objectVars = objectVars;
			}
			
			flags == null && (flags = []);
			var tempNumFlagX:int = alert.alertBg.width / (flags.length + 1);
			
			for (var i:int = 0; i < flags.length; i += 1)
			{
				var flagBt:DisplayObject = new alertBt();
				flagBt["text"] = flags[i];
				flagBt["label"].mouseEnabled = false;
				alert.addChild(DisplayObject(flagBt));
				flagBt.y = Math.max(alert.btY, (alert.label.textHeight + alert.label.y + 5));
				flagBt.x = tempNumFlagX * (i + 1) - (flagBt.width >> 1);// flagBtHelfWidth;
				flagBt.addEventListener(MouseEvent.CLICK, flagClickHandler);
				flagBt.name = "flag" + i;
				if (flagBt is Sprite) 
					Sprite(flagBt).buttonMode = true;
			}
			
			var parentContainer:DisplayObjectContainer = DisplayObjectContainer(InitObject.getObject(objectVars, "parent", ELGManager.getInstance.mainShowContainer));
			PopUpManager.createPopUp(alert, modal, parentContainer, alert.position, objectVars);
			return alert;
			
			function filterVars(vars:String):*
			{
				var calls:*;
				if (objectVars[vars])
				{
					calls = objectVars[vars];
					delete objectVars[vars];
				}
				return calls;
			}
		}
		
		//--------MouseEvent Handler----------------------
		/**
		 * alert按钮被点击时触发
		 * @param	e
		 */
		private static function flagClickHandler(e:MouseEvent):void 
		{
			var alert:Alert = Alert(e.currentTarget.parent);
			var index:int = e.currentTarget.name.match(/\d+/)[0];
			
			if (alert.callBack != null) 
			{
				var params:Array = InitObject.getArray(alert.objectVars, "params", []);
				params.unshift(index);
				alert.callBack.apply(null, params);
			}
			
			alert.dispatchEvent(new PopUpEvent(PopUpEvent.ALERT_SHUT_DOWN, index));
			
			PopUpManager.removePopUp(alert);
			ELGManager.getInstance.disposeSome(alert);
		}
		
		//--------getter / setter------------------------
		/**
		 * @private	文本框
		 */
		public function get label():TextField 
		{
			return _label;
		}
		/**
		 * @private	标题文本
		 */
		public function get title():TextField 
		{
			return _title;
		}
		/**
		 * @private	背景
		 */
		public function get alertBg():DisplayObject 
		{
			return _alertBg;
		}
	}
}