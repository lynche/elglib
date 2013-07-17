package Elegant.transformEffects
{
	import com.greensock.TweenNano;
	import Elegant.ELGManager;
	import Elegant.interfaces.ITransformEffect;
	import Elegant.transformEffects.plugin.PluginBase;
	import Elegant.utils.core.Singleton;
	import Elegant.utils.HashMap;
	import Elegant.utils.InitObject;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	
	/**
	 * 基础显示效果类,本类不实现任何效果
	 * 想要效果的要自己动手咯
	 * @author 浅唱
	 */
	public class BasicTransformEffect implements ITransformEffect
	{
		private var hash:HashMap;
		private var shape:Shape;
		private static var pluginsArray:Array = [];
		
		public function BasicTransformEffect()
		{
		
		}
		
		public static function get getInstance():BasicTransformEffect
		{
			return Singleton.getInstanceOrCreate(BasicTransformEffect);
		}
		
		public static function activePlugin(...args):void
		{
			var num:int = args.length;
			for (var i:int = 0; i < num; i++) 
			{
				var name:String = String(args[i]);
				name = name.replace("[class ", "").replace("]", "");
				
				if (pluginsArray.indexOf(name) == -1)
					pluginsArray[pluginsArray.length] = name;
			}
		}
		
		/* INTERFACE Elegant.interfaces.ITransformEffect */ /**
		 * @copy Elegant.interfaces.ITransformEffect#show()
		 */
		public function show(dis:DisplayObject, parent:DisplayObjectContainer, objectVars:Object = null):void
		{
			parent.addChild(dis);
			
			var onComplete:Function = InitObject.getObject(objectVars, "onComplete") as Function;
			if (onComplete != null)
				onComplete.apply(null, InitObject.getArray(objectVars, "onCompleteParams"));
		}
		
		/**
		 * @copy Elegant.interfaces.ITransformEffect#close()
		 */
		public function close(dis:DisplayObject, objectVars:Object = null):void
		{
			dis.parent.removeChild(dis);
			
			var onComplete:Function = InitObject.getObject(objectVars, "onComplete") as Function;
			if (onComplete != null)
				onComplete.apply(null, InitObject.getArray(objectVars, "onCompleteParams"));
		}
		
		/**
		 * 无任何效果，只做功能
		 * @copy Elegant.interfaces.ITransformEffect#exchange()
		 */
		public function exchange(dis:DisplayObject, next:DisplayObject, objectVars:Object = null):void
		{
			var parent:DisplayObjectContainer = dis.parent;
			close(dis);
			
			//如果你拥有GreenSock的类完全可以使用TweenLite代替此处
			var onComplete:Function = InitObject.getObject(objectVars, "onComplete") as Function;
			var onCompleteParams:Array = InitObject.getArray(objectVars, "onCompleteParams");
			setTimeout(exFun, InitObject.getNumber(objectVars, "delay", 0, { min:0 } ));
			
			var exFun:Function = function():void
			{
				show(next, parent, { onComplete:onComplete, onCompleteParams:onCompleteParams } );
				parent == null;
				exFun = null;
			}
		}
		
		/**
		 * 为了不引用其他的类...比如TweenLite,只能临时自弄一个了
		 * 毕竟不是TweenLite,这里就只支持3个最常用的功能了,"ease", "onUpdate", "onUpdateParams", "onComplete", "onCompleteParams"
		 * 同志们有需要的话最好自己继承此类,重写该方法调用TweenLite
		 * 
		 * 受打击啊,用greensock的工具测试效率不是一般的低下,不过貌似在他列出的几个之中也就排在greensock的后面
		 * 
		 * @copy Elegant.interfaces.ITransformEffect#tween()
		 */
		public function tween(target:Object, time:Number, objectVars:Object):void
		{
			//2012.4.6 尼玛还是乖乖的用greensock的类吧
			TweenNano.to(target, time, objectVars);
			
		}
	}
}