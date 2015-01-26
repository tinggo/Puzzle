package manager
{
    import manager.BaseManager;

import flash.display.Bitmap;

import flash.display.BitmapData;

import flash.display.Loader;
import flash.display.LoaderInfo;

import flash.events.Event;
    import flash.events.IOErrorEvent;

    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;



    public class LoaderManager extends BaseManager
    {
        public static const LOAD_DATA_FORMAT_TEXT:String = URLLoaderDataFormat.TEXT;
        public static const LOAD_DATA_FORMAT_BINARY:String = URLLoaderDataFormat.BINARY;
        public static const LOAD_DATA_FORMAT_BITMAP:String = "load_data_bitmap";

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
                if (type == LOAD_DATA_FORMAT_TEXT || type == LOAD_DATA_FORMAT_BINARY)
                {
                    var urlLoader:URLLoader = new URLLoader();
                    loadTask.loaderObj = urlLoader;
                    urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onLoadFileError);
                    urlLoader.addEventListener(Event.COMPLETE, onLoadFileComplete);
                    urlLoader.load(new URLRequest(url));
                }
                else if (type == LOAD_DATA_FORMAT_BITMAP)
                {
                    var loader:Loader = new Loader();
                    loadTask.loaderObj = loader;
                    loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadFileError);
                    loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onBitmapLoadComplete);
                    loader.load(new URLRequest(url));

                }
                loadQueue.push(loadTask);
            }
        }

        private function onBitmapLoadComplete(event:Event):void
        {
            var loaderInfo:LoaderInfo = event.target as LoaderInfo;
            var loader:Loader = loaderInfo.loader;
            var bitmap:Bitmap = loader.content as Bitmap;
            var loaderCount:int = loadQueue.length;
            for (var i:int = 0; i < loaderCount; ++i)
            {
                if (loadQueue[i].loaderObj == loader)
                {
                    var callback:Function = loadQueue[i].callback;
                    if (callback != null)
                    {
                        callback(bitmap);
                    }
                    break;
                }
            }
            cleanupLoader(loader);
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
            if (event.target as URLLoader)
            {
                var loader:URLLoader = (event.target as URLLoader);
                loader.close();
                cleanupLoader(loader);
            }
            else if (event.target as Loader)
            {
                var bitmapLoader:Loader = (event.target as Loader);
                bitmapLoader.close();
                cleanupLoader(bitmapLoader);
            }
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
