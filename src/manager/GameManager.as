package manager
{
    import event.GameEvent;
    import event.ParaEvent;

    import flash.desktop.NativeApplication;
    import flash.events.Event;

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
        private var _timeStr:String;
        private var _isSuccess:Boolean = false;

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

            NativeApplication.nativeApplication.addEventListener(Event.EXITING, onAppExisting);
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
                grid.indexX = i % gridX;
                grid.indexY = (i - grid.indexX) / gridX;
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
                _isSuccess = true;
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
                LogManager.getInstance().reset();
                LogManager.getInstance().cacheString(PlayerManager.getInstance().playerAge);
                LogManager.getInstance().cacheString(PlayerManager.getInstance().playerSex == 1 ? "Male" : "Female");
                _timer.reset();
                _timer.start();
            }
            else if (state == GAME_STATE_END)
            {
                _timer.stop();
                if (PlayerManager.getInstance().isTest == false)
                {
                    if (_isSuccess)
                    {
                        SceneManager.getInstance().showMsg(LocManager.getLoc("MISSION_COMPLETE"), 1, [LocManager.getLoc("OK")], [missionComplete]);
                        LogManager.getInstance().cacheString(_timeStr + " COMPLETE");
                    }
                    else
                    {
                        SceneManager.getInstance().showMsg(LocManager.getLoc("TIMES_UP"), 1, [LocManager.getLoc("OK")], [missionComplete]);
                        LogManager.getInstance().cacheString(_timeStr + " FAILED");
                    }
                    LogManager.getInstance().cacheString("BUY TOTAL: " + String(PlayerManager.getInstance().buyTotal));
                    LogManager.getInstance().cacheString("COST TOTAL: " + String(PlayerManager.getInstance().costTotal));
                    LogManager.getInstance().cacheString("REMAIN TOTAL: " + Number(ConfigManager.getInstance().money - PlayerManager.getInstance().costTotal).toFixed(1));
                    LogManager.getInstance().writeCache();
                }
                else
                {
                    SceneManager.getInstance().showMsg(LocManager.getLoc("TEST_COMPLETE"), 1, [LocManager.getLoc("OK")], [missionComplete]);
                }
            }
            var data:Object = {prevState:_state, curState:state};
            _state = state;

            dispatchEvent(new GameEvent(GameEvent.GAME_STATE_CHANGED, data));
        }

        private function onAppExisting(e:Event):void
        {
            if (_state == GAME_STATE_GAME)
            {
                LogManager.getInstance().cacheString(_timeStr + " GIVEUP");
                LogManager.getInstance().cacheString("BUY TOTAL: " + String(PlayerManager.getInstance().buyTotal));
                LogManager.getInstance().cacheString("COST TOTAL: " + String(PlayerManager.getInstance().costTotal));
                LogManager.getInstance().cacheString("REMAIN TOTAL: " + Number(ConfigManager.getInstance().money - PlayerManager.getInstance().costTotal).toFixed(1));
                LogManager.getInstance().writeCache();
            }
        }

        public function getOneBatchFragment(count:int):Vector.<Fragment>
        {
            return _fragmentModule.getOneBatchFragment(count);
        }

        public function getFreeFragmentCount():int
        {
            return _fragmentModule.getFreeFragmentCount();
        }

        private function onLogin(e:ParaEvent):void
        {
            var obj:Object = e.myPara;
            PlayerManager.getInstance().playerAge = obj.age;
            PlayerManager.getInstance().playerSex = obj.isMale ? 1 : 0;
            PlayerManager.getInstance().isTest = obj.isTest;
            PlayerManager.getInstance().money = ConfigManager.getInstance().money;
            SceneManager.getInstance().updateMoney(PlayerManager.getInstance().money);
            PlayerManager.getInstance().playedTime = 0;
            PlayerManager.getInstance().buyTotal = 0;
            PlayerManager.getInstance().costTotal = 0;
            jumpToState(GAME_STATE_GAME);
        }

        private function onBuyFragment(e:GameEvent):void
        {
            var count:int = e.myPara["count"];
            var money:Number = e.myPara["money"];
            if (money <= PlayerManager.getInstance().money)
            {
                PlayerManager.getInstance().money -= money;
                PlayerManager.getInstance().money = Number(PlayerManager.getInstance().money.toFixed(1));
                SceneManager.getInstance().updateMoney(PlayerManager.getInstance().money);
                LogManager.getInstance().cacheString(_timeStr + " BUY: " + String(count) + " COST: " + String(money));
                PlayerManager.getInstance().buyTotal += count;
                PlayerManager.getInstance().costTotal += money;
                SceneManager.getInstance().addOneBatchOfFragment(count);
            }
            else
            {
                SceneManager.getInstance().showMsg(LocManager.getLoc("NO_MONEY"), 1, [LocManager.getLoc("OK")], [okClicked]);
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
            _timeStr = time;
            SceneManager.getInstance().setTime(time);
            if (PlayerManager.getInstance().isTest == false)
            {
                if (currentSecond >= ConfigManager.getInstance().oneRoundTime)
                {
                    _isSuccess = false;
                    jumpToState(GAME_STATE_END);
                }
            }
            else
            {
                if (currentSecond >= ConfigManager.getInstance().testOneRoundTime)
                {
                    _isSuccess = false;
                    jumpToState(GAME_STATE_END);
                }
            }
        }

    }
}
