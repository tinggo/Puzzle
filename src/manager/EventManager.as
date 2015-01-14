package manager
{
    import dataStructure.SingletonObj;

    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;

    import object.EventObject;

    public class EventManager extends SingletonObj
    {
        private static var m_instance:EventManager;

        private var m_dict:Dictionary = new Dictionary();

        public function EventManager ()
        {
            super ();
        }

        public static function getInstance():EventManager
        {
            if (!m_instance)
            {
                m_instance = new EventManager();
            }
            return m_instance;
        }

        public function addEventListener(target:EventDispatcher, type:String, callback:Function, para:Object):void
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
                ew.para = para;
                eventArray.push(ew);
                target.addEventListener(type, callbackHQ);
            }
        }

        public function removeEventListener(target:EventDispatcher, type:String):void
        {
            // TODO
        }

        private function callbackHQ(e:Event):void
        {
            var target:Object = e.target;
            var eventArray:Vector.<EventWrapper> = m_dict[target];
            var eventArrayLength:int = eventArray.length;
            for (var i:int = 0; i < eventArrayLength; ++i)
            {
                var type:String = eventArray[i].type;
                if ( e.type == type)
                {
                    eventArray[i].callback(new EventObject(e, eventArray[i].para));
                }
            }
        }
    }
}

class EventWrapper
{
    public var type:String;
    public var callback:Function;
    public var para:Object;
}
