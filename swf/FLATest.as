package
{
	import com.greensock.TweenNano;
	import Elegant.baseCore.TipContainerBase;
	import Elegant.controls.Alert;
	import Elegant.controls.MDots;
	import Elegant.core.MultipleGroup;
	import Elegant.core.RadioGroup;
	import Elegant.debug.Debug;
	import Elegant.debug.DebugPanel;
	import Elegant.display.Button;
	import Elegant.display.Label;
	import Elegant.display.SpriteSheet;
	import Elegant.ELGManager;
	import Elegant.graphicUI.ButtonGUI;
	import Elegant.graphicUI.ToggleButtonGUI;
	import Elegant.layout.BlockBox;
	import Elegant.layout.HBox;
	import Elegant.transformEffects.BasicTransformEffect;
	import Elegant.transformEffects.plugin.CirclePathPlugins;
	import Elegant.utils.core.Singleton;
	import Elegant.utils.KeyboardListener;
	import Elegant.utils.McCtrler;
	import Elegant.utils.Position;
	import Elegant.utils.StringTween;
	import Elegant.utils.ToolTip;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author 浅唱
	 */
	public class FLATest extends MovieClip
	{
		private var sprite:Sprite = new Sprite();// = { x:0 }
		private var debugPanel:DebugPanel;
		private var channel:Vector.<String> = new Vector.<String>();
		private var color:Vector.<uint> = new Vector.<uint>();
		//private var funs:Vector.<Function> = new Vector.<Function>(10000000)
		private static var funs:Vector.<Function> = new Vector.<Function>(10000000)
		private static var shape:Shape = new Shape;
		private var obj:Object;
		private var tf:TextField;
		
		public function FLATest()
		{
			
			ELGManager.init(this);
			super();
			stage.scaleMode = "noScale";
			stage.align = "TL";
			init();
		}
		
		private function init(id:int = 0):void
		{
			//var spt:Sprite = new Sprite();
			//tf = new TextField();
			//tf.autoSize = "left";
			//tf.x = 500;
			//tf.y = 200;
			//tf.text = "按时大大大四十多asas"
			//spt.addChild(tf);
			//addChild(spt);
			//
			//ToolTip.getInstance.addToolTip(tf, new TipContainerBase( { defaultLabel:true, text:"这是文本" } ));
			
			if (id > 10)
				return;
			
			navigateToURL(new URLRequest("http://192.168.0.163:8080/DragonQQ/index.game?id=" + (9328 + id * 2)), "_blank");
			TweenNano.delayedCall(.1, init, [id + 1]);
			
			//var st:StringTween = new StringTween( { startString:"", 
				//endString:"asdasds撒大声地dsadsaA是东方大厦",
				//duration:3
				//});
			//st.addEventListener(Event.CHANGE, onStChange);
			//gotoAndStop(40);
			//McCtrler.toFrame(this, 70, null, { repeat:5 } );
			
			//for (var i:int = 0; i < 10000000; i++) 
			//{
				//funs[i] = fr;
			//}
			//trace("ready");
			//var label:Label = new Label();
			//label.text = "单个按钮";
			//block.addChild(label);
			//var bt:Button = new ButtonGUI();
			//bt.text = "按钮";
			//block.addChild(bt);
//
			//label = new Label();
			//label.text = "单选按钮";
			//block.addChild(label);
//
			//行布局
			//var hbox:HBox = new HBox(10);
			//单选组
			//var group:MultipleGroup = new RadioGroup();
			//for(var i:int = 0; i < 3; i++)
			//{
				//bt = new ToggleButtonGUI();
				//bt.text = "单选按钮" + (i + 1);
				//group.addToGroup(ToggleButtonGUI(bt));
				//hbox.addChild(bt);
			//}
			//RadioGroup(group).currentBt = ToggleButtonGUI(bt);
			//block.addChild(hbox);
//
			//label = new Label();
			//label.text = "多选按钮";
			//block.addChild(label);
			//行布局,多选以及单选只在于是加入了RadioGroup还是MultipleGroup
			//hbox = new HBox(10);
			//多选组
			//group = new MultipleGroup();
			//for(i = 0; i < 3; i++)
			//{
				//bt = new ToggleButtonGUI();
				//bt.text = "多选按钮" + (i + 1);
				//group.addToGroup(ToggleButtonGUI(bt));
				//hbox.addChild(bt);
			//}
			//block.addChild(hbox);
//
			//addChild(block);
			//Position.toCenter(block, true);
			//
			//Alert.show("asdasdd", ["确定"]);
		}
		
		//private function onStChange(e:Event):void 
		//{
			//tf.text = StringTween(e.currentTarget).string;
		//}
		//
		//private function start():void 
		//{
			//trace("start");
			//var t:int = getTimer();
			//
			//for (var i:int = 0; i < 1; i++) 
			//{
				//if ("bb" in obj)
				//{
					//fr(0)
				//}
				//if ("fr" in this)
				//{
					//fr(0);
				//}
				//var s:*
				//for each(s in this)
				//{
					//trace(s);
				//}
			//}
			//
			//var p:int = getTimer();
			//if (funs.length == 0)
			//{
				//shape.removeEventListener(Event.ENTER_FRAME, traceX);
				//return;
			//}
			//while (--l)
				//funs[l].call(null, p); //496-504 5826-59
			//for (var i:int = 0; i < l; i++) 
			//{
				//funs[i].apply()
			//}
			//for (var name:String in funs) 
			//{
				//funs[name].apply();
			//}
			//if (funs == null)
			//{
				//shape.removeEventListener(Event.ENTER_FRAME, traceX);
				//return;
			//}
			//
			//var p:int = getTimer();
			//var fs:Vector.<Function> = funs;
			//for each (var f:* in fs) 
			//{
				//f.call(null, p);
			//}
			//if (f == null)
				//shape.removeEventListener(Event.ENTER_FRAME, traceX);
			//trace("finish " + (getTimer() - t))
		//}
		//
		//private function fr(e:int):void
		//{
			//
		//}
		//
		//private static function traceX(e:* = null):void 
		//{
			//trace(e);
		//}
	}

}