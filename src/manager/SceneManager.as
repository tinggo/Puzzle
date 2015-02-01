package manager
{
    import event.GameEvent;
    import event.ParaEvent;

    import manager.BaseManager;

    import flash.display.Stage;

    import object.Fragment;

    import object.GameLayer;

    import object.HUDLayer;
    import object.MenuLayer;

    import object.SceneLayer;

    public class SceneManager extends BaseManager
    {
        public static var s_stage:Stage;

        private static var _instance:SceneManager;

        private var _gameLayer:GameLayer;
        private var _uiLayer:MenuLayer;
        private var _hudLayer:HUDLayer;

        public function SceneManager()
        {
            super();
        }

        public static function getInstance():SceneManager
        {
            if (!_instance)
            {
                _instance = new SceneManager();
            }
            return _instance;
        }

        public function init():void
        {
            _gameLayer = new GameLayer();
            _hudLayer = new HUDLayer();
            _uiLayer = new MenuLayer();

            addLayer(_gameLayer);
            addLayer(_hudLayer);
            addLayer(_uiLayer);

            _gameLayer.init();
            _hudLayer.init();

            m_em.addEventListener(GameManager.getInstance(), GameEvent.GAME_STATE_CHANGED, onGameStateChanged);
        }

        private function addLayer(layer:SceneLayer):void
        {
            s_stage.addChild(layer);
        }

        private function onGameStateChanged(e:ParaEvent):void
        {
            var data:Object = e.myPara;
            _uiLayer.onStageChanged(data.curState);
            if (data.curState == GameManager.GAME_STATE_INTRO)
            {

            }
            else if (data.curState == GameManager.GAME_STATE_GAME)
            {
                var oneBatchFragment:Vector.<Fragment> = GameManager.getInstance().getOneBatchFragment();
                _gameLayer.addNewFragments(oneBatchFragment);
            }
        }

    }
}
