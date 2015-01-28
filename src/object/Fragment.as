package object
{
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;

    public class Fragment extends Sprite
    {
        public static const INVALID_VALUE:int = -1;

        private var _currentX:int;
        private var _currentY:int;

        private var _orderedX:int;
        private var _orderedY:int;

        private var _onStage:Boolean = false;

        public function Fragment()
        {
            super();
            _currentX = INVALID_VALUE;
            _currentY = INVALID_VALUE;
            _orderedX = INVALID_VALUE;
            _orderedY = INVALID_VALUE;

            this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            this.addEventListener(MouseEvent.ROLL_OUT, onMouseRollOut);
            this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        }

        public function isInCorrectPosition():Boolean
        {
            if (_currentX != INVALID_VALUE && _currentY != INVALID_VALUE &&
                _currentX == _orderedX && _currentY == _orderedY)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public function setOrderedPosition(pOrderedX:int, pOrderedY:int):void
        {
            _orderedX = pOrderedX;
            _orderedY = pOrderedY;
        }

        public function getOrderedX():int
        {
            return _orderedX;
        }

        public function getOrderedY():int
        {
            return _orderedY;;
        }

        public function get onStage():Boolean
        {
            return _onStage;
        }

        public function set onStage(value:Boolean):void
        {
            _onStage = value;
        }

        private function onMouseDown(e:MouseEvent):void
        {

        }

        private function onMouseUp(e:MouseEvent):void
        {

        }

        private function onMouseRollOut(e:MouseEvent):void
        {

        }

        public function switchDrag(value:Boolean):void
        {

        }

        public function setDragRectangle(area:Rectangle):void
        {

        }


    }
}
