package Elegant.utils{
	import Elegant.debug.Debug;
    import flash.net.Responder;
    import flash.net.NetConnection;
	/**
	 * Remoting类
	 * 负责FLASH与AMF交互
	 * @author 浅唱
	 */
    public class Remoting extends NetConnection 
	{
		public static var defaultURL:String = "";
        /**
         * 构造
         * @param gatewayURL remoting网关地址
         * @param amfType 使用AMF3或AMF0
        */
        public function Remoting(gatewayURL:String, amfType:uint) 
		{
            super();
            this.objectEncoding = amfType;
            this.connect(gatewayURL);
        }
        //##########################################################################
        //
        //方法
        //
        //##########################################################################
        /**
         * 远程返回函数
         * @param remoteMethod:远程类.方法名param远程方法所需要的参数onResultFun:返回数据所调用的方法句柄.onFaultFun同理.
         * 
        */
        public function respond(remoteMethod:String, onResultFun:Function, onFaultFun:Function, ... param):void 
		{
            var parameters:Array = param;
            if (param.length > 0) 
			{
                parameters.unshift(remoteMethod, new Responder(onResultFun, onFaultFun));
                this.call.apply(this, parameters);
            } else {
                this.call(remoteMethod, new Responder(onResultFun, onFaultFun));
            }
        }
		public static function onFaults(e:*):void
		{
			Debug.append("AMF失败 " + e);
		}
	}
}