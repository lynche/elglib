package lynch.net
{
	import Elegant.utils.InitObject;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
    public class Share
    {
        public static const QQ:String = "qq";
        public static const DOUBAN:String = "douban";
        public static const SINA:String = "sina";
        public static const KAIXIN:String = "kaixin";
        public static const RENREN:String = "renren";
		public static var siteURL:String;
		
        public function Share()
        {
            
        }
		
		/**
		 * 
		 * @param	shareStr
		 * @param	shareType
		 * @param	objectVars
		 */
        public static function partake(shareStr:String, shareType:String, objectVars:Object = null) : void
        {
            var urlVars:URLVariables = new URLVariables();
            var urlRequest:URLRequest = new URLRequest();
            var date:Date = new Date();
			
            switch(shareType)
            {
                case SINA:
                {
                    urlVars.title = encodeURIComponent(shareStr);
                    urlVars.url = siteURL;
                    urlVars.type = 3;
                    urlVars.appkey = "";
                    urlVars.ralateUid = "";
                    urlVars.pic = InitObject.getString(objectVars, "picture", "");
                    urlVars.count = 1;
                    urlVars.rnd = date.toDateString();
                    urlRequest.url = "http://service.weibo.com/share/share.php";
                    break;
                }
                case QQ:
                {
                    urlVars.url = siteURL;
                    urlVars.site = siteURL;
                    urlVars.pic = InitObject.getString(objectVars, "picture", "");
                    urlVars.title = shareStr;
                    urlRequest.url = "http://v.t.qq.com/share/share.php";
                    break;
                }
                case RENREN:
                {
                    urlVars.title = encodeURIComponent(shareStr);
                    urlVars.link = encodeURIComponent(siteURL);
                    urlRequest.url = "http://share.renren.com/share/buttonshare";
                    break;
                }
                case KAIXIN:
                {
                    urlVars.rtitle = "";
                    urlVars.rcontent = shareStr + siteURL;
                    urlVars.rurl = siteURL;
                    urlRequest.url = "http://www.kaixin001.com/repaste/share.php";
                    break;
                }
                case DOUBAN:
                {
                    urlVars.url = siteURL;
                    urlVars.title = shareStr;
                    urlRequest.url = "http://www.douban.com/recommend/";
                    break;
                }
            }
			
            urlRequest.data = urlVars;
            navigateToURL(urlRequest, "_blank");
        }
    }
}
