package menu
{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    public class Button extends MovieClip
    {
        private static const HIGHLIGHT_FRAME:int = 2;
        private static const NORMAL_FRAME:int = 1;

        private var myText:MovieClip;
        private var myMc:MovieClip;

        public function Button(mc:MovieClip)
        {
            myMc = mc;
            addChild(mc);
            myText = mc.myText;
            this.addEventListener(MouseEvent.ROLL_OVER, onRollOverHandler);
            this.addEventListener(MouseEvent.ROLL_OUT, onRollOutHandler);
        }

        private function onRollOverHandler(e:MouseEvent):void
        {
            myMc.gotoAndStop(HIGHLIGHT_FRAME);
        }

        private function onRollOutHandler(e:MouseEvent):void
        {
            myMc.gotoAndStop(NORMAL_FRAME);
        }

        public function set label(text:String):void
        {
            myText.myTF.text = text;
        }
    }
}
