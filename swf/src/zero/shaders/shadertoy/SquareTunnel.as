/***
SquareTunnel
创建人：ZЁЯ¤　身高：168cm+；体重：57kg+；未婚（已有女友）；最爱的运动：睡觉；格言：路见不平，拔腿就跑。QQ：358315553。
创建时间：2012年12月07日 16:59:59
简要说明：这家伙很懒什么都没写。
用法举例：这家伙还是很懒什么都没写。
*/

package zero.shaders.shadertoy{
	import flash.display.*;
	import flash.geom.*;
	import flash.utils.*;
	import zero.shaders.*;
	
	/**
	 * 
	 * Square Tunnel
	 * 
	 */	
	public class SquareTunnel extends BaseShader{
		
		public static const nameV:Vector.<String>=new <String>["alpha","time"];
		//SquareTunnelCode//为了编译进来
		public static const byteV:Vector.<int>=new <int>[0xa5,0x01,0x00,0x00,0x00,0xa4,0x0c,0x00,0x53,0x71,0x75,0x61,0x72,0x65,0x54,0x75,0x6e,0x6e,0x65,0x6c,0xa0,0x0c,0x6e,0x61,0x6d,0x65,0x73,0x70,0x61,0x63,0x65,0x00,0x7a,0x65,0x72,0x6f,0x2e,0x73,0x68,0x61,0x64,0x65,0x72,0x73,0x2e,0x73,0x68,0x61,0x64,0x65,0x72,0x74,0x6f,0x79,0x00,0xa0,0x0c,0x76,0x65,0x6e,0x64,0x6f,0x72,0x00,0x5a,0xa7,0xa7,0xa7,0xc1,0xa1,0xe8,0x00,0xa0,0x08,0x76,0x65,0x72,0x73,0x69,0x6f,0x6e,0x00,0x02,0x00,0xa0,0x0c,0x64,0x65,0x73,0x63,0x72,0x69,0x70,0x74,0x69,0x6f,0x6e,0x00,0x53,0x71,0x75,0x61,0x72,0x65,0x20,0x54,0x75,0x6e,0x6e,0x65,0x6c,0x00,0xa1,0x01,0x02,0x00,0x00,0x0c,0x5f,0x4f,0x75,0x74,0x43,0x6f,0x6f,0x72,0x64,0x00,0xa1,0x01,0x01,0x00,0x00,0x02,0x61,0x6c,0x70,0x68,0x61,0x00,0xa1,0x01,0x01,0x00,0x00,0x01,0x74,0x69,0x6d,0x65,0x00,0xa1,0x01,0x02,0x01,0x00,0x0c,0x73,0x72,0x63,0x53,0x69,0x7a,0x65,0x00,0xa2,0x0c,0x64,0x65,0x73,0x63,0x72,0x69,0x70,0x74,0x69,0x6f,0x6e,0x00,0xca,0xe4,0xc8,0xeb,0xcd,0xbc,0xcf,0xf1,0xb5,0xc4,0xbf,0xed,0xb8,0xdf,0x00,0xa2,0x0c,0x70,0x61,0x72,0x61,0x6d,0x65,0x74,0x65,0x72,0x54,0x79,0x70,0x65,0x00,0x69,0x6e,0x70,0x75,0x74,0x53,0x69,0x7a,0x65,0x00,0xa2,0x0c,0x69,0x6e,0x70,0x75,0x74,0x53,0x69,0x7a,0x65,0x4e,0x61,0x6d,0x65,0x00,0x73,0x72,0x63,0x00,0xa3,0x00,0x04,0x73,0x72,0x63,0x00,0xa1,0x02,0x04,0x02,0x00,0x0f,0x64,0x73,0x74,0x00,0x32,0x01,0x00,0x20,0x00,0x00,0x00,0x00,0x2a,0x01,0x00,0x20,0x00,0x00,0x80,0x00,0x1d,0x01,0x80,0x80,0x00,0x80,0x00,0x00,0x34,0x00,0x00,0x00,0x01,0x80,0x00,0x00,0x32,0x01,0x00,0x20,0x40,0x00,0x00,0x00,0x04,0x03,0x00,0xc1,0x01,0x00,0x10,0x00,0x03,0x03,0x00,0xc1,0x00,0x00,0x10,0x00,0x1d,0x03,0x00,0x31,0x01,0x00,0xa0,0x00,0x03,0x03,0x00,0x31,0x03,0x00,0x10,0x00,0x32,0x01,0x00,0x20,0x3f,0x80,0x00,0x00,0x1d,0x03,0x00,0xc1,0x03,0x00,0xb0,0x00,0x02,0x03,0x00,0xc1,0x01,0x00,0xa0,0x00,0x1d,0x01,0x00,0x31,0x03,0x00,0x10,0x00,0x32,0x03,0x00,0x80,0x00,0x00,0x00,0x00,0x32,0x03,0x00,0x40,0x00,0x00,0x00,0x00,0x1d,0x03,0x00,0x20,0x01,0x00,0x80,0x00,0x03,0x03,0x00,0x20,0x01,0x00,0x80,0x00,0x32,0x03,0x00,0x10,0x41,0x80,0x00,0x00,0x1d,0x04,0x00,0x80,0x03,0x00,0x80,0x00,0x07,0x04,0x00,0x80,0x03,0x00,0xc0,0x00,0x1d,0x03,0x00,0x20,0x01,0x00,0xc0,0x00,0x03,0x03,0x00,0x20,0x01,0x00,0xc0,0x00,0x32,0x03,0x00,0x10,0x41,0x80,0x00,0x00,0x1d,0x04,0x00,0x40,0x03,0x00,0x80,0x00,0x07,0x04,0x00,0x40,0x03,0x00,0xc0,0x00,0x1d,0x03,0x00,0x20,0x04,0x00,0x00,0x00,0x01,0x03,0x00,0x20,0x04,0x00,0x40,0x00,0x32,0x03,0x00,0x10,0x3d,0x00,0x00,0x00,0x1d,0x04,0x00,0x80,0x03,0x00,0x80,0x00,0x07,0x04,0x00,0x80,0x03,0x00,0xc0,0x00,0x1d,0x03,0x00,0x20,0x04,0x00,0x00,0x00,0x32,0x03,0x00,0x10,0x3f,0x00,0x00,0x00,0x1d,0x04,0x00,0x80,0x03,0x00,0xc0,0x00,0x03,0x04,0x00,0x80,0x00,0x00,0xc0,0x00,0x32,0x03,0x00,0x10,0x3f,0x00,0x00,0x00,0x04,0x04,0x00,0x40,0x03,0x00,0x80,0x00,0x03,0x04,0x00,0x40,0x03,0x00,0xc0,0x00,0x1d,0x03,0x00,0x10,0x04,0x00,0x00,0x00,0x01,0x03,0x00,0x10,0x04,0x00,0x40,0x00,0x1d,0x03,0x00,0x80,0x03,0x00,0xc0,0x00,0x32,0x03,0x00,0x10,0x3f,0x80,0x00,0x00,0x1d,0x04,0x00,0x80,0x01,0x00,0xc0,0x00,0x06,0x04,0x00,0x80,0x01,0x00,0x80,0x00,0x1d,0x04,0x00,0x40,0x03,0x00,0xc0,0x00,0x03,0x04,0x00,0x40,0x04,0x00,0x00,0x00,0x32,0x03,0x00,0x10,0x40,0x49,0x0f,0xf9,0x04,0x04,0x00,0x80,0x03,0x00,0xc0,0x00,0x03,0x04,0x00,0x80,0x04,0x00,0x40,0x00,0x1d,0x03,0x00,0x40,0x04,0x00,0x00,0x00,0x32,0x03,0x00,0x10,0x3f,0x80,0x00,0x00,0x1d,0x04,0x00,0x80,0x03,0x00,0xc0,0x00,0x02,0x04,0x00,0x80,0x03,0x00,0x40,0x00,0x1d,0x03,0x00,0x40,0x04,0x00,0x00,0x00,0x32,0x03,0x00,0x10,0x3f,0x80,0x00,0x00,0x1d,0x04,0x00,0x20,0x03,0x00,0x00,0x00,0x08,0x04,0x00,0x20,0x03,0x00,0xc0,0x00,0x1d,0x04,0x00,0x80,0x04,0x00,0x80,0x00,0x1d,0x04,0x00,0x20,0x03,0x00,0x40,0x00,0x08,0x04,0x00,0x20,0x03,0x00,0xc0,0x00,0x1d,0x04,0x00,0x40,0x04,0x00,0x80,0x00,0x32,0x03,0x00,0x10,0x3f,0x80,0x00,0x00,0x1d,0x04,0x00,0x31,0x01,0x00,0x10,0x00,0x02,0x04,0x00,0x31,0x03,0x00,0xf0,0x00,0x1d,0x05,0x00,0xc1,0x04,0x00,0x10,0x00,0x03,0x05,0x00,0xc1,0x04,0x00,0xb0,0x00,0x30,0x04,0x00,0xf1,0x05,0x00,0x10,0x00,0x1d,0x03,0x00,0x10,0x03,0x00,0x80,0x00,0x03,0x03,0x00,0x10,0x03,0x00,0x80,0x00,0x1d,0x05,0x00,0x80,0x03,0x00,0xc0,0x00,0x03,0x05,0x00,0x80,0x03,0x00,0x80,0x00,0x1d,0x06,0x00,0xf3,0x04,0x00,0x1b,0x00,0x03,0x06,0x00,0xf3,0x05,0x00,0x00,0x00,0x1d,0x02,0x00,0xf3,0x06,0x00,0x1b,0x00,0x1d,0x02,0x00,0x10,0x00,0x00,0x80,0x00,0x35,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x32,0x02,0x00,0x80,0x00,0x00,0x00,0x00,0x32,0x02,0x00,0x40,0x00,0x00,0x00,0x00,0x32,0x02,0x00,0x20,0x00,0x00,0x00,0x00,0x32,0x02,0x00,0x10,0x00,0x00,0x00,0x00,0x36,0x00,0x00,0x00,0x00,0x00,0x00,0x00];
		
		/**
		 * 
		 * 透明度 （0~1） 默认 1
		 * 
		 */
		public var alpha:Number;
		
		/**
		 * 
		 * uniform float time: current time in seconds. （0~10） 默认 0
		 * 
		 */
		public var time:Number;
		

		/**
		 * 
		 * 透明度 （0~1） 默认 1<br/>
		 * uniform float time: current time in seconds. （0~10） 默认 0<br/>
		 * 
		 */
		public function SquareTunnel(_alpha:Number=1,_time:Number=0){
			alpha=_alpha;
			(data.alpha as ShaderParameter).value=[];
			time=_time;
			(data.time as ShaderParameter).value=[];
			(data.srcSize as ShaderParameter).value=[];
		}
		
		override public function updateParams():void{
			(data.alpha as ShaderParameter).value[0]=alpha;
			(data.time as ShaderParameter).value[0]=time;
			(data.srcSize as ShaderParameter).value[0]=srcSize.x;
			(data.srcSize as ShaderParameter).value[1]=srcSize.y;
		}
		

	}
}