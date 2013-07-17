package lynch.net.loading 
{
	import Elegant.ELGManager;
	import Elegant.utils.InitObject;
	import lynch.net.loading.interfaces.IProgressBar;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * @author lynch
	 */
	public class ResLoader 
	{
		/**
		 * instance of ResLoader, seems to no need.
		 * @private
		 */
		public static const resLoader:ResLoader = new ResLoader();
		public static var defaultAlternateURL:String = "";
		public static var urlRoot:String = "";
		
		private var loading:Vector.<LynchLoader>;
		private var sequence:Vector.<LynchLoader>;
		private var progressBar:IProgressBar;
		private var totalNum:int;
		private var currentNum:int;
		private var cacheHash:Dictionary;
		
		public function ResLoader() 
		{
			//for a continuous raw
			loading = new Vector.<LynchLoader>(10, true);
			sequence = new Vector.<LynchLoader>();
		}
		
		/**
		 * get datas in cache
		 * @param	name
		 * @return
		 */
		public static function getCacheDatas(name:String):Array
		{
			return resLoader.cacheHash[name];
		}
		
		/**
		 * for imgs
		 * @param	list
		 * @param	onComplete	make sure the first param is Array <!--Vector.<Bitmap>-->
		 * @param	alternateURL	autoload when a IOError be dispatched
		 * @param	objectVars	<li><strong> params : Array</strong> - user params, concat the default param
		 * 						<li><strong> cache : String</strong></li> - cache the bitmapData
		 * 						<li><strong> name : String</strong></li> - use for progressBar
		 * 						@private not realized yet <li><strong> container : DisplayObjectContainer</strong> - auto addChild to container
		 */
		public static function loadImgs(list:Array, onComplete:Function, alternateURL:String = "", objectVars:Object = null):void
		{
			alternateURL ||= defaultAlternateURL;
			resLoader.load(list, onComplete, true, "binary", alternateURL, objectVars);
		}
		
		/**
		 * for swfs
		 * @param	list
		 * @param	onComplete	make sure the first param is Array <!--Vector.<starling.display.Sprite>-->
		 * @param	objectVars	<li><strong> params : Array</strong></li> - user params, concat the default param
		 * 						<li><strong> context : LoaderContext</strong></li> - set applicationDomain
		 * 						<li><strong> cache : String</strong></li> - cache the swf
		 * 						<li><strong> name : String</strong></li> - use for progressBar
		 * 						<li><strong> container : DisplayObjectContainer</strong></li> - auto addChild to container
		 */
		public static function loadSWFs(list:Array, onComplete:Function, objectVars:Object = null):void
		{
			resLoader.load(list, onComplete, true, "binary", "", objectVars);
		}
		
		/**
		 * for binary texts
		 * @param	list
		 * @param	onComplete	make sure the first param is Array <!--Vector.<ByteArray>-->
		 * @param	objectVars	<li><strong> params : Array</strong></li> - user params, concat the default param
		 * 						<li><strong> cache : String</strong></li> - cache the binary data
		 * 						<li><strong> name : String</strong></li> - use for progressBar
		 */
		public static function loadDatas(list:Array, onComplete:Function, objectVars:Object = null):void
		{
			resLoader.load(list, onComplete, false, "binary", "", objectVars);
		}
		
		/**
		 * for texts
		 * @param	list
		 * @param	onComplete	make sure the first param is Array <!--Vector.<String>-->
		 * @param	objectVars	<li><strong> params : Array</strong></li> - user params, concat the default param
		 * 						<li><strong> name : String</strong></li> - use for progressBar
		 */
		public static function loadTexts(list:Array, onComplete:Function, objectVars:Object = null):void
		{
			resLoader.load(list, onComplete, false, "text", "", objectVars);
		}
		
		/**
		 * will update ratio to progressBar by IProgressBar.updata(ratio);
		 * at the current time, the last two params are always 0 1
		 * the progressBar will be set to null after all of sequence are loaded
		 * @param	progressBar
		 */
		public static function registerProgressBar(progressBar:IProgressBar):void
		{
			resLoader.progressBar = progressBar;
			ELGManager.stage.addEventListener(Event.ENTER_FRAME, resLoader.onProgressEnterFrame);
		}
		
		private function onProgressEnterFrame(e:Event):void 
		{
			var per:Number = 100 / totalNum;
			var bytesLoaded:Number = 0, bytesTotal:Number = 0;
			var loadingName:String = "";
			
			for each (var item:LynchLoader in loading) 
			{
				if(item)
				{
					bytesLoaded += item.bytesLoaded;
					bytesTotal += item.bytesTotal;
					loadingName ||= item.lp.name;
				}
			}
			
			if (progressBar) {
				progressBar.updata((Math.max(currentNum - 1, 0) * per + (bytesLoaded / bytesTotal) * per) >> 0, 
									bytesLoaded, bytesTotal, loadingName);
			}
		}
		
		private function load(list:Array, onComplete:Function, needConvert:Boolean = false, dataFormat:String = "binary", alternateURL:String = "", objectVars:Object = null):void
		{
			var param:Array = [ new Array(list.length) ];
			var userParam:Array = InitObject.getArray(objectVars, "params");
			if(userParam)
				param = param.concat(userParam);
			
			totalNum += list.length;
			
			var context:LoaderContext = LoaderContext(InitObject.getObject(objectVars, "context"));
			var lp:LoaderParams = new LoaderParams(list.length, param, onComplete);
			lp.name = InitObject.getString(objectVars, "name", "");
			lp.cache = InitObject.getString(objectVars, "cache", "");
			lp.container = InitObject.getObject(objectVars, "container") as DisplayObjectContainer;
			var i:int;
			
			var v:Vector.<LynchLoader> = new Vector.<LynchLoader>(list.length, true);
			for each (var item:String in list) 
			{
				var lynchloader:LynchLoader = new LynchLoader(urlRoot + item, readData, needConvert, dataFormat, alternateURL);
				lynchloader.id = i;
				lynchloader.lp = lp;
				lynchloader.convertContext = context;
				v[i++] = lynchloader;
			}
			
			sequence = v.concat(sequence);
			while(check() > -1)0; //while(true)(check() == -1) && break;
		}
		
		private function readData(lynchloader:LynchLoader):void
		{
			++currentNum;
			
			var lp:LoaderParams = lynchloader.lp;
			lp.userParams[0][lynchloader.id] = lynchloader.data;
			
			if (lp.container && lynchloader.data is DisplayObject)
				lp.container.addChild(lynchloader.data);
			
			if (--lp.totalNums == 0)
			{
				if (lp.cache)
					cacheHash[lp.cache] = lp.userParams[0];
				if(lp.onComplete != null)
					lp.onComplete.apply(null, lp.userParams);
				lp.dispose();
			}
			
			//some times, set to null is faster then splice
			var i:int = loading.indexOf(lynchloader);
			loading[i] = null;
			i = check(i);
			
			switch (i) 
			{
				//impossible
				case -1:
					break;
				//empty sequence
				case -2:
					//all the datas has be loaded
					if(totalNum == currentNum)
					{
						totalNum = currentNum = 0;
						if(progressBar)
						{
							ELGManager.stage.removeEventListener(Event.ENTER_FRAME, onProgressEnterFrame);
							progressBar.dispose();
							progressBar = null;
						}
					}
					break;
				//default:
					//if(progressBar)
					//{
						//var per:Number = 100 / totalNum;
						//progressBar.updata((currentNum - 1) * per + (lynchloader.bytesLoaded / lynchloader.bytesTotal) * per, 
											//lynchloader.bytesLoaded, lynchloader.bytesTotal, loading[i].lp.name);
					//}
			}
		}
		
		/**
		 * @param	i		assign index in loading
		 * @return	return  -1 		there is no any null place
		 * 					-2 		empty sequence
		 * 					others  the index of the LynchLoader in loading
		 */
		private function check(i:int = -1):int 
		{
			//nothing
			if (sequence.length == 0)
				return -2;
			
			if (i == -1)
			{
				//find a null place
				i = loading.indexOf(null);
				//if there is no place in loading
				if (i == -1)
					return -1;
			}
			
			loading[i] = sequence.shift();
			//url has already set
			loading[i].load(null);
			return i;
		}
		
		//------------------------------getter / setter----------------------
		/**
		 * get / set Maximum number of simultaneous connections that should be used while loading the queue. A higher number will generally result in faster overall load times for the group.
		 */
		public function get maxConnections():int 
		{
			return loading.length;
		}
		
		public function set maxConnections(value:int):void 
		{
			loading.fixed = false;
			loading.length = value;
			loading.fixed = true;
		}
	}
}