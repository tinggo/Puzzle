package manager
{
    import dataStructure.SingletonObj;

    import flash.events.Event;
    import flash.events.IOErrorEvent;

    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;


    public class LoaderManager extends SingletonObj
    {
        public static const LOAD_DATA_FORMAT_TEXT:String = URLLoaderDataFormat.TEXT;
        public static const LOAD_DATA_FORMAT_BINARY:String = URLLoaderDataFormat.BINARY;

        private static var s_instance:LoaderManager;
        private var loadQueue:Vector.<LoadTask> = new Vector.<LoadTask>();

        public function LoaderManager ()
        {
            super ();
        }

        public static function getInstance():LoaderManager
        {
            if (!s_instance)
            {
                s_instance = new LoaderManager();
            }
            return s_instance;
        }

        public function loadFile(url:String, type:String, callback:Function = null):void
        {
            if (!isLoading(url))
            {
                var loadTask:LoadTask = new LoadTask();
                var urlLoader:URLLoader = new URLLoader();
                loadTask.url = url;
                loadTask.type = type;
                loadTask.callback = callback;
                loadTask.loaderObj = urlLoader;
                loadQueue.push(loadTask);

                urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onLoadFileError);
                urlLoader.addEventListener(Event.COMPLETE, onLoadFileComplete);
                urlLoader.load(new URLRequest(url));
            }
        }

        private function onLoadFileComplete(event:Event):void
        {
            var loader:URLLoader = (event.target as URLLoader);
            var content:String = loader.data as String;
            var loaderCount:int = loadQueue.length;
            for (var i:int = 0; i < loaderCount; ++i)
            {
                if (loadQueue[i].loaderObj == loader)
                {
                    var callback:Function = loadQueue[i].callback;
                    if (callback != null)
                    {
                        callback(content);
                    }
                    break;
                }
            }
            loader.close();
            cleanupLoader(loader);
        }

        private function onLoadFileError(event:IOErrorEvent):void
        {
            var loader:URLLoader = (event.target as URLLoader);
            loader.close();
            cleanupLoader(loader);
        }

        private function cleanupLoader(loader:Object):void
        {
            var loadQueueLen:int = loadQueue.length;
            for (var i:int = 0; i < loadQueueLen; ++i)
            {
                if (loadQueue[i].loaderObj == loader)
                {
                    loadQueue[i].callback = null;
                    loadQueue.splice(i, 1);
                    break;
                }
            }
        }

        private function isLoading(url:String):Boolean
        {
            var queueLength:int = loadQueue.length;
            for (var i:int = 0; i < queueLength; ++i)
            {
                if (loadQueue[i].url == url)
                {
                    return true;
                }
            }
            return false;
        }
    }
}

class LoadTask
{
    public var loaderObj:Object;
    public var url:String;
    public var type:String;
    public var callback:Function;
}
