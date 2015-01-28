package object
{
    public class HUDLayer extends SceneLayer
    {
        private var _timeBar:timeBar;

        public function HUDLayer()
        {
            super();
        }

        override public function init():void
        {
            _timeBar = new timeBar();
            addChild(_timeBar);
        }
    }
}
