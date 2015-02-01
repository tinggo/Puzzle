package menu
{
    import event.ParaEvent;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    import manager.Broadcaster;

    public class LoginMenu extends MovieClip
    {
        public static const EVENT_LOGIN:String = "evt_login";

        private var _name:TextField;
        private var _sexRadio:MovieClip;
        private var _confirmBtn:MovieClip;

        public function LoginMenu(mc:MovieClip)
        {
            super();

            this.addChild(mc);
            _name = mc.myName;
            _sexRadio = mc.sexRadio;
            _confirmBtn = mc.myConfirmBtn;

            _confirmBtn.addEventListener(MouseEvent.CLICK, onConfirmBtnClicked);
            _sexRadio.maleHA.addEventListener(MouseEvent.CLICK, onSexChanged);
            _sexRadio.femaleHA.addEventListener(MouseEvent.CLICK, onSexChanged);
        }

        public function show():void
        {
            reset();
        }

        public function reset():void
        {
            selectSex(true);
            _name.text = "Anonymous";
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
            var name:String = _name.text;
            var isMale:Boolean = _sexRadio.currentFrame == 1 ? true : false;
            Broadcaster.getInstance().dispatchEvent(new ParaEvent(EVENT_LOGIN, {name:name, isMale: isMale}));
        }
    }
}
