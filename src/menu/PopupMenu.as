package menu
{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    public class PopupMenu extends MovieClip
    {
        public var myMessage:TextField;
        public var myYesBtn:Button;
        public var myNoBtn:Button;

        private var m_btnCount:int;
        private var m_btnCallback:Array;

        public function PopupMenu(mc:MovieClip)
        {
            super();
            addChild(mc);
            myMessage = mc.myMessage;
            myYesBtn = new Button(mc.myYesBtn);
            myNoBtn = new Button(mc.myNoBtn);

            addChild(myYesBtn);
            addChild(myNoBtn);

            myYesBtn.addEventListener(MouseEvent.CLICK, onYesBtnClicked);
            myNoBtn.addEventListener(MouseEvent.CLICK, onNoBtnClicked);
        }

        public function showPopup(message:String, btnCount:int, label:Array, callback:Array):void
        {
            m_btnCount = btnCount;
            myMessage.text = message;
            myYesBtn.visible = btnCount == 1 ?  false : true;
            m_btnCallback = callback;
            if (btnCount == 1)
            {
                myNoBtn.label = label[0];
            }
            else
            {
                myYesBtn.label = label[0];
                myNoBtn.label = label[1];
            }
        }

        private function onYesBtnClicked(e:MouseEvent):void
        {
            if (m_btnCount == 2)
            {
                m_btnCallback[0].call();
            }
        }

        private function onNoBtnClicked(e:MouseEvent):void
        {
            if (m_btnCount == 2)
            {
                m_btnCallback[1].call();
            }
            else
            {
                m_btnCallback[0].call();
            }
        }



    }
}
