package Elegant.utils
{
	
	/**
	 * ...
	 * @author 浅唱
	 * @copyright 513151217@qq.com
	 * @version 1.0
	 */
	public final class VectorUtil
	{
		/**
		 * 查找数组中某属性值等于obj的对象的索引
		 * @param	arr or vec
		 * @param	obj
		 * @param	properties
		 * @return
		 */
		public static function indexInVec(vec:Vector.<Object>, obj:Object, properties:String = ""):int
		{
			var i:int;
			var item:* = null;
			
			//不想把if放在for里面,判断多余,所以这样写
			if (properties == "")
			{
				for each (item in vec) 
				{
					if (item == obj)
						return i;
					i++;
				}
			}
			else
			{
				for each (item in vec) 
				{
					if (item[properties] == obj)
						return i;
					i++;
				}
			}
			return -1;
		}
		
		/**
		 * 快速排序
		 * @param	arr	值数组
		 */
		public static function quickSort(vec:Vector.<Number>):void
		{
			var targetVec:Vector.<Number> = vec;
			function QuickSort(A:Vector.<Number>, low:int, hig:int):void
			{
				var i:int = low, j:int = hig;
				var mid:Number = Number(A[(low + hig) >> 1]);
				do
				{
					while (A[i] < mid)
					{
						i++;
					}
					while (A[j] > mid)
					{
						j--;
					}
					if (i <= j)
					{
						var temp:Number = A[i];
						A[i] = A[j];
						A[j] = temp;
						i++;
						j--;
					}
				} while (i <= j);
				if (low < j)
				{
					arguments.callee(A, low, j);
				}
				if (i < hig)
				{
					arguments.callee(A, i, hig);
				}
			}
			QuickSort(targetVec, 0, targetVec.length - 1);
		}
		
		/**
		 * 快速排序,以某个属性对vector的某个数字参数
		 * @param	arr		对象数组
		 * @param	attr	属性 必须是数字
		 */
		public static function quickSortProperties(vec:Vector.<*>, attr:String):void
		{
			if (vec.length < 2)
				return;
			
			var targetArr:Vector.<*> = vec;
			var temp:*;
			
			function QuickSort(A:Vector.<*>, low:int, hig:int):void
			{
				var i:int = low, j:int = hig;
				var mid:Number = A[(low + hig) >> 1][attr];
				var tx:Number;
				do
				{
					tx = A[i][attr];
					while (tx < mid)
					{
						i++;
						tx = A[i][attr];
					}
					
					tx = A[j][attr];
					while (tx > mid)
					{
						j--;
						tx = A[j][attr];
					}
					
					if (i <= j)
					{
						temp = A[i];
						A[i] = A[j];
						A[j] = temp;
						i++;
						j--;
					}
				} while (i <= j);
				if (low < j)
				{
					arguments.callee(A, low, j);
				}
				if (i < hig)
				{
					arguments.callee(A, i, hig);
				}
			}
			QuickSort(targetArr, 0, targetArr.length - 1);
		}
	}
}