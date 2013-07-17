package Elegant.utils.bitmap
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	
	/**
	 * 卡马克卷轴类 scroll carmark
	 * @version 1.0
	 * @author 阿伍 present by Awu
	 * rotaryice@qq.com
	 */
	public class CarmackBMP extends Bitmap
	{
		
		public var rx:Number = 0; //真实的坐标
		public var ry:Number = 0;
		//
		public var px:Number = 0; //原始坐标
		public var py:Number = 0;
		//
		private var sw:int = 0; //OSD屏幕大小
		private var sh:int = 0;
		//
		private var buff_x:int = 0; //水平缓冲量
		private var buff_y:int = 0; //垂直缓冲
		//
		private var source:BitmapData;
		
		public function CarmackBMP(source:BitmapData, sw:int, sh:int, buff_x:int, buff_y:int):void
		{
			this.source = source;
			
			this.bitmapData = new BitmapData(sw + buff_x * 2, sh + buff_y * 2, true, 0);
			this.sw = sw;
			this.sh = sh;
			this.buff_x = buff_x;
			this.buff_y = buff_y;
			
			this.rx = 0;
			this.ry = 0;
			
			setPositon(0, 0);
			if (source)
				this.scrollTo(0, 0);
		}
		
		public function dispose():void
		{
			if (source == null)
				return;
			
			source.dispose();
			bitmapData.dispose();
			bitmapData = new BitmapData(sw + buff_x * 2, sh + buff_y * 2, true, 0);
			source = null;
			if (parent)
				parent.removeChild(this);
		}
		
		public function setSource(source:BitmapData):void
		{
			this.source = source;
			scrollTo(rx, ry);
		}
		
		//直接跳转到某个坐标，会导致重绘OSD与缓冲区
		public function scrollTo(x:int, y:int):void
		{
			this.bitmapData.fillRect(this.bitmapData.rect, 0x00000000);
			this.x = this.px;
			this.y = this.py;
			this.rx = x;
			this.ry = y;
			var rectX:Number = -x - buff_x;
			var rectY:Number = -y - buff_y;
			var rectW:int = this.sw + this.buff_x * 2;
			var rectH:int = this.sh + this.buff_y * 2;
			var dp:Point = new Point(0, 0);
			this.bitmapData.copyPixels(source, new Rectangle(rectX, rectY, rectW, rectH), dp);
		}
		
		//设置OSD屏幕的基准坐标
		public function setPositon(nx:int, ny:int):void
		{
			nx -= this.buff_x;
			ny -= this.buff_y;
			this.px = nx;
			this.py = ny;
			this.x = nx;
			this.y = ny;
		}
		
		//按向量去移动
		public function scroll(vx:int, vy:int):void
		{
			//拦截小数
			if (vx)
			{
				if (rx + vx > 0) 
					vx = -rx;
				else if (source.width - sw < -rx - vx)
					vx = -source.width + sw - rx;
				this.x += vx;
				this.rx += vx;
				
				this.chkOverFlowX();
			}
			if (vy)
			{
				this.y += vy;
				this.ry += vy;
				this.chkOverFlowY();
			}
		}
		
		private function chkOverFlowX():void
		{
			var rect:Rectangle = new Rectangle();
			var dp:Point;
			var offset:Point;
			
			//右边越界
			if (x <= this.px - buff_x)
			{
				offset = new Point(this.px - this.x, this.y - this.py);
				dp = new Point(this.sw + buff_x * 2 - offset.x, 0);
				//源矩形
				rect.x = -this.rx + this.sw + buff_x - offset.x;
				rect.y = -this.ry - buff_y + offset.y;
				rect.width = offset.x;
				rect.height = this.sh + this.buff_y * 2;
				
				bitmapData.lock();
				this.bitmapData.scroll(-offset.x, 0);
				//this.bitmapData.fillRect(new Rectangle(dp.x, dp.y, rect.width, rect.height), 0x000000);          
				this.bitmapData.copyPixels(source, rect, dp);
				bitmapData.unlock();
				
				this.x += offset.x;
			}
			else if(x >= this.px + buff_x)
			{       
				offset = new Point(this.x - this.px, this.y - this.py ); 
				dp = new Point(0, 0 );
				rect.x = - this.rx - buff_x;
				rect.y = - this.ry - buff_y + offset.y;
				rect.width = offset.x ;
				rect.height = this.sh + this.buff_y * 2;
				
				bitmapData.lock();
				this.bitmapData.scroll(offset.x, 0 );
				//this.bitmapData.fillRect(new Rectangle(dp.x, dp.y, rect.width, rect.height ), 0x000000 ); 
				this.bitmapData.copyPixels(source, rect, dp ); 
				bitmapData.unlock();
				 
				this.x -= offset.x;    
			}
		}
		
		private function chkOverFlowY():void
		{
			var rect:Rectangle = new Rectangle();
			var dp:Point;
			var offset:Point;
			
			//下边越界
			if (y <= this.py - this.buff_y)
			{
				offset = new Point(this.x - this.px, this.py - this.y);
				dp = new Point(0, this.sh + buff_y * 2 - offset.y);
				//源矩形
				rect.x = -this.rx - buff_x + offset.x;
				rect.y = -this.ry + this.sh + buff_y - offset.y;
				rect.width = this.sw + this.buff_x * 2;
				rect.height = offset.y;
				
				this.bitmapData.scroll(0, -offset.y);
				this.bitmapData.fillRect(new Rectangle(dp.x, dp.y, rect.width, rect.height), 0x000000);
				this.bitmapData.copyPixels(source, rect, dp);
				this.y += offset.y;
			}
			else if (y >= this.py + this.buff_y)
			{
				
				offset = new Point(this.x - this.px, this.y - this.py);
				dp = new Point(0, 0);
				//源矩形
				rect.x = -this.rx - buff_x + offset.x;
				rect.y = -this.ry - buff_y;
				rect.width = this.sw + this.buff_x * 2;
				rect.height = offset.y;
				
				this.bitmapData.scroll(0, offset.y);
				this.bitmapData.fillRect(new Rectangle(dp.x, dp.y, rect.width, rect.height), 0x000000);
				this.bitmapData.copyPixels(source, rect, dp);
				this.y -= offset.y;
			}
		}
	}
}
