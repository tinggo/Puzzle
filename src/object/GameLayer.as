package object
{
    import event.ParaEvent;

    import flash.display.MovieClip;
    import flash.geom.Rectangle;

    import manager.ConfigManager;
    import manager.GameManager;

    import manager.SceneManager;

    import object.Fragment;

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
            _pool.x = ConfigManager.POOL_X;
            _pool.y = ConfigManager.POOL_Y;
            _area.x = ConfigManager.AREA_X;
            _area.y = ConfigManager.AREA_Y;

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
                fragments[i].setDragRectangle(_dragArea);
                addChild(fragments[i]);
                fragments[i].addEventListener(Fragment.EVT_FRAGMENT_PLACED, onFragmentPlaced);
                fragments[i].addEventListener(Fragment.EVT_FRAGMENT_SELECTED, onFragmentSelected);
            }
        }

        private function onFragmentPlaced(e:ParaEvent):void
        {
            var fragment:Fragment = (e.target as Fragment);
            var fragmentCenterX:Number = fragment.x + fragment.width / 2;
            var fragmentCenterY:Number = fragment.y + fragment.height / 2;
            var grids:Vector.<Grid> = GameManager.getInstance().getGrids();
            if (fragmentCenterX > ConfigManager.AREA_X && fragmentCenterX < ConfigManager.AREA_X + ConfigManager.AREA_WIDTH &&
                fragmentCenterY > ConfigManager.AREA_Y && fragmentCenterY < ConfigManager.AREA_Y + ConfigManager.AREA_HEIGHT)
            {
                var near:int = 10000; // Just a big value;
                var selectedIndex:int = 0;
                for (var i:int = 0; i < grids.length; ++i)
                {
                    var aGrid:Grid = grids[i];
                    var centerX:Number = aGrid.posX + aGrid.width / 2;
                    var centerY:Number = aGrid.posY + aGrid.height / 2;
                    var distance:Number = Math.sqrt(Math.pow(fragmentCenterX - centerX, 2) + Math.pow(fragmentCenterY - centerY, 2));
                    if (distance < near)
                    {
                        selectedIndex = i;
                        near = distance;
                    }
                }

                if (fragment.gridIndex != Fragment.INVALID_VALUE)
                {
                    grids[fragment.gridIndex].fragment = null;
                    fragment.gridIndex = Fragment.INVALID_VALUE;
                    fragment.currentX = Fragment.INVALID_VALUE;
                    fragment.currentY = Fragment.INVALID_VALUE;
                }

                if (grids[selectedIndex].fragment == null)
                {
                    fragment.x = grids[selectedIndex].posX;
                    fragment.y = grids[selectedIndex].posY;
                    fragment.gridIndex = selectedIndex;
                    fragment.currentX = grids[selectedIndex].indexX;
                    fragment.currentY = grids[selectedIndex].indexY;
                    grids[selectedIndex].fragment = fragment;
                }
            }
            else
            {
                if (fragment.gridIndex != Fragment.INVALID_VALUE)
                {
                    grids[fragment.gridIndex].fragment = null;
                    fragment.gridIndex = Fragment.INVALID_VALUE;
                    fragment.currentX = Fragment.INVALID_VALUE;
                    fragment.currentY = Fragment.INVALID_VALUE;
                }
            }
        }

        private function onFragmentSelected(e:ParaEvent):void
        {
            var fragment:Fragment = e.target as Fragment;
            this.swapChildrenAt(this.getChildIndex(fragment), this.numChildren - 1);
        }

    }
}


