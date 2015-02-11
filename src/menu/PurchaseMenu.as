package menu
{
    import event.GameEvent;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    import manager.Broadcaster;

    import manager.ConfigManager;

    import manager.GameManager;

    import manager.LocManager;
    import manager.PlayerManager;
    import manager.SceneManager;

    public class PurchaseMenu extends MovieClip
    {
        private var myTitle:TextField;
        private var myMoney:TextField;
        private var myConfirmBtn:Button;
        private var myCancelBtn:Button;
        private var myCount:TextField;
        private var _count:int;
        private var _money:Number;

        public function PurchaseMenu(mc:MovieClip)
        {
            super();
            addChild(mc);
            myConfirmBtn = new Button(mc.myConfirm);
            myCancelBtn = new Button(mc.myCancel);

            addChild(myConfirmBtn);

            myConfirmBtn.label = LocManager.getLoc("OK");
            addChild(myCancelBtn);

            myCancelBtn.label = LocManager.getLoc("CANCEL");

            myTitle = mc.myTitle;

            myMoney = mc.myMoney;
            myCount = mc.myCount;

            myConfirmBtn.addEventListener(MouseEvent.CLICK, onConfirmBtnClicked);
            myCancelBtn.addEventListener(MouseEvent.CLICK, onCancelBtnClicked);

        }

        public function show():void
        {
            myMoney.text = "";
            myCount.text = "";

            var freeFragmentCount:int = GameManager.getInstance().getFreeFragmentCount();
            var leastFragmentThreshold:int = ConfigManager.getInstance().leastFragmentThreshold;

            if (freeFragmentCount <= leastFragmentThreshold)
            {
                myTitle.text = LocManager.getLoc("BUY_PROMPT", [String(freeFragmentCount)]);
            }
            else
            {
                myTitle.text = LocManager.getLoc("LEAST_PURCHASE_HINT");
            }
            _count = 0;
            _money = 0;
        }

        private function onConfirmBtnClicked(e:MouseEvent):void
        {
            var count:int = int(myCount.text);
            var isValid:Boolean = false;
            if (!isNaN(count))
            {
                var freeFragmentCount:int = GameManager.getInstance().getFreeFragmentCount();
                var leastFragmentThreshold:int = ConfigManager.getInstance().leastFragmentThreshold;

                var thresholdValue:int = 0;
                if (freeFragmentCount > leastFragmentThreshold)
                {
                    thresholdValue = leastFragmentThreshold;
                }

                if (count >= thresholdValue && count <= GameManager.getInstance().getFreeFragmentCount())
                {
                    var money:Number = ConfigManager.getInstance().perFragmentPrice * count;
                    _count = count;
                    _money = Number(money.toFixed(2));
                    if (_money <= PlayerManager.getInstance().money)
                    {
                        SceneManager.getInstance().showMsg(LocManager.getLoc("PURCHASE_CONFIRM", [_money]), 2, [LocManager.getLoc("OK"), LocManager.getLoc("CANCEL")], [okClicked, cancelClicked]);
                    }
                    else
                    {
                        SceneManager.getInstance().showMsg(LocManager.getLoc("NO_MONEY"), 1, [LocManager.getLoc("OK")], [cancelClicked]);
                    }
                }
                else if (count > GameManager.getInstance().getFreeFragmentCount())
                {
                    SceneManager.getInstance().showMsg(LocManager.getLoc("TOO_MANY"), 1, [LocManager.getLoc("OK")], [cancelClicked]);
                }
                else
                {
                    SceneManager.getInstance().showMsg(LocManager.getLoc("INVALID_COUNT"), 1, [LocManager.getLoc("OK")], [cancelClicked]);
                }
            }
            else
            {
                SceneManager.getInstance().showMsg(LocManager.getLoc("INVALID_COUNT"), 1, [LocManager.getLoc("OK")], [cancelClicked]);
            }
        }

        private function onCancelBtnClicked(e:MouseEvent):void
        {
            if (this.parent)
            {
                parent.removeChild(this);
            }
        }

        private function okClicked():void
        {
            SceneManager.getInstance().hideMsg();
            Broadcaster.getInstance().dispatchEvent(new GameEvent(GameEvent.BUY_FRAGMENTS, {count:_count, money:_money}));
            if (this.parent)
            {
                parent.removeChild(this);
            }
        }

        private function cancelClicked():void
        {
            SceneManager.getInstance().hideMsg();
        }
    }
}
