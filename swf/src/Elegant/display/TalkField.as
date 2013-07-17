package Elegant.display
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * 图文显示框
	 * @author 闪刀浪子
	 * 使用方法：
	 */
	public class TalkField extends Sprite
	{
		private var _tf:TextField;
		private var _tfMask:Sprite;
		private var _faceContainer:Sprite;
		
		private var _maskWidth:Number;
		private var _maskHeight:Number;
		
		private var _textFormat:TextFormat;
		private var _leading:Number
		private var _textColor:uint;
		private var _alpha:Number;
		
		private var _appDomain:ApplicationDomain;
		
		/**
		 * 构造函数
		 * @param	width	图文宽度
		 * @param	height  图文框高度
		 * @param	leading  显示的文本行的行间距
		 * @param	appDomain  包含"facexx"的程序域
		 * @param	textColor	默认文本的颜色，如果没有用<font>标签定义颜色，则使用此颜色
		 * @param	alpha  图文框的背景透明度
		 */
		public function TalkField(width:Number, height:Number, appDomain:ApplicationDomain = null,
						leading:Number=2,textColor:uint=0xeeeeee,alpha:Number=0) 
		{
			_maskWidth = width;
			_maskHeight = height;
			_leading = leading;
			_textColor = textColor
			_alpha = alpha;
			_appDomain = appDomain==null?ApplicationDomain.currentDomain:appDomain;
			
			initView()
			initEvent();
		}
		
		private function initView()
		{
			createBK();
			createMask();
			createTF();
			createFaceContainer();
		}
		
		private function initEvent()
		{
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheelHandler);
		}
		
		private function onMouseWheelHandler(e:MouseEvent):void 
		{
			maskY -= (e.delta * 4.0);
			dispatchEvent(new Event("scroll"));
		}
		
		private function createBK()
		{
			graphics.beginFill(0, _alpha);
			graphics.drawRect( -5, -2, _maskWidth + 10, _maskHeight + 14);
			graphics.endFill();
		}
		
		private function createMask()
		{
			_tfMask = new Sprite();
			_tfMask.graphics.beginFill(0x000000);
			_tfMask.graphics.drawRect(0, 0, _maskWidth, _maskHeight);
			_tfMask.graphics.endFill();
			addChild(_tfMask);
		}
		
		private function createTF()
		{
			_textFormat = new TextFormat;
			_textFormat.color=_textColor;
			_textFormat.size = 12;
			_textFormat.letterSpacing = 0.75;
			_textFormat.leading = _leading;
			
			_tf = new TextField();
			_tf.textColor = 0xeeeeee;
			_tf.width = _maskWidth;
			_tf.defaultTextFormat = _textFormat;
			_tf.selectable = false;
			_tf.multiline = true;
			_tf.wordWrap = true;
			_tf.autoSize = "left";
			_tf.filters = [new GlowFilter(0x000000, 0.95, 2, 2, 10)];
			_tf.mouseWheelEnabled = false;
			addChild(_tf);
			_tf.mask = _tfMask;
		}
		
		private function createFaceContainer()
		{
			_faceContainer = new Sprite();
			_faceContainer.scrollRect = new Rectangle(0, 0, _maskWidth, _maskHeight);
			addChild(_faceContainer);
		}
		
		private function clearFaceContain()
		{
			while (_faceContainer.numChildren > 0)
			{
				_faceContainer.removeChildAt(0);
			}
		}
		
		/**
		 * 聊天显示框
		 * @param	str 必须为htmlText格式
		 */
		public function setText(str:String)
		{
			_tf.text = "";
			_tf.defaultTextFormat = _textFormat;
			var faceArr:Array = [];
			clearFaceContain();
			
			//保存表情符的编号并替换为空格,此处可以根据你的表情数量来修改正则表达式
			//表情素材的导出类名规则为——face01-face05
			var face:Array = str.match(/\*(0[1-5])/g);
			if (face != null)
			{
				faceArr = faceArr.concat(face);
			}
			//注意这里是将表情编号替换为全角的空格，所以记住你的输入框要禁止玩家输入全角空格
			//需要替换的内容是：*01 - *09
			str = str.replace(/\*(0[1-5])/g, "<font size='24'>　</font>");
			_tf.htmlText = str;
			_tf.height;
			
			//记录空格的索引号
			var text:String = _tf.text;
			var indexArr:Array = [];
			for (var index:int = 0; index < text.length; index++)
			{
				if (text.charAt(index) == "　")
				{
					indexArr.push(index);
				}
			}
			_tf.height;
			for (var j = 0; j < indexArr.length; j++)
			{
				var tempPos:Rectangle = _tf.getCharBoundaries(indexArr[j]);
				var linkClass:Class = _appDomain.getDefinition("face" + faceArr[j].substr(1, 2)) as Class;
				if (linkClass != null&&tempPos!=null)
				{
					var mc:MovieClip = new linkClass as MovieClip;
					_faceContainer.addChild(mc);
					mc.x = tempPos.x;
					mc.y = tempPos.y+3;
				}
			}
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * 设置文本
		 * @param	arr 频道数组
		 */
		public function setMultiText(arr:Array)
		{
			if (arr == null) return;
			_tf.text = "";
			_tf.defaultTextFormat = _textFormat;
			var faceArr:Array = [];
			clearFaceContain();
			
			var allStr:String=""
			for (var i = 0; i < arr.length; i++)
			{
				var str:String = arr[i];
				var face:Array = str.match(/\*(0[1-5])/g);
				if (face != null)
				{
					faceArr = faceArr.concat(face);
				}
				str = str.replace(/\*(0[1-5])/g, "<font size='24'>　</font>");
				allStr += str;
			}
			_tf.htmlText = allStr;
			_tf.height;
			
			//记录空格的索引号
			var text:String = _tf.text;
			var indexArr:Array = [];
			for (var index:int = 0; index < text.length; index++)
			{
				if (text.charAt(index) == "　")
				{
					indexArr.push(index);
				}
			}
			_tf.height;
			for (var j = 0; j < indexArr.length; j++)
			{
				var tempPos:Rectangle = _tf.getCharBoundaries(indexArr[j]);
				var linkClass:Class = _appDomain.getDefinition("face" + faceArr[j].substr(1, 2)) as Class;
				if (linkClass != null&&tempPos!=null)
				{
					var mc:MovieClip = new linkClass as MovieClip;
					_faceContainer.addChild(mc);
					mc.x = tempPos.x;
					mc.y = tempPos.y+3;
				}
			}
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/* INTERFACE game.ui.list.IScrollElement */
		
		public function get maskX():Number 
		{
			return _faceContainer.scrollRect.x;
		}
		
		public function set maskX(val:Number) 
		{
			var rec:Rectangle = _faceContainer.scrollRect;
			rec.x = val;
			_tf.x = -val;
			_faceContainer.scrollRect = rec;
			
		}
		
		public function get maskY():Number 
		{
			return _faceContainer.scrollRect.y;
		}
		
		public function set maskY(val:Number) 
		{
			var rec:Rectangle = _faceContainer.scrollRect;
			if (val < 0) val = 0;
			else if (val > maxScroll) val = maxScroll;
			_tf.y = -val;
			rec.y = val;
			_faceContainer.scrollRect = rec;
		}
		
		public function get minScroll():Number 
		{
			return 0;
		}
		
		public function get maxScroll():Number 
		{
			if (_tf.height <= _tfMask.height) return 0;
			else return _tf.height - _tfMask.height;
		}
	}

}