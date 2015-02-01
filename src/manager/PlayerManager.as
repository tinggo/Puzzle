package manager
{
    public class PlayerManager extends BaseManager
    {
        private static var _instance:PlayerManager;

        public var playerName:String = "Anonymous";
        public var playerSex:int;
        public var playedTime:int = 0;

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
