package object
{
    import flash.events.Event;

    public class ParaEvent extends Event
    {
        public var _para:Object;

        public function ParaEvent(type:String, para:Object, bubbles:Boolean, cancelable:Boolean)
        {
            super(type, bubbles, cancelable);
            _para = para;
        }
    }
}
