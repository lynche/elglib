/*
VERSION: 1.0 DATE:2009/11/20
ACTIONSCRIPT VERSION: 3.0
AUTHOR: DFdou, k5love@foxmail.com
Copyright 2009, nwhy.org. All rights reserved.
 
DESCRIPTION:
    Captcha is a simple class to generate Caphtcha Sprite.
 
PARAMETERS:
    1) type:String="number": Captcha type you want to create, there are four types ["number","character","math","bt"];
    2) length:uint=5: Captcha length,work with type ["number","character"];
    3) noiseFlag:Boolean=true: if true Captcha will draw noise;
    4) size:uint=18: textfiled's fontsize;
 
NOTES:
    - when the Captcha was changed,will dispatch an event named "change",then you can addEventListener to capture it.
 
EXAMPLE:
    var cp:Captcha = new Captcha(); //default Captcha as number type width noise,length=5,size=18;
    var cp:Captcha = new Captcha("character", 4); //character type Captcha,length=4;
    var cp:Captcha = new Captcha("bt", 0, false, 20); //bt type Captcha width no noise,and fontsize=20;
 */
package Elegant.utils.bitmap
{
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFieldAutoSize;
    public class Captcha extends Sprite {
        private var __type:String;
        private var __length:uint;
        private var __size:uint;
        private var __tft:TextFormat = new TextFormat();
        private var __noiseFlag:Boolean;
        private var __aryType:Array=["number","character","math","bt"];
        private var __aryCharacters:Array=["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"];
        private var __randCode:String="";
 
        private const CHANGE:String="change";
        private var sp_cont:Sprite=new Sprite();
        private var sp_noise:Sprite=new Sprite();
 
        public function Captcha(type:String="number",length:uint=5,noiseFlag:Boolean=true,size:uint=18):void {
            __type = type;
            __length = length;
            __noiseFlag = noiseFlag;
            __size = size;
 
            __tft.font = "Arial";
            __tft.size=__size;
            __tft.bold = true;
            sp_cont.x=__size/2;
            addChild(sp_cont);
            if (__aryType.indexOf(__type)==-1) {
                __type=__aryType[3];
            }
            reRandCaptcha(null);
            addEventListener(MouseEvent.MOUSE_DOWN,reRandCaptcha);
        }
        private function reRandCaptcha(_e:MouseEvent):void
		{
            removeAllChild(sp_cont);
            randCaptcha(__type);
            drawNoise();
            drawBorder();
            dispatchEvent(new Event(CHANGE));
        }
        private function randCaptcha(type:String):void {
            __randCode="";
            switch (type) {
                case __aryType[0] :
                    randCaptchaWithNumber();
                    break;
                case __aryType[1] :
                    randCaptchaWithCharacter();
                    break;
                case __aryType[2] :
                    randCaptchaWithMath();
                    break;
                case __aryType[3] :
                    randCaptchaWithBt();
                    break;
                default:
                    randCaptchaWithNumber();
            }
        }
        private function randCaptchaWithNumber():void {
            for (var i:uint=0; i<__length; i++) {
                var tf:TextField=new TextField();
                tf.text = String(randInt(0,9));
                __randCode+=tf.text;
                tf.selectable = false;
                tf.x = int(__tft.size) * i;
                tf.textColor = randInt(0,0x888888);
                tf.autoSize = TextFieldAutoSize.LEFT;
                tf.setTextFormat(__tft);
                sp_cont.addChild(tf);
            }
        }
        private function randCaptchaWithCharacter():void {
            for (var i:uint=0; i<__length; i++) {
                var tf:TextField=new TextField();
                tf.text = __aryCharacters[randInt(0,51)];
                __randCode+=tf.text;
                tf.selectable = false;
                tf.x = int(__tft.size) * i;
                tf.textColor = randInt(0,0x888888);
                tf.autoSize = TextFieldAutoSize.LEFT;
                tf.setTextFormat(__tft);
                sp_cont.addChild(tf);
            }
            __randCode = __randCode.toLowerCase();
        }
        private function randCaptchaWithMath():void {
            var rand1:uint=randInt(0,5);
            var rand2:uint=randInt(0,10);
            var rand3:uint=randInt(0,5);
            var rand4:uint=randInt(0,10);
            var tf:TextField=new TextField();
            tf.text = "(" + rand1 + "+" + rand2 + ")" + "*(" + rand3 + "+" + rand4 + ")";
            tf.selectable = false;
            tf.textColor = randInt(0,0x888888);
            tf.autoSize = TextFieldAutoSize.LEFT;
            tf.setTextFormat(__tft);
            sp_cont.addChild(tf);
            __randCode = String((rand1+rand2)*(rand3+rand4));
        }
        private function randCaptchaWithBt():void {
            var rand1:Number = Number(randNumber(0,Math.PI).toFixed(2));
            var rand2:Number = Number(randNumber(0,Math.PI).toFixed(2));
            var tf:TextField = new TextField();
            tf.text = "Math.pow(" + rand1 + ",Math.log(" + rand2 + "))";
            tf.selectable = false;
            tf.textColor = randInt(0,0x888888);
            tf.autoSize = TextFieldAutoSize.LEFT;
            tf.setTextFormat(__tft);
            sp_cont.addChild(tf);
            __randCode = Math.pow(rand1,Math.log(rand2)).toFixed(3);
        }
        private function drawNoise():void{
            if (__noiseFlag)
			{
                sp_noise.graphics.clear();
                for (var i:int = 0; i < 25; i++)
				{
                   var ptx:int = randInt(1,width);
                   var pty:int = randInt(1,height);
                   var ex:int = ptx + randInt( -width, width);
                   var ey:int = pty + randInt( -height, height);
                   ex = ((ex <= 1) ? 1 : ((ex>=(width))?(width):ex));
                   ey = ((ey <= 1) ? 1 : ((ey>=height-1)? height-1 : ey)); 
                   sp_noise.graphics.lineStyle(1,randInt(0,0xFFFFFF),0.25);
                   sp_noise.graphics.moveTo(ptx,pty);
                   sp_noise.graphics.lineTo(ex,ey);
                }
                sp_noise.width= sp_cont.width + __size;
                sp_noise.height= sp_cont.height;
                addChild(sp_noise);
            }
            return;
        }
        private function drawBorder():void{
            graphics.clear();
            graphics.lineStyle(1,0x006699);
            graphics.drawRect(0,0,sp_cont.width+__size,height);
            graphics.beginFill(0);
        }
        private function removeAllChild(container:DisplayObjectContainer):void
		{
            while(container.numChildren>0){
                container.removeChildAt(0);
            }
        }
        private function randInt(min:int,max:int):int {
            return Math.random() * (max - min) + min;
        }
        private function randNumber(min:Number,max:Number):Number {
            return Math.random() * (max - min) + min;
        }
        public function get captcha():String{
            return __randCode;
        }
    }
}