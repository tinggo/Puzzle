package object
{
    public class HUDLayer extends SceneLayer
    {
        private var _playground:playground;

        public function HUDLayer()
        {
            super();
        }

        override public function init():void
        {
            _playground = new playground();
            addChild(_playground);
        }
    }
}
