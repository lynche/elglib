package Elegant.controls 
{
	//import com.greensock.events.LoaderEvent;
	//import com.greensock.loading.ImageLoader;
	//import com.greensock.TweenMax;
	//import com.greensock.TweenNano;
	import Elegant.interfaces.ITransformEffect;
	import Elegant.transformEffects.BasicTransformEffect;
	import Elegant.utils.InitObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * 图片轮播浏览
	 * @author 浅唱
	 */
	public class ImageCarousel extends Sprite 
	{
		private var urls:Array;
		private var links:Array;
		private var container:Sprite;
		
		private var _mdots:MDots;
		private var effect:ITransformEffect;
		private var _isPlaying:Boolean;
		private var _cunrrentFrame:int;
		private var _nextFrame:uint;
		//private var imageLoader:ImageLoader;
		private var duration:Number;
		private var timeout:int;
		
		/**
		 * 
		 * @param	urls
		 * @param	effect
		 * @param	mdotRef
		 * @param	objectVars
		 */
		//public function ImageCarousel(urls:Array, effect:ITransformEffect, mdotRef:Class = null, objectVars:Object = null) 
		//{
			//super();
			//this.urls = urls;
			//this.effect = effect;
			//
			//container = new Sprite();
			//addChild(container);
			//if(mdotRef != null)
			//{
				//_mdots = new MDots(mdotRef, urls.length, goto);
				//_mdots.x = InitObject.getInt(objectVars, "mdotX", int.MIN_VALUE);
				//_mdots.y = InitObject.getInt(objectVars, "mdotY", int.MIN_VALUE);
				//_mdots.alpha = 0;
				//
				//if (_mdots.x != int.MIN_VALUE && _mdots.y != int.MIN_VALUE)
					//TweenNano.to(_mdots, .5, { alpha:1 } );
				//
				//addChild(_mdots);
			//}
			//
			//_cunrrentFrame = -1;
			//duration = InitObject.getNumber(objectVars, "duration", 5);
			//links = InitObject.getArray(objectVars, "links");
			//play();
		//}
		//
		//public function goto(frame:int):void
		//{
			//clearTimeout(timeout);
			//
			//if(frame >= urls.length)
				//frame = 0;
			//
			//_nextFrame = frame;
			//
			//if (imageLoader)
			//{
				//imageLoader.cancel();
				//imageLoader.dispose();
			//}
			//
			//imageLoader = new ImageLoader(urls[frame], { autoDispose:true, onComplete:onImageComplete } );
			//imageLoader.load();
		//}
		//
		//public function play():void
		//{
			//_isPlaying = true;
			//
			//var frame:int = _cunrrentFrame + 1
			//if(frame >= urls.length)
				//frame = 0;
			//
			//mdots.dotIndex = frame;
		//}
		//
		//public function stop():void
		//{
			//_isPlaying = false;
			//clearTimeout(timeout);
		//}
		//
		//----------------------Event Handler---------------------------
		//
		//private function onImageComplete(e:LoaderEvent):void 
		//{
			//if (container.numChildren == 0)
			//{
				//effect.show(imageLoader.content, container);
			//}
			//else
			//{
				//_mdots.mouseChildren = false;
				//effect.exchange(container.getChildAt(0), imageLoader.content, {toLeft:_cunrrentFrame < _nextFrame, onComplete:reMdots});
			//}
			//
			//_cunrrentFrame = _nextFrame;
			//
			//if (links && links[_cunrrentFrame])
			//{
				//container.buttonMode = true;
				//this.addEventListener(MouseEvent.ROLL_OVER, onContainerRollOver);
				//this.addEventListener(MouseEvent.ROLL_OUT, onContainerRollOut);
				//container.addEventListener(MouseEvent.CLICK, onContainerClick);
			//} else {
				//container.buttonMode = false;
				//this.removeEventListener(MouseEvent.ROLL_OVER, onContainerRollOver);
				//this.removeEventListener(MouseEvent.ROLL_OUT, onContainerRollOut);
				//container.removeEventListener(MouseEvent.CLICK, onContainerClick);
			//}
			//
			//if(isPlaying)
				//timeout = setTimeout(play, duration * 1000);
		//}
		//
		//private function reMdots():void 
		//{
			//_mdots.mouseChildren = true;
		//}
		//
		//private function onContainerRollOver(e:MouseEvent):void 
		//{
			//TweenMax.to(container, .4, { colorTransform:{tint:0x000000, tintAmount:0.1} } );
		//}
		//
		//private function onContainerRollOut(e:MouseEvent):void 
		//{
			//TweenMax.to(container, .4, { removeTint:true } );
		//}
		//
		//private function onContainerClick(e:MouseEvent):void 
		//{
			//navigateToURL(new URLRequest(links[_cunrrentFrame]), "_blank");
		//}
		//
		//-----------------------getter / setter-------------------------
		//public function get mdots():MDots 
		//{
			//return _mdots;
		//}
		//
		//public function get isPlaying():Boolean 
		//{
			//return _isPlaying;
		//}
		//
		//public function get cunrrentFrame():uint 
		//{
			//return _cunrrentFrame;
		//}
	}

}