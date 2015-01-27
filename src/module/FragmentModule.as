package module
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    import manager.AssetManager;
    import manager.ConfigManager;

    import object.Fragment;

    public class FragmentModule
    {
        private static const RAW_TEXTURE_PATH:String = "asset/map/world.jpg";

        private var _fragments:Vector.<Fragment>;

        public function FragmentModule()
        {
            _fragments = new Vector.<Fragment>();
        }

        public function init():void
        {
            generateFragments();
        }

        private function generateFragments():void
        {
            var bitmap:Bitmap = AssetManager.getInstance().getBitmap(RAW_TEXTURE_PATH);
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
                var xIndex:int = Math.floor(i % gridX);
                var yIndex:int = Math.floor(i / gridY);
                rect.x = xIndex * perWidth;
                rect.y = yIndex * perHeight;
                var fragmentBp:Bitmap = new Bitmap();
                fragmentBp.bitmapData = new BitmapData(perWidth, perHeight);
                fragmentBp.bitmapData.copyPixels(sourceBitmapData, rect, new Point(0, 0));
                var aFragment:Fragment = new Fragment();
                aFragment.setOrderedPosition(xIndex, yIndex);
                aFragment.addChild(fragmentBp);
                _fragments.push(aFragment);
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


    }
}
