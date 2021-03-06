package module
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    import manager.AssetManager;
    import manager.ConfigManager;
    import manager.SceneManager;

    import object.Fragment;

    public class FragmentModule
    {
        private static const RAW_TEXTURE_PATH:String = "asset/map/world.jpg";

        private var _fragments:Vector.<Fragment>;
        private var _freeFragments:Vector.<Fragment>;

        public function FragmentModule()
        {
            _fragments = new Vector.<Fragment>();
            _freeFragments = new Vector.<Fragment>();
        }

        public function init():void
        {
            generateFragments();
        }

        public function reset():void
        {
            _freeFragments.splice(0, _freeFragments.length);
            for (var i:int = 0; i < _fragments.length; ++i)
            {
                _fragments[i].reset();
                _freeFragments.push(_fragments[i]);
                if (_fragments[i].parent)
                {
                    _fragments[i].parent.removeChild(_fragments[i]);
                }
            }
        }

        private function generateFragments():void
        {
            var bitmap:Bitmap = AssetManager.getInstance().getBitmap(RAW_TEXTURE_PATH);
            var fragmentScaleX:Number = ConfigManager.AREA_WIDTH / bitmap.width;
            var fragmentScaleY:Number = ConfigManager.AREA_HEIGHT / bitmap.height;
            var sourceBitmapData:BitmapData = bitmap.bitmapData;
            var gridX:int = ConfigManager.getInstance().gridX;
            var gridY:int = ConfigManager.getInstance().gridY;
            var totalCount:int = gridX * gridY;
            var perWidth:int = Math.floor(sourceBitmapData.width / gridX);
            var perHeight:int = Math.floor(sourceBitmapData.height / gridY);
            var rect:Rectangle = new Rectangle();
            rect.width = perWidth;
            rect.height = perHeight;
            for (var i:int = 0; i < totalCount; ++i)
            {
                var xIndex:int = i % gridX;
                var yIndex:int = (i - xIndex) / gridX;
                rect.x = xIndex * perWidth;
                rect.y = yIndex * perHeight;
                var fragmentBp:Bitmap = new Bitmap();
                fragmentBp.bitmapData = new BitmapData(perWidth, perHeight);
                fragmentBp.bitmapData.copyPixels(sourceBitmapData, rect, new Point(0, 0));
                var aFragment:Fragment = new Fragment();
                aFragment.setOrderedPosition(xIndex, yIndex);
                aFragment.addChild(fragmentBp);
                aFragment.scaleX = fragmentScaleX;
                aFragment.scaleY = fragmentScaleY;
                _fragments.push(aFragment);
                _freeFragments.push(aFragment);

                // For debugging
                //SceneManager.s_stage.addChild(aFragment);
                //aFragment.x = perWidth*fragmentScaleX * xIndex;
                //aFragment.y = perHeight*fragmentScaleY * yIndex;
            }


        }

        public function getOrderedFragment(index:int):Fragment
        {
            if (index < _fragments.length)
            {
                return _fragments[index];
            }
            return null;
        }

        public function getAllFragments():Vector.<Fragment>
        {
            return _fragments;
        }

        public function getOneBatchFragment(count:int):Vector.<Fragment>
        {
            var perFragmentCount:int = count;

            var selectedFragment:Vector.<Fragment> = new Vector.<Fragment>();
            for (var i:int = 0; i < perFragmentCount; ++i)
            {
                var freeFragmentCount:int = _freeFragments.length;
                if (freeFragmentCount > 0)
                {
                    var selectedIndex:int = Math.random() * 100 % freeFragmentCount;
                    selectedFragment.push(_freeFragments[selectedIndex]);
                    _freeFragments.splice(selectedIndex, 1);
                }
                else
                {
                    break;
                }
            }
            return selectedFragment;
        }

        public function getFreeFragmentCount():int
        {
            return _freeFragments.length
        }

    }
}
