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
                loadTask.url = url;
                loadTask.type = type;
                loadTask.callback = callback;
                loadQueue.push(loadTask);

                var urlLoader:URLLoader = new URLLoader();
                urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onLoadFileError);
                urlLoader.addEventListener(Event.COMPLETE, onLoadFileComplete);
                urlLoader.load(new URLRequest(url));
            }
        }

        private function onLoadFileComplete(event:Event):void
        {
            var loader:URLLoader = (event.target as URLLoader);
            var content:String = loader.data as String;
            loader.close();
            cleanupLoader();
        }

        private function onLoadFileError(event:IOErrorEvent):void
        {
            var loader:URLLoader = (event.target as URLLoader);
            trace(event.toString());
            loader.close();
            cleanupLoader();
        }

        private function cleanupLoader():void
        {

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
    public var url:String;
    public var type:String;
    public var callback:Function;
}
