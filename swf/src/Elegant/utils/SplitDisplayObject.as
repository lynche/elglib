package Elegant.utils 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	/**
	 * 废柴,这个类可以忽略了
	 * @author 浅唱
	 */
	public class SplitDisplayObject extends Sprite 
	{
		private var source:DisplayObject;
		private var objectVars:Object;
		
		private var _fragments:Array;
		
		public function SplitDisplayObject(source:DisplayObject, cRect:Rectangle, objectVars:Object = null) 
		{
			super();
			this.objectVars = objectVars;
			this.source = source;
			
			if (source.parent)
			{
				Cloning.cloneSomeVars(source, this, ["x", "y"]);
				source.parent.addChildAt(this, source.parent.getChildIndex(source));
				source.parent.removeChild(source);
			}
			trace(getTimer() * .001);
			_fragments = SplitDisplayObject.split(source, cRect, objectVars);
			trace(getTimer() * .001);
			
			for (var i:int = 0; i < _fragments.length; i++) 
			{
				addChild(_fragments[i]);
			}
		}
		
		/**
		 * 
		 * @param	source
		 * @param	cRect
		 * @param	objectVars	<li><strong> splitType : Class</strong> - 默认Bitmap 将对象打散后添加到哪个类的实例中,必须是DisplayObjectContainer的子类或者Bitmap</li>
		 * 						<li><strong> smoothing : Boolean</strong> - 默认false Bitmap是否平滑</li>
		 * @return
		 */
		public static function split(source:DisplayObject, cRect:Rectangle, objectVars:Object = null):Array 
		{
			var splitType:Class = Class(InitObject.getObject(objectVars, "splitType", Bitmap, Class));
			var smoothing:Boolean = InitObject.getBoolean(objectVars, "smoothing", false);
			var withColor:Number = InitObject.getNumber(objectVars, "withColor", -1);
			var onlyPosition:Boolean = splitType == Point;
			var containerMode:Boolean = (splitType != Bitmap);
			
			var scraps:Array = [];
			var widthMax:int = source.width / cRect.width + 1;
			var heightMax:int = source.height / cRect.height + 1;
			
			var sourceBitmapData:BitmapData = (source is BitmapData) ? BitmapData(source) : (new BitmapData(source.width, source.height));
			sourceBitmapData.draw(source);
			var distPoint:Point = new Point();
			
			for (var i:int = 0; i < heightMax; i++) 
			{
				for (var j:int = 0; j < widthMax; j++) 
				{
					var rect:Rectangle = new Rectangle(j * cRect.width, i * cRect.height, cRect.width, cRect.height);
					if (withColor != -1)
					{
						var vector:Vector.<uint> = sourceBitmapData.getVector(rect);
						if (vector.indexOf(withColor) == -1)
							continue;
					}
					
					if (onlyPosition)
					{
						scraps[scraps.length] = new Point(rect.x, rect.y);
					} else {
						var bitmap:Bitmap = new Bitmap(new BitmapData(cRect.width, cRect.height, true, 0), "auto", smoothing);
						bitmap.bitmapData.copyPixels(sourceBitmapData, rect, distPoint);
						
						if (containerMode)
						{
							var container:DisplayObjectContainer = new splitType();
							container.x = j * cRect.width;
							container.y = i * cRect.height;
							container.addChild(bitmap);
							scraps.push(container);
						} else {
							bitmap.x = j * cRect.width;
							bitmap.y = i * cRect.height;
							scraps.push(bitmap);
						}
					}
				}
			}
			return scraps;
		}
		
		//------------------------getter / setter---------------------------------------
		/**
		 * 获取碎片
		 */
		public function get fragments():Array 
		{
			return _fragments;
		}
	}
}