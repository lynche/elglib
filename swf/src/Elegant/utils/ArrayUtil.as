package Elegant.utils
{
	
	/**
	 * ...
	 * @author 浅唱
	 * @version 1.0
	 */
	public final class ArrayUtil
	{
		/**
		 * 查找数组中某属性值等于obj的对象的索引
		 * @param	arr or vec
		 * @param	obj
		 * @param	properties
		 * @return
		 */
		public static function indexInArray(arr:Array, obj:Object, properties:String = ""):int
		{
			var i:int;
			var item:* = null;
			
			//不想把if放在for里面,判断多余,所以这样写
			if (properties == "")
			{
				for each (item in arr)
				{
					if (item == obj)
						return i;
					i++;
				}
			}
			else
			{
				for each (item in arr)
				{
					if (item[properties] == obj)
						return i;
					i++;
				}
			}
			return -1;
		}
		
		/**
		 * 从数组中随机num个值出来
		 * @param	arr
		 * @param	num
		 * @return
		 */
		public static function randomInArr(arr:Array, num:int):Array
		{
			num = Math.min(num, arr.length);
			
			var temp:Object = {};
			var returnArr:Array = [];
			var i:int, al:int = arr.length;
			
			while (returnArr.length < num)
			{
				do
				{
					i = Math.random() * al;
				} while (temp[i] == true);
				
				temp[i] = true;
				returnArr.push(arr[i]);
			}
			return returnArr;
		}
		
		/**
		 * 快速排序
		 * @param	arr	值数组
		 */
		public static function quickSort(arr:Array):void
		{
			var targetArr:Array = arr;
			function QuickSort(A:Array, low:int, hig:int):void
			{
				var i:int = low, j:int = hig;
				var mid:Number = A[(low + hig) >> 1];
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
			QuickSort(targetArr, 0, targetArr.length - 1);
		}
		
		/**
		 * 快速排序,以某个属性对数组的某个数字参数
		 * 例:排序100000个sprite的x属性
		 * Array.sortOn 时间为 2400毫秒左右
		 * 该方法只需要 430多毫秒
		 * @param	arr		对象数组
		 * @param	attr	属性 必须是数字
		 */
		public static function quickSortProperties(arr:Array, attr:String):void
		{
			if (arr.length < 2)
				return;
			
			var targetArr:Array = arr;
			var temp:*;
			
			function QuickSort(A:Array, low:int, hig:int):void
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