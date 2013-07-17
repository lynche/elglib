package lynch.net.loading 
{
	//import com.demonsters.debugger.MonsterDebugger;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	/**
	 * @private
	 * @author 小痛
	 */
	internal class LynchLoader extends URLLoader 
	{
		/**
		 * any data you want to save here
		 */
		public var customData:* = null;
		/**
		 * @private
		 */
		public var id:int;
		/**
		 * @private
		 */
		public var lpID:int;
		/**
		 * @private
		 */
		public var lp:LoaderParams;
		/**
		 * @private
		 */
		public var convertContext:LoaderContext;
		
		public var url:String = "";
		
		private var onComplete:Function;
		private var needConvert:Boolean;
		private var loader:Loader;
		private var alternateURL:String;
		
		/**
		 * @private
		 * @param	request
		 * @param	onComplete
		 * @param	needConvert
		 * @param	dataFormat
		 * @param	alternateURL
		 */
		public function LynchLoader(url:String = null, onComplete:Function = null, needConvert:Boolean = false, dataFormat:String = "binary", alternateURL:String = "") 
		{
			super();
			this.url = url;
			this.dataFormat = dataFormat;
			this.onComplete = onComplete;
			this.needConvert = needConvert;
			this.alternateURL = alternateURL;
			addEventListener(Event.COMPLETE, onCompleteHandler);
			addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
		}
		
		override public function load(request:URLRequest):void 
		{
			request ||= new URLRequest(url);
			super.load(request);
		}
		
		private function onCompleteHandler(e:Event):void 
		{
			e.stopImmediatePropagation();
			if (needConvert)
			{
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onConvertComplete);
				loader.loadBytes(data, convertContext);
			} else 
			{
				dispose();
			}
		}
		
		private function onConvertComplete(e:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onConvertComplete);
			data = loader.content;
			dispose();
		}
		
		private function onIOErrorHandler(e:IOErrorEvent):void 
		{
			data = null;
			//MonsterDebugger.trace(this, "IOError the url=" + url);
			trace(this, "IOError the url=" + url);
			
			//when not null and not empty
			if (alternateURL && url != alternateURL)
			{
				load(new URLRequest(alternateURL));
			} else {
				dispose();
			}
		}
		
		private function dispose():void
		{
			if (onComplete != null)
				onComplete(this);
			
			customData = null;
			onComplete = null;
			loader = null;
			lp = null;
			removeEventListener(Event.COMPLETE, onCompleteHandler);
			removeEventListener(IOErrorEvent.IO_ERROR, dispose);
		}
	}

}