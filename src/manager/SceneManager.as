package manager
{
    import manager.BaseManager;

    import flash.display.Stage;

    import object.GameLayer;

    import object.HUDLayer;

    import object.SceneLayer;

    public class SceneManager extends BaseManager
    {
        public static var s_stage:Stage;

        private static var _instance:SceneManager;

        private var _gameLayer:SceneLayer;
        private var _uiLayer:SceneLayer;
        private var _hudLayer:SceneLayer;

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
            _uiLayer = new SceneLayer();

            addLayer(_gameLayer);
            addLayer(_hudLayer);
            addLayer(_uiLayer);

            _gameLayer.init();
            _hudLayer.init();
        }

        private function addLayer(layer:SceneLayer):void
        {
            s_stage.addChild(layer);
        }

    }
}
