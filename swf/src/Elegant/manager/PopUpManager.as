package Elegant.manager 
{
	import com.greensock.TweenNano;
	import Elegant.ELGManager;
	import Elegant.interfaces.ITransformEffect;
	import Elegant.transformEffects.BasicTransformEffect;
	import Elegant.utils.HashMap;
	import Elegant.utils.InitObject;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * 弹出管理
	 * @author 浅唱
	 */
	public class PopUpManager 
	{
		/**
		 * 上
		 */
		public static const TOP:String = "T";
		/**
		 * 中
		 */
		public static const MIDDLE:String = "M";
		/**
		 * 下
		 */
		public static const BOTTOM:String = "B";
		
		/**
		 * 左
		 */
		public static const LEFT:String = "L";
		/**
		 * 中
		 */
		public static const CENTER:String = "C";
		/**
		 * 右
		 */
		public static const RIGHT:String = "R";
		
		/**
		 * 默认弹出窗口
		 */
		public static var defaultPopUpContainer:DisplayObjectContainer;
		
		/**
		 * 弹出序列
		 */
		private static var sequence:Array;
		
		/**
		 * 以target为key,存储模以及其他需要的vars,删除时用
		 */
		private static var modelHash:HashMap;
		/**
		 * 当前是否有显示中的弹出框
		 */
		private static var _showing:Boolean;
		/**
		 * 当前弹出的窗口
		 */
		private static var currentPop:DisplayObject;
		/**
		 * 当前弹出中非队列弹出的窗口
		 */
		private static var noSequencePop:Array = [];
		/**
		 * 切换效果
		 */
		public static var transformEffect:ITransformEffect;
		/**
		 * 使用舞台坐标
		 */
		public static var useStageXY:Boolean = true; 
		/**
		 * 默认弹出modal透明度
		 */
		public static var defaultModalAlpha:Number = .3; 
		/**
		 * 默认弹出modal颜色
		 */
		public static var defaultModalColor:uint = 0; 
		
		public function PopUpManager() 
		{
			
		}
		/**
		 * 初始化
		 */
		public static function init():void
		{
			defaultPopUpContainer = ELGManager.getInstance.mainShowContainer;
			sequence = [];
			modelHash = new HashMap();
			transformEffect = BasicTransformEffect.getInstance;
			
			ELGManager.getInstance.pushToDispose(dipose);
		}
		/**
		 * 销毁
		 */
		private static function dipose():void 
		{
			removePopUp(currentPop);
			defaultPopUpContainer = null;
			sequence = null;
			modelHash.reputHash(true);
			modelHash = null;
			transformEffect = null;
		}
		/**
		 * 创建弹出窗口
		 * @param	target	要弹出的显示对象
		 * @param	modal	是否锁屏(模式)
		 * @param	parent	以哪个对象为父级显示容器
		 * @param	position	弹出位置,内容为上中下中的1个加左中右中的1个,如左上角则为<code>TOP</code> + <code>LEFT</code>,即"TL",默认<code>"MC"</code>
		 * @param	objVars	<li><strong> modalAlpha : String</strong> - modal透明度</li>
		 * 					<li><strong> modalColor : String</strong> - modal颜色值</li>
		 * 					<li><strong> useStageXY : Boolean</strong> - 使用舞台坐标</li>
		 * 					<li><strong> fixedWidth : int</strong> - 触发resize事件或初始化时对齐的时候,使用固定的width</li>
		 * 					<li><strong> fixedHeight : int</strong> - 触发resize事件或初始化时对齐的时候,使用固定的height</li>
		 * 					<li><strong> inSequence : Boolean</strong> - 默认true, 使用队列顺序弹出</li>
		 * 			
		 */
		public static function createPopUp(target:DisplayObject, modal:Boolean = true, parent:DisplayObjectContainer = null, position:String = "MC", objVars:Object = null):void
		{
			parent == null ? parent = defaultPopUpContainer : parent = parent;
			
			var targetObject:Object = { target:target, modal:modal, parent:parent, position:position, objVars:objVars };
			if(InitObject.getBoolean(objVars, "inSequence", true))
			{
				sequence.push(targetObject);
				check();
			} else {
				check(targetObject);
			}
		}
		
		/**
		 * 删除弹出窗口
		 * 当你直接调用此方法来关闭弹出框时,不会发送任何事件
		 * 这里只做移除处理,任何事件由对象自行处理
		 * @param	target	要移除的对象
		 */
		public static function removePopUp(target:DisplayObject):void
		{
			if (target == null) return;
			
			var noSequenceIndex:int = -1;
			if (currentPop != target)
			{
				var i:int;
				for (i = 0; i < sequence.length; i += 1)
				{
					if (sequence[i].target == target)
					{
						sequence.splice(i, 1);
						return;
					}
				}
				noSequenceIndex = noSequencePop.indexOf(target);
				if (noSequenceIndex != -1)
					noSequencePop.splice(noSequenceIndex, 1);
			}
			
			var objVars:Object = modelHash.reduce(target);
			var modal:Sprite = (objVars && objVars.hasOwnProperty("modal") ? objVars.modal : null);
			if (modal)
			{
				modal.parent.removeChild(modal);
				modal = null;
			}
			
			if (target.parent) target.parent.removeChild(target);
			if (currentPop == target)
			{
				currentPop = null;
				_showing = false;
			}
			if (currentPop == null && noSequencePop.length == 0)
				defaultPopUpContainer.stage.removeEventListener(Event.RESIZE, onPopResize);
			check();
		}
		/**
		 * 检测是否有下一个需要显示的
		 */
		private static function check(noSequenceTarget:* = null):void
		{
			if (noSequenceTarget == null && (_showing || sequence.length == 0)) return;
			
			var modal:Sprite;
			var next:Object = (noSequenceTarget == null ? sequence.shift() : noSequenceTarget);
			
			var modalColor:uint = InitObject.getUint(next.objVars, "modalColor", defaultModalColor);
			var modalAlpha:Number = InitObject.getNumber(next.objVars, "modalAlpha", defaultModalAlpha, { min:0, max:1 });
			if (next.modal && next.parent)
			{
				modal = newModalSprite(new Rectangle(0, 0, defaultPopUpContainer.stage.stageWidth * 2,  defaultPopUpContainer.stage.stageHeight * 2), modalColor, modalAlpha);
				next.parent.addChild(modal);
			}
			
			var target:DisplayObject = next.target;
			transformEffect.show(target, next.parent);
			modelHash.add(target, new TargetVars(modal, String(next.position).split(""), 
				InitObject.getBoolean(next.objVars, "useStageXY", useStageXY), 
				InitObject.getInt(next.objVars, "fixedWidth", -1, { min: -1 } ), 
				InitObject.getInt(next.objVars, "fixedHeight", -1, { min: -1 } ), modalColor, modalAlpha));
			
			if(noSequenceTarget == null)
			{
				_showing = true;
				currentPop = next.target;
			} else {
				noSequencePop.push(next.target);
			}
			
			defaultPopUpContainer.stage.addEventListener(Event.RESIZE, onPopResize);
			onPopResize(null);
		}
		/**
		 * resize
		 * @param	e
		 */
		private static function onPopResize(e:Event):void 
		{
			var resizeArr:Array = noSequencePop.slice();
			if (currentPop) 
				resizeArr.push(currentPop);
			var popTarget:DisplayObject;
			
			while (resizeArr.length > 0)
			{
				popTarget = resizeArr.pop();
				var tarVar:TargetVars = modelHash.get(popTarget);
				var rect:Rectangle = popTarget.parent.getBounds(popTarget.parent);
				
				if (tarVar.useStageXY)
				{
					var point:Point = popTarget.parent.localToGlobal(new Point);
					rect.x = -point.x;
					rect.y = -point.y;
					rect.width = popTarget.parent.stage.stageWidth;
					rect.height = popTarget.parent.stage.stageHeight;
				}
				var modal:Sprite = tarVar.modal;
				if (modal)
				{
					modal.graphics.clear();
					modal.graphics.beginFill(tarVar.modalColor, tarVar.modalAlpha);
					modal.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
					modal.graphics.endFill();
				}
				
				var width:int = (tarVar.fixedWidth == -1 ? popTarget.width : tarVar.fixedWidth);
				var height:int = (tarVar.fixedHeight == -1 ? popTarget.height : tarVar.fixedHeight);
				
				var posi:Array = tarVar.position;
				for (var i:int = 0; i < 2; i += 1)
				{
					switch(String(posi[i]).toUpperCase())
					{
						case TOP:
							popTarget.y = 0 + rect.y;
							break;
						case BOTTOM:
							popTarget.y = rect.height - height + rect.y;
							break;
						case MIDDLE:
							popTarget.y = (rect.height - height) * .5 + rect.y;
							break;
						case LEFT:
							popTarget.x = 0 + rect.x;
							break;
						case RIGHT:
							popTarget.x = rect.width - width + rect.x;
							break;
						case CENTER:
							popTarget.x = (rect.width - width) * .5 + rect.x;
							break;
						default:
							throw ArgumentError("参数 position 错误  不应出现 " + posi[i]);
					}
				}
			}
		}
		/**
		 * 当前是否有显示中的弹出框
		 */
		public static function get showing():Boolean 
		{
			return _showing;
		}
		/**
		 * 获取 当前弹出显示对象
		 */
		public static function get currentPopUp():DisplayObject
		{
			return currentPop;
		}
		/**
		 * 返回新的模式层
		 */
		private static function newModalSprite(rect:Rectangle, modalColor:uint, modalAlpha:Number):Sprite
		{
			var modal:Sprite = new Sprite();
			modal.graphics.beginFill(modalColor, modalAlpha);
			modal.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			modal.graphics.endFill();
			modal.alpha = 0;
			
			TweenNano.to(modal, .5, { alpha:1 } );
			return modal;
		}
	}
}
import flash.display.Sprite;
class TargetVars
{
	public var position:Array;
	public var modal:Sprite;
	public var useStageXY:Boolean;
	public var fixedHeight:int;
	public var fixedWidth:int;
	public var modalColor:uint;
	public var modalAlpha:Number;
	
	public function TargetVars(modal:Sprite, position:Array, useStageXY:Boolean, fixedWidth:int, fixedHeight:int, modalColor:uint, modalAlpha:Number)
	{
		this.modalColor = modalColor;
		this.modalAlpha = modalAlpha;
		this.fixedWidth = fixedWidth;
		this.fixedHeight = fixedHeight;
		this.useStageXY = useStageXY;
		this.modal = modal;
		this.position = position;
	}
}