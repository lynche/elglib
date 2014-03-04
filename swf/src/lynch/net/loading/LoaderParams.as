package lynch.net.loading 
{
	import flash.display.DisplayObjectContainer;
	/**
	 * @private
	 * @author 小痛
	 */
	internal class LoaderParams 
	{
		/**
		 * @private
		 */
		public var onComplete:Function;
		/**
		 * @private
		 */
		public var id:int;
		/**
		 * @private
		 */
		public var userParams:Array;
		/**
		 * @private
		 */
		public var totalNums:int;
		/**
		 * @private
		 */
		public var name:String;
		/**
		 * @private
		 */
		public var cache:String;
		/**
		 * @private
		 */
		public var container:DisplayObjectContainer;
		/**
		 * @private
		 */
		public var objectVars:Object;
		
		public function LoaderParams(totalNums:int, userParams:Array, onComplete:Function) 
		{
			this.onComplete = onComplete;
			//this.refType = refType;
			this.totalNums = totalNums;
			this.userParams = userParams;
		}
		
		public function dispose():void
		{
			onComplete = null;
			userParams = null;
		}
	}
}