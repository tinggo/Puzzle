package manager
{
    import manager.BaseManager;

    import flash.display.Bitmap;

    import flash.utils.Dictionary;

    public class AssetManager extends BaseManager
    {
        private static var s_instance:AssetManager;

        private var m_assets:Dictionary = new Dictionary();
        private var m_urls:Array;
        private var m_currentLoadingUrl:String;
        private var m_completeCallback:Function;

        public function AssetManager()
        {
            super();
        }

        public static function getInstance():AssetManager
        {
            if (!s_instance)
            {
                s_instance = new AssetManager();
            }
            return s_instance;
        }

        public function load(urls:Array, completeCallback:Function):void
        {
            m_urls = urls;
            m_completeCallback = completeCallback;
            loadAAsset(m_urls[0]);
        }

        private function loadAAsset(url:String):void
        {
            m_currentLoadingUrl = url;
            LoaderManager.getInstance().loadFile(url, LoaderManager.LOAD_DATA_FORMAT_BITMAP, onBitmapLoadComplete);
        }

        private function onBitmapLoadComplete(content:Bitmap):void
        {
            m_assets[m_currentLoadingUrl] = content;
            m_completeCallback();
        }

        public function getBitmap(url:String):Bitmap
        {
            if (m_assets.hasOwnProperty(url))
            {
                return m_assets[url];
            }
            else
            {
                return null;
            }
        }

    }
}
