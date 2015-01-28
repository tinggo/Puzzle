package manager
{
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;

    public class EventManager
    {
        private static var m_instance:EventManager;
        private var m_dict:Dictionary = new Dictionary();

        public static function getInstance():EventManager
        {
            if (!m_instance)
            {
                m_instance = new EventManager();
            }
            return m_instance;
        }

        public function EventManager()
        {
            super();
        }

        public function addEventListener(target:EventDispatcher, type:String, callback:Function):void
        {
            if (!m_dict[target])
            {
                m_dict[target] = new Vector.<EventWrapper>();
            }

            var eventArray:Vector.<EventWrapper> = m_dict[target];
            var eventArrayLength:int = eventArray.length;

            var isExist:Boolean = false;
            for (var i:int = 0; i < eventArrayLength; ++i)
            {
                if (eventArray[i].type == type && eventArray[i].callback == callback)
                {
                    isExist = true;
                    break;
                }
            }

            if (!isExist)
            {
                var ew:EventWrapper = new EventWrapper();
                ew.type = type;
                ew.callback = callback;
                eventArray.push(ew);
                target.addEventListener(type, callback);
            }
        }

        public function removeEventListener(target:EventDispatcher, type:String, callback:Function):void
        {
            var eventList:Vector.<EventWrapper> = m_dict[target];
            if (eventList)
            {
                var eventListLen:int = eventList.length;
                for (var i:int = 0; i < eventListLen; ++i)
                {
                    var ew:EventWrapper = eventList[i];
                    if (ew.type == type && ew.callback == callback)
                    {
                        target.removeEventListener(type, callback);
                        eventList.splice(i, 1);
                        if (eventList.length == 0)
                        {
                            delete m_dict[target];
                        }
                        break;
                    }
                }
            }
        }

    }
}

class EventWrapper
{
    public var type:String;
    public var callback:Function;
}
