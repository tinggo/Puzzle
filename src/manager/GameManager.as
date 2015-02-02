package manager
{
    import event.GameEvent;
    import event.ParaEvent;

    import flash.events.TimerEvent;

    import flash.utils.Timer;

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

        private var _timer:Timer;

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

            _timer = new Timer(1000);
            _timer.addEventListener(TimerEvent.TIMER, onTimerTick);

            Broadcaster.getInstance().addEventListener(LoginMenu.EVENT_LOGIN, onLogin);
            Broadcaster.getInstance().addEventListener(GameEvent.BUY_FRAGMENTS, onBuyFragment);
        }

        public function resetGame():void
        {
            for (var i:int = 0; i < _grids.length; ++i)
            {
                _grids[i].fragment = null;
            }
            _fragmentModule.reset();
            jumpToState(GAME_STATE_INTRO);

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
            SceneManager.getInstance().hideMsg();
            resetGame();
        }

        private function jumpToState(state:int):void
        {
            if (state == GAME_STATE_INTRO)
            {
                SceneManager.getInstance().setTime("00:00");
                SceneManager.getInstance().updateMoney(ConfigManager.getInstance().money);
            }
            else if (state == GAME_STATE_GAME)
            {
                _timer.reset();
                _timer.start();
            }
            else if (state == GAME_STATE_END)
            {
                _timer.stop();
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

        private function onTimerTick(e:TimerEvent):void
        {
            var currentSecond:int = (e.target as Timer).currentCount;
            var min:int = Math.floor(currentSecond / 60);
            var sec:int = currentSecond % 60;
            var minStr:String = String(min);
            var secStr:String = String(sec);
            if (minStr.length == 1)
            {
                minStr = "0" + minStr;
            }
            if (secStr.length == 1)
            {
                secStr = "0" + secStr;
            }
            var time:String = minStr + ":" + secStr;
            SceneManager.getInstance().setTime(time);
        }

    }
}
