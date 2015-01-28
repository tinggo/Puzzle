package object
{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;

    import manager.SceneManager;

    public class GameLayer extends SceneLayer
    {
        private var _pool:MovieClip;
        private var _area:MovieClip;
        private var _dragArea:Rectangle = new Rectangle();
        private var _poolArea:Rectangle = new Rectangle();
        private var _playArea:Rectangle = new Rectangle();

        public function GameLayer()
        {
            super();
        }

        override public function init():void
        {
            _pool = new pool();
            _area = new area();
            addChild(_pool);
            addChild(_area);
            _pool.x = 18;
            _pool.y = 62;
            _area.x = 332;
            _area.y = 62;

            _dragArea.x = 0;
            _dragArea.y = 40;
            _dragArea.width = SceneManager.s_stage.stageWidth;
            _dragArea.height = SceneManager.s_stage.stageHeight - 40;

            _poolArea.x = _pool.x;
            _poolArea.y = _pool.y;
            _poolArea.width = _pool.width;
            _poolArea.height = _pool.height;

            _playArea.x = _playArea.x;
            _playArea.y = _playArea.y;
            _playArea.width = _playArea.width;
            _playArea.height = _playArea.height;
        }

        public function addNewFragments(fragments:Vector.<Fragment>):void
        {
            for (var i:int = 0; i < fragments.length; ++i)
            {
                var randomX:int = Math.random() * 1000 % (_poolArea.width - fragments[0].width);
                var randomY:int = Math.random() * 1000 % (_poolArea.height - fragments[0].height);
                fragments[i].x = randomX + _poolArea.x;
                fragments[i].y = randomY + _poolArea.y;
                addChild(fragments[i]);
            }
        }

    }
}
