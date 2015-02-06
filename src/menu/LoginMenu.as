package menu
{
    import event.ParaEvent;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    import manager.Broadcaster;
    import manager.ConfigManager;
    import manager.LocManager;
    import manager.SceneManager;

    public class LoginMenu extends MovieClip
    {
        public static const EVENT_LOGIN:String = "evt_login";

        private var _age:TextField;
        private var _sexRadio:MovieClip;
        private var _confirmBtn:MovieClip;
        private var _testBtn:MovieClip;

        public function LoginMenu(mc:MovieClip)
        {
            super();

            this.addChild(mc);
            _age = mc.myAge;
            _sexRadio = mc.sexRadio;
            _confirmBtn = mc.myConfirmBtn;
            _testBtn = mc.myTestBtn;

            mc.myIntroTF.text = LocManager.getLoc("INTRO");

            _confirmBtn.addEventListener(MouseEvent.CLICK, onConfirmBtnClicked);
            _testBtn.addEventListener(MouseEvent.CLICK, onTestBtnClicked);
            _sexRadio.maleHA.addEventListener(MouseEvent.CLICK, onSexChanged);
            _sexRadio.femaleHA.addEventListener(MouseEvent.CLICK, onSexChanged);

            _testBtn.myText.myTF.text = LocManager.getLoc("TRY_BTN");
            _confirmBtn.myText.myTF.text = LocManager.getLoc("START_BTN");
        }

        public function show():void
        {
            reset();
        }

        public function reset():void
        {
            selectSex(true);
            _age.text = "";
        }

        public function selectSex(isMale:Boolean):void
        {
            if (isMale)
            {
                _sexRadio.gotoAndStop(1);
            }
            else
            {
                _sexRadio.gotoAndStop(2);
            }
        }

        private function onSexChanged(e:MouseEvent):void
        {
            if (e.target == _sexRadio.maleHA)
            {
                _sexRadio.gotoAndStop(1);
            }
            else if (e.target == _sexRadio.femaleHA)
            {
                _sexRadio.gotoAndStop(2);
            }
        }

        private function onConfirmBtnClicked(e:MouseEvent):void
        {
            var age:String = _age.text;
            var ageNum:int = int(age);
            var ageValid:Boolean = false;
            if (!isNaN(ageNum))
            {
                if (ageNum >= 10 && ageNum <= 50)
                {
                    ageValid = true;
                }
            }

            if (!ageValid)
            {
                SceneManager.getInstance().showMsg(LocManager.getLoc("INVALID_AGE"), 1, [LocManager.getLoc("OK")], [okClicked]);
            }
            else
            {
                var isMale:Boolean = _sexRadio.currentFrame == 1 ? true : false;
                Broadcaster.getInstance().dispatchEvent(new ParaEvent(EVENT_LOGIN, {age:age, isMale: isMale, isTest: false}));
            }
        }

        private function okClicked():void
        {
            SceneManager.getInstance().hideMsg();
        }

        private function onTestBtnClicked(e:MouseEvent):void
        {
            var age:String = _age.text;
            var ageNum:int = int(age);
            var ageValid:Boolean = false;
            if (!isNaN(ageNum))
            {
                if (ageNum >= 10 && ageNum <= 50)
                {
                    ageValid = true;
                }
            }

            if (!ageValid)
            {
                SceneManager.getInstance().showMsg(LocManager.getLoc("INVALID_AGE"), 1, [LocManager.getLoc("OK")], [okClicked]);
            }
            else
            {
                var isMale:Boolean = _sexRadio.currentFrame == 1 ? true : false;
                Broadcaster.getInstance().dispatchEvent(new ParaEvent(EVENT_LOGIN, {age:age, isMale: isMale, isTest: true}));
            }
        }
    }
}
