package manager
{
    import flash.events.Event;
    import flash.utils.Dictionary;

    public class LocManager extends BaseManager
    {
        private static var _instance:LocManager;

        private static var _dict:Dictionary = new Dictionary();

        public function LocManager()
        {
            super();
        }

        public static function getInstance():LocManager
        {
            if (!_instance)
            {
                _instance = new LocManager();
            }
            return _instance;
        }

        public static function getLoc(key:String, args:Array = null):String
        {
            if (_dict.hasOwnProperty(key))
            {
                var value:String = _dict[key];
                if (args && args.length > 0)
                {
                    for (var i:int = 0; i < args.length; ++i)
                    {
                        value = value.replace(("&" + String(i)), args[i]);
                    }
                }
                return value;
            }
            else
            {
                return key;
            }
        }

        public function loadLoc():void
        {
             LoaderManager.getInstance().loadFile("configuration/loc.csv", LoaderManager.LOAD_DATA_FORMAT_TEXT, onLoadComplete);
        }

        private function anysicsLoc(content:String):void
        {
            var keyValue:Array = content.split("\r\n");
            for (var i:int = 0; i < keyValue.length; ++i)
            {
                var aPair:Array = keyValue[i].split(",");
                _dict[aPair[0]] = aPair[1];
            }
        }

        private function onLoadComplete(content:Object):void
        {
            var rawStr:String = content as String;
            anysicsLoc(rawStr);
            dispatchEvent(new Event(Event.COMPLETE));
        }

    }
}
