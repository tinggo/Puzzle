package manager
{
    import event.GameEvent;

    import manager.BaseManager;

    import module.FragmentModule;

    import object.Fragment;

    public class GameManager extends BaseManager
    {
        public static var GAME_STATE_INTRO:int = 0;
        public static var GAME_STATE_GAME:int = 1;
        public static var GAME_STATE_END:int = 2;

        private static var _instance:GameManager;

        private var _state:int = GAME_STATE_INTRO;

        private var _fragmentModule:FragmentModule;

        public function GameManager()
        {
            super();
            _fragmentModule = new FragmentModule();
        }

        public static function getInstance():GameManager
        {
            if (!_instance)
            {
                _instance = new GameManager();
            }
            return _instance;
        }

        public function init():void
        {
            _fragmentModule.init();
        }

        public function resetGame():void
        {
            //jumpToState(GAME_STATE_INTRO);
            jumpToState(GAME_STATE_GAME);
        }

        private function jumpToState(state:int):void
        {
            if (state == GAME_STATE_INTRO)
            {
                // TODO reset time / reset money
                // TODO show intro menu
                // TODO clean playground
            }
            else if (state == GAME_STATE_GAME)
            {

            }
            else if (state == GAME_STATE_END)
            {

            }
            var data:Object = {prevState:_state, curState:state};
            _state = state;

            dispatchEvent(new GameEvent(GameEvent.GAME_STATE_CHANGED, data));
        }

        public function getOneBatchFragment():Vector.<Fragment>
        {
            return _fragmentModule.getOneBatchFragment();
        }

    }
}
