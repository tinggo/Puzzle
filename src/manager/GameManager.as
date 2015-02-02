package manager
{
    import event.GameEvent;
    import event.ParaEvent;

    import menu.LoginMenu;

    import module.FragmentModule;

    import object.Fragment;
    import object.Grid;

    public class GameManager extends BaseManager
    {
        public static var GAME_STATE_INTRO:int = 0;
        public static var GAME_STATE_GAME:int = 1;
        public static var GAME_STATE_END:int = 2;

        private static var _instance:GameManager;

        private var _state:int = GAME_STATE_INTRO;

        private var _fragmentModule:FragmentModule;
        private var _grids:Vector.<Grid> = new Vector.<Grid>();

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
            initGrids();

            Broadcaster.getInstance().addEventListener(LoginMenu.EVENT_LOGIN, onLogin);
            Broadcaster.getInstance().addEventListener(GameEvent.BUY_FRAGMENTS, onBuyFragment);
        }

        public function resetGame():void
        {
            jumpToState(GAME_STATE_INTRO);
            //jumpToState(GAME_STATE_GAME);
        }

        private function initGrids():void
        {
            var gridX:int = ConfigManager.getInstance().gridX;
            var gridY:int = ConfigManager.getInstance().gridY;
            var totalCount:int = gridX * gridY;
            var perWidth:Number = Math.floor(ConfigManager.AREA_WIDTH) / gridX;
            var perHeight:Number = Math.floor(ConfigManager.AREA_HEIGHT) / gridY;

            for (var i:int = 0; i < totalCount; ++i)
            {
                var grid:Grid = new Grid();
                grid.indexX = Math.floor(i % gridX);
                grid.indexY = Math.floor(i / gridY);
                grid.posX =  ConfigManager.AREA_X + grid.indexX * perWidth;
                grid.posY = ConfigManager.AREA_Y + grid.indexY * perHeight;
                grid.width = perWidth;
                grid.height = perHeight;
                grid.fragment = null;
                _grids.push(grid);
            }
        }

        public function getGrids():Vector.<Grid>
        {
            return _grids;
        }

        public function validateIfSuccess():void
        {
            var isSuccess:Boolean = true;
            for (var i:int = 0; i < _grids.length; ++i)
            {
                var fragment:Fragment = _grids[i].fragment;
                if (!fragment)
                {
                    isSuccess = false;
                    break;
                }
                else
                {
                    if (_grids[i].indexX != fragment.getOrderedX() || _grids[i].indexY != fragment.getOrderedY())
                    {
                        isSuccess = false;
                        break;
                    }
                }
            }

            if (isSuccess)
            {
                jumpToState(GAME_STATE_END);
            }
        }

        private function missionComplete():void
        {
            // reset
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
                SceneManager.getInstance().showMsg("Mission Accomplish!", 1, ["OK"], [missionComplete]);
            }
            var data:Object = {prevState:_state, curState:state};
            _state = state;

            dispatchEvent(new GameEvent(GameEvent.GAME_STATE_CHANGED, data));
        }

        public function getOneBatchFragment():Vector.<Fragment>
        {
            return _fragmentModule.getOneBatchFragment();
        }

        private function onLogin(e:ParaEvent):void
        {
            var obj:Object = e.myPara;
            PlayerManager.getInstance().playerName = obj.name;
            PlayerManager.getInstance().playerSex = obj.isMale ? 1 : 0;
            PlayerManager.getInstance().money = ConfigManager.getInstance().money;
            SceneManager.getInstance().updateMoney(PlayerManager.getInstance().money);
            PlayerManager.getInstance().playedTime = 0;
            jumpToState(GAME_STATE_GAME);
        }

        private function onBuyFragment(e:GameEvent):void
        {
            var perTimePurchase:int = ConfigManager.getInstance().perTimePurchase;
            if (perTimePurchase <= PlayerManager.getInstance().money)
            {
                PlayerManager.getInstance().money -= perTimePurchase;
                SceneManager.getInstance().updateMoney(PlayerManager.getInstance().money);
                SceneManager.getInstance().addOneBatchOfFragment();
            }
            else
            {
                SceneManager.getInstance().showMsg("Insufficient Funds", 1, ["OK"], [okClicked]);
            }
        }

        private function okClicked():void
        {
            SceneManager.getInstance().hideMsg();
        }

    }
}
