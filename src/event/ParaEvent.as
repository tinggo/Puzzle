package event
{
    import flash.events.Event;

    public class ParaEvent extends Event
    {
        private var _para:Object;

        public function ParaEvent(type:String, para:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
            _para = para;
        }

        public function get myPara():Object
        {
            return _para;
        }
    }
}
