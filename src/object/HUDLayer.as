package object
{
    import event.GameEvent;

    import flash.events.MouseEvent;

    import manager.Broadcaster;
    import manager.LocManager;
    import manager.SceneManager;
    import manager.SceneManager;

    import manager.SceneManager;

    import menu.Button;

    public class HUDLayer extends SceneLayer
    {
        private var _timeBar:timeBar;
        private var _buyButton:Button;

        public function HUDLayer()
        {
            super();
        }

        override public function init():void
        {
            _timeBar = new timeBar();
            addChild(_timeBar);
            _buyButton = new Button(_timeBar.myBuyBtn);
            _buyButton.label = LocManager.getLoc("BUY");
            addChild(_buyButton);
            _buyButton.addEventListener(MouseEvent.CLICK, onBuyButtonClicked);
        }

        private function onBuyButtonClicked(e:MouseEvent):void
        {
            SceneManager.getInstance().showPurchase();
        }

        private function yesCallback():void
        {
            SceneManager.getInstance().hideMsg();
            Broadcaster.getInstance().dispatchEvent(new GameEvent(GameEvent.BUY_FRAGMENTS));
        }

        private function noCallback():void
        {
            SceneManager.getInstance().hideMsg();
        }

        public function updateMoney(value:Number):void
        {
            _timeBar.mcMoney.text = LocManager.getLoc("MONEY") + String(value);
        }

        public function setTime(time:String):void
        {
            _timeBar.mcTime.text = time;
        }
    }
}
