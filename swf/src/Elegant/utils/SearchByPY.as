package Elegant.utils
{
	import flash.geom.Point;
	import flash.utils.ByteArray;
	/**
	 * 按拼音首字母索引observer里面的字符串
	 * @exampleText
	 * <list>
	 * SearchByPY.addToObserver("星暴国际","天使之城","什么什么什么","xb","行报");
	 * trace(SearchByPY.search("xb")); //输出: 星暴国际,xb,行报
	 * </list>
	 * @author 浅唱
	 */
	public final class SearchByPY 
	{	
		/**
		 * 存放原始字符
		 */
		public var dictionary:Array = [];
		/**
		 * 存放首字母
		 */
		private var asStrings:Array = [];
		
		public function SearchByPY() {
			
		}
		
		/**
		 * 添加到索引数组
		 * @param	args 字符串或者array
		 * @return  int observer 的长度
		 */
		public function addToDictionary(...args):int
		{
			var index:int;
			for (var i:int = 0; i < args.length; i += 1)
			{
				if ((typeof args[i]) == "object")
				{
					for (var s:* in args[i])
					{
						index = dictionary.length;
						var lowerCase:String = String(args[i][s]).toLowerCase();
						dictionary[index] = lowerCase;
						asStrings[index] = toPYFirstABC(lowerCase);
					}
				}
				else {
					index = dictionary.length;
					dictionary[index] = String(args[i]).toLowerCase();
					asStrings[index] = toPYFirstABC(dictionary[index]);
				}
			}
			return dictionary.length;
		}
		
		/**
		 * 将字符串从Dictionary里面移除
		 * @param	str
		 */
		public function removeFromDictionary(str:String):void
		{
			for (var i:int = 0; i < dictionary.length; i += 1)
			{
				if (str == dictionary[i])
				{
					dictionary.splice(i, 1);
					asStrings.splice(i, 1);
					return;
				}
			}
		}
		
		/**
		 * 清空observer
		 */
		public function clear():void
		{
			dictionary = [];
			asStrings = [];
		}
		
		/**
		 * 按拼音搜索
		 * @param	str			要从dictionary中搜索的字符串
		 * @param	codeAsPY	汉字作为拼音搜索
		 * @param	makeHighLight
		 * @param	color
		 * @param	dictionaryArr
		 * @return	{match:returnArr, index:indexArr};
		 */
		public function search(str:String, codeAsPY:Boolean = true, makeHighLight:Boolean = false, color:uint = 0xff0000, dictionaryArr:Array = null):Object
		{
			var py:Array = str.split("");
			var returnArr:Array, indexArr:Array = [];
			var hasCode:Boolean = false;
			for (var q:int = 0; q < py.length; q += 1)
			{
				if (String(py[q]).search(/^[\u4e00-\u9fa5]+$/) != -1)//如果有汉字
				{
					if (codeAsPY) py[q] = firstABC(py[q]);
					else hasCode = true;
				}
				py[q] = String(py[q]).toLowerCase();
			}
			
			var searchArr:Array = hasCode ? dictionary : asStrings;
			var dl:int = searchArr.length;
			returnArr = [];
			for (var s:int = 0; s < dl; s += 1)
			{
				var tempArr:Array = searchArr[s].split("");
				var vec:int = 0;
				var reSeachFrom:int = 0;
				var canFind:Boolean = false;
				var stIndex:int = seachTargetArr(tempArr);
				if (canFind)
				{
					var index:int = returnArr.length;
					returnArr[index] = dictionary[s];
					if (makeHighLight && stIndex >= 0)
					{
						returnArr[index] = highLightIndex(returnArr[index], stIndex, py.length, color);
					}
					indexArr[index] = s;
				}
			}
			function seachTargetArr(targetArr:Array):int
			{
				//用作高亮
				var startIndex:int = -1;
				var pyl:int = py.length;
				var tl:int = targetArr.length;
				
				parent:
				for (var k:int = 0; k < pyl; k += 1)
				{
					if (k > targetArr.length - reSeachFrom)//长度不足
					{
						canFind = false;
						return -1;
					}
					
					for (var i:int = canFind ? vec : reSeachFrom; i < tl; i += 1)
					{
						if (!canFind)
						{
							if (tempArr[i] == py[0])//找到第一匹配项
							{
								startIndex = i;
								vec = i + 1;
								reSeachFrom = vec;
								canFind = true;
								continue parent;
							}else if (i == targetArr.length - 1)//不能找到第一匹配项
							{
								canFind = false;
								return -1;
							}
						} else {
							if (targetArr[i] == py[k])//依次匹配
							{
								canFind = true;
								vec = i + 1;
								continue parent;
							}
							else {//不能再继续匹配
								canFind = false;
								return seachTargetArr(targetArr);
							}
						}
					}
				}
				return startIndex;
			}
			return {match:returnArr, index:indexArr};
		}
		
		/**
		 * 高亮显示
		 * @param	from		要设置高亮的字符
		 * @param	lightWord	哪些字符高亮
		 * @param	color		高亮颜色
		 * @return
		 */
		public static function highLight(from:String, lightWord:String, color:uint = 0xff0000):String
		{
			var myPattern:RegExp = new RegExp(lightWord, "g");
			var returnStr:String = "";
			var result:Object = myPattern.exec(from);
			
			//上个字符串结束位置
			var lastStrIndex:int;
            while (result != null) 
			{
				returnStr += from.substring(lastStrIndex, result.index);
				returnStr += "<font color='#" + color.toString(16) + "'>" + result + "</font>";
				lastStrIndex = result.index + result.length;
				result = myPattern.exec(from);
			}
			returnStr += from.substring(lastStrIndex);
			return returnStr;
		}
		
		private static function highLightIndex(from:String, startIndex:int, len:int, color:uint = 0xff0000):String
		{
			var returnStr:String;
			var result:String = from.substr(startIndex, len);
			returnStr = from.substring(0, startIndex);
			returnStr += "<font color='#" + color.toString(16) + "'>" + result + "</font>";
			returnStr += from.substring(startIndex + len);
			return returnStr;
		}
		
		private static function Trim(info:String):String 
		{
			return info.replace(/(^\s*)|(\s*$)/g,"");
		}
		/**
		 * 系统字符
		 * @param	argValue
		 */
		public static function isEnKong(argValue:String):Boolean 
		{
			var flag:Boolean=false;
			var compStr:String="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890!@#$%^&*()_-+=|\{[}]:;'<,>.?/ ";
			var length:int=argValue.length;
			for (var iIndex:int=0; iIndex<length; iIndex++) {
				var temp:int=compStr.indexOf(argValue.charAt(iIndex));
				if (temp == -1) 
				{
					flag=false;
				} else {
					flag=true;
				}
			}
			return flag;
		}
		
		/**
		 * 汉字to ASC编码
		 * @param	cn
		 */
		public static function cn2asc(cn:String):String {
			var m:RegExp=/[^\x00-\xff]/g;
			var n:String=cn;
			var a:String=n;
			while (a == m.exec(n)) 
			{
				a=a.split(a).join(escape(a).split("%u").join(""));
			}
			return a;
		}
		
		/**
		 * 得到拼音首字母
		 * @param	str
		 * @return
		 */
		public static function toPYFirstABC(str:String):String
		{
			var py:Array = [];
			var l:int = str.length;
			for (var i:int = 0; i < l; i++) 
			{
				var char:String = str.charAt(i);
				py[i] = char.charCodeAt(0) < 200 ? char : firstABC(char);
			}
			return py.join("");
		}
		
		/**
		 * 获取中文第一个字的拼音首字母(单个字符)
		 * @param chineseChar
		 * @return 
		 * 
		 */  
		public static function firstABC(chineseChar:String):String
		{
			var bytes:ByteArray = new ByteArray
			bytes.writeMultiByte(chineseChar, "cn-gb");
			var n:int = bytes[0] << 8;
			n += bytes[1];
			if (isIn(0xB0A1, 0xB0C4, n))
			 return "a";
			if (isIn(0XB0C5, 0XB2C0, n))
			 return "b";
			if (isIn(0xB2C1, 0xB4ED, n))
			 return "c";
			if (isIn(0xB4EE, 0xB6E9, n))
			 return "d";
			if (isIn(0xB6EA, 0xB7A1, n))
			 return "e";
			if (isIn(0xB7A2, 0xB8c0, n))
			 return "f";
			if (isIn(0xB8C1, 0xB9FD, n))
			 return "g";
			if (isIn(0xB9FE, 0xBBF6, n))
			 return "h";
			if (isIn(0xBBF7, 0xBFA5, n))
			 return "j";
			if (isIn(0xBFA6, 0xC0AB, n))
			 return "k";
			if (isIn(0xC0AC, 0xC2E7, n))
			 return "l";
			if (isIn(0xC2E8, 0xC4C2, n))
			 return "m";
			if (isIn(0xC4C3, 0xC5B5, n))
			 return "n";
			if (isIn(0xC5B6, 0xC5BD, n))
			 return "o";
			if (isIn(0xC5BE, 0xC6D9, n))
			 return "p";
			if (isIn(0xC6DA, 0xC8BA, n))
			 return "q";
			if (isIn(0xC8BB, 0xC8F5, n))
			 return "r";
			if (isIn(0xC8F6, 0xCBF0, n))
			 return "s";
			if (isIn(0xCBFA, 0xCDD9, n))
			 return "t";
			if (isIn(0xCDDA, 0xCEF3, n))
			 return "w";
			if (isIn(0xCEF4, 0xD188, n))
			 return "x";
			if (isIn(0xD1B9, 0xD4D0, n))
			 return "y";
			if (isIn(0xD4D1, 0xD7F9, n))
			 return "z";
			return "\0";
		}

		private static function isIn(from:int, to:int, value:int):Boolean
		{
			return ((value >= from) && (value <= to));
		}
	}
}