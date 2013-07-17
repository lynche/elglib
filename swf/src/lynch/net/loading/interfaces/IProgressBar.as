package lynch.net.loading.interfaces 
{
	
	/**
	 * ...
	 * @author 小痛
	 */
	public interface IProgressBar 
	{
		function updata(ratio:Number, bytesLoaded:int, bytesTotal:int, name:String):void
		function dispose():void
	}
}