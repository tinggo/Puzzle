package event
{
    import flash.events.Event;

    public class ParaEvent extends Event
    {
        public var _para:Object;

        public function ParaEvent(type:String, para:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
            _para = para;
        }
    }
}
