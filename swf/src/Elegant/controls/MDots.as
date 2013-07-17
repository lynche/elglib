package Elegant.controls
{
	import Elegant.display.Container;
	import Elegant.display.ToggleButton;
	import Elegant.interfaces.ITransformEffect;
	import Elegant.transformEffects.BasicTransformEffect;
	import Elegant.utils.ChildrenKiller;
	import Elegant.utils.InitObject;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author 浅唱
	 */
	public class MDots extends Container
	{
		/**
		 * 横向
		 */
		public static const HORIZONTAL:String = "horizontal";
		/**
		 * 纵向
		 */
		public static const VERTICAL:String = "vertical";
		
		public var onDotChange:Function;
		
		private var container:Sprite;
		private var _dots:Array;
		private var lastDotIndex:int;
		private var space:int;
		private var maxContent:int;
		private var direction:String;
		private var dotRef:Class;
		private var lastBtn:InteractiveObject;
		private var nextBtn:InteractiveObject;
		private var defaultIndex:int;
		private var textOverColor:Number;
		private var textOutColor:Number;
		private var _hasLabel:Boolean;
		private var _dotsNum:int;
		
		public var transformEffect:ITransformEffect = new BasicTransformEffect();
		
		/**
		 *
		 * @param	dotRef
		 * @param	objectVars
		 * 			<li><strong> space : int</strong> - 间距</li>
		 * 			<li><strong> direction : String</strong> - 方向,默认:HORIZONTAL</li>
		 * 			<li><strong> maxContent : int</strong> - 默认:int.MAX_VALUE, 最多显示多少个</li>
		 * 			<li><strong> lastBtn : InteractiveObject</strong> - 上翻按钮</li>
		 * 			<li><strong> nextBtn : InteractiveObject</strong> - 下翻按钮</li>
		 * 			<li><strong> defaultIndex : int</strong> - 默认:-1 初始时第几个按钮亮</li>
		 * 			<li><strong> textOverColor : uint</strong> - 鼠标经过颜色</li>
		 **/
		public function MDots(dotRef:Class, dotsNum:int, onDotChange:Function = null, objectVars:Object = null)
		{
			super();
			_dotsNum = dotsNum;
			this.dotRef = dotRef;
			this.onDotChange = onDotChange;
			space = InitObject.getInt(objectVars, "space", 3);
			direction = InitObject.getString(objectVars, "direction", HORIZONTAL);
			maxContent = InitObject.getInt(objectVars, "maxContent", int.MAX_VALUE, {min: 3});
			defaultIndex = InitObject.getInt(objectVars, "defaultIndex", -1);
			textOverColor = InitObject.getNumber(objectVars, "textOverColor", -1);
			lastBtn = InteractiveObject(InitObject.getObject(objectVars, "lastBtn", null, InteractiveObject));
			nextBtn = InteractiveObject(InitObject.getObject(objectVars, "nextBtn", null, InteractiveObject));
			container = new Sprite();
			
			buildDots(dotsNum);
		}
		
		public static function getItemLabel(item:InteractiveObject):TextField
		{
			return TextField(DisplayObjectContainer(DisplayObjectContainer(item).getChildByName("TXF_Label_Container")).getChildByName("TXF_Label"));
		}
		
		protected function buildDots(dotsNum:int):void
		{
			ChildrenKiller.kill(this);
			ChildrenKiller.kill(container);
			if (dots)
			{
				for (var j:int = 0; j < dots.length; j++)
				{
					var item:InteractiveObject = dots[j];
					item.removeEventListener(MouseEvent.CLICK, onDotClick);
					item.removeEventListener(MouseEvent.ROLL_OVER, onDotItemOver);
					item.removeEventListener(MouseEvent.ROLL_OUT, onDotItemOut);
				}
			}
			
			_dots = [];
			lastDotIndex = -1;
			var tempX:int = 0;
			var dotMask:Sprite;
			var dotWidth:int = -1;
			
			_hasLabel = false;
			var itemX:InteractiveObject;
			itemX = new dotRef();
			if (itemX is DisplayObjectContainer)
			{
				var disContainer:DisplayObjectContainer = DisplayObjectContainer(itemX).getChildByName("TXF_Label_Container") as DisplayObjectContainer;
				if (disContainer)
				{
					var tf:TextField = disContainer.getChildByName("TXF_Label") as TextField;
					if (tf)
					{
						_hasLabel = true;
						textOutColor = tf.textColor;
						if (textOverColor < 0)
							textOverColor = textOutColor;
					}
				}
			}
			var buttonmode:Boolean = false;
			if (itemX.hasOwnProperty("buttonMode"))
				buttonmode = true;
			
			for (var i:int = 0; i < dotsNum; i++)
			{
				itemX = new dotRef();
				itemX.x = tempX;
				itemX.name = "dot" + i;
				tempX += (itemX.width + space);
				if (hasLabel)
				{
					if(textOverColor != textOutColor)
					{
						itemX.addEventListener(MouseEvent.ROLL_OVER, onDotItemOver, false, -1, true);
						itemX.addEventListener(MouseEvent.ROLL_OUT, onDotItemOut, false, -1, true);
					}
					MDots.getItemLabel(itemX).text = i + 1 + "";
				}
				
				if (buttonmode)
					itemX["buttonMode"] = true;
				
				itemX.addEventListener(MouseEvent.CLICK, onDotClick, false, -1, true);
				dots[i] = itemX;
				container.addChild(itemX);
				
				if (dotsNum < maxContent)
				{
					if (i == dotsNum - 1)
					{
						dotWidth = tempX - space;
					}
				} else {
					if (i == maxContent)
					{
						dotWidth = tempX - space - itemX.width;
					}
				}
			}
			addChild(container);
			
			//如果总dots数量大于最多显示数量
			if (dotsNum >= maxContent)
			{
				dotMask = new Sprite();
				dotMask.graphics.beginFill(0);
				dotMask.graphics.drawRect(0, 0, dotWidth, container.height);
				addChild(dotMask);
				container.mask = dotMask;
			}
			
			if (lastBtn)
			{
				lastBtn.addEventListener(MouseEvent.CLICK, onLastClick);
				lastBtn.x = -(lastBtn.width + space);
				addChild(lastBtn);
			}
			if (nextBtn)
			{
				nextBtn.addEventListener(MouseEvent.CLICK, onNextClick);
				nextBtn.x = dotWidth + space;
				addChild(nextBtn);
			}
			if (defaultIndex > -1)
				dots[defaultIndex].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		private function onDotItemOver(e:MouseEvent):void 
		{
			MDots.getItemLabel(InteractiveObject(e.currentTarget)).textColor = textOverColor;
		}
		
		private function onDotItemOut(e:MouseEvent):void 
		{
			MDots.getItemLabel(InteractiveObject(e.currentTarget)).textColor = textOutColor;
		}
		
		private function onDotClick(e:MouseEvent):void
		{
			if (lastDotIndex != -1)
			{
				var lastDot:InteractiveObject = dots[lastDotIndex];
				if (lastDot is ToggleButton)
					ToggleButton(lastDot).isSelected = false;
				else if (lastDot is MovieClip)
					MovieClip(lastDot).gotoAndStop("up");
				if (hasLabel)
				{
					getItemLabel(lastDot).textColor = textOutColor;
					if(textOverColor != textOutColor)
					{
						lastDot.addEventListener(MouseEvent.ROLL_OVER, onDotItemOver, false, -1, true);
						lastDot.addEventListener(MouseEvent.ROLL_OUT, onDotItemOut, false, -1, true);
					}
				}
			}
			lastDotIndex = e.currentTarget.name.match(/\d+/)[0];
			lastDot = dots[lastDotIndex];
			
			if (lastDot is ToggleButton)
				ToggleButton(lastDot).isSelected = true;
			else if (lastDot is MovieClip)
				MovieClip(lastDot).gotoAndStop("down");
			if (hasLabel)
			{
				lastDot.removeEventListener(MouseEvent.ROLL_OVER, onDotItemOver);
				lastDot.removeEventListener(MouseEvent.ROLL_OUT, onDotItemOut);
				getItemLabel(lastDot).textColor = textOverColor;
			}
			
			if (maxContent != int.MAX_VALUE && dots.length > maxContent)
			{
				//总显示数的一半
				var helfCount:int = maxContent / 2;
				transformEffect.tween(container, .4, {x: -Math.min((lastDotIndex <= helfCount ? 0 : lastDotIndex - helfCount), dots.length - maxContent) * ((direction == HORIZONTAL ? dots[0].width : dots[0].height) + space)});
			}
			if (onDotChange != null)
				onDotChange(lastDotIndex);
		}
		
		private function onLastClick(e:MouseEvent):void
		{
			if (lastDotIndex - 1 >= 0)
				dots[lastDotIndex - 1].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		private function onNextClick(e:MouseEvent):void
		{
			if (lastDotIndex + 1 < dots.length)
				dots[lastDotIndex + 1].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		//-----------------------------------getter / setter----------------------------
		/**
		 * 设置 / 获取 当前显示ID
		 */
		public function set dotIndex(index:int):void
		{
			if(index < dots.length && index >= 0)
				dots[index].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		public function get dotIndex():int
		{
			return lastDotIndex;
		}
		
		/**
		 * 获取dots
		 */
		public function get dots():Array 
		{
			return _dots;
		}
		
		/**
		 * 获取是否有文本
		 */
		public function get hasLabel():Boolean 
		{
			return _hasLabel;
		}
		
		public function get dotsNum():int 
		{
			return _dotsNum;
		}
	}
}