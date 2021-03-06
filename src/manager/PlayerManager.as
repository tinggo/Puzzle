package manager
{
    public class PlayerManager extends BaseManager
    {
        private static var _instance:PlayerManager;

        public var playerName:String = "Anonymous";
        public var playerAge:String = "";
        public var playerSex:int;
        public var playedTime:int = 0;
        public var money:Number;
        public var isTest:Boolean = false;

        public var costTotal:Number;
        public var buyTotal:int;

        public function PlayerManager()
        {
            super();
        }

        public static function getInstance():PlayerManager
        {
            if (_instance == null)
            {
                _instance = new PlayerManager();
            }
            return _instance;
        }

    }
}
