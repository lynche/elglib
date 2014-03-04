package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	/**
	 * ...
	 * @author Lynch
	 */
	public class Test extends Sprite 
	{
		
		public function Test() 
		{
			super();
			//var file:File = new File();
			//file.addEventListener(Event.SELECT, onSelected);
			//file.browseForOpen("sgs");
		}
		
		private function onSelected(e:Event):void 
		{
			var file:File = e.currentTarget as File;
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			trace(stream.readMultiByte(stream.bytesAvailable, "utf-8"));
		}
		
	}

}