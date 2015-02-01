package manager
{
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;

    public class Broadcaster extends EventDispatcher
    {
        private static var _instance:Broadcaster;

        public function Broadcaster(target:IEventDispatcher = null)
        {
            super(target);
        }

        public static function getInstance():Broadcaster
        {
            if (_instance == null)
            {
                _instance = new Broadcaster();
            }
            return _instance;
        }

    }
}
