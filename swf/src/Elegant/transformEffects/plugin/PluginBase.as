package Elegant.transformEffects.plugin 
{
	/**
	 * ...
	 * @author 浅唱
	 */
	public class PluginBase 
	{
		protected var target:Object;
		protected var _name:String;
		
		public function PluginBase(target:Object) 
		{
			this.target = target;
			
		}
		
		public function action(ratio:Number, objectVars:Object = null):void
		{
			trace(ratio, objectVars);
		}
		
		public function get name():String 
		{
			return _name;
		}
	}

}