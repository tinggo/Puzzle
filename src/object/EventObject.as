package object
{
    import flash.events.Event;

    public class EventObject
    {
        public var e:Event;
        public var para:Object;

        public function EventObject(e:Event, para:Object)
        {
            this.e = e;
            this.para = para;
        }
    }
}
