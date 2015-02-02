package object
{
    import event.ParaEvent;

    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    import manager.SceneManager;

    public class Fragment extends Sprite
    {
        public static const EVT_FRAGMENT_PLACED:String = "evt_fragment_placed";
        public static const EVT_FRAGMENT_SELECTED:String = "evt_fragment_selected";

        public static const INVALID_VALUE:int = -1;

        private var _currentX:int;
        private var _currentY:int;
        private var _gridIndex:int;

        private var _orderedX:int;
        private var _orderedY:int;

        private var _onStage:Boolean = false;
        private var _dragArea:Rectangle;

        private var _clickDownOffsetX:int;
        private var _clickDownOffsetY:int;

        private var  _dragging:Boolean;

        public function Fragment()
        {
            super();

            reset();
            this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        }

        public function reset():void
        {
            _currentX = INVALID_VALUE;
            _currentY = INVALID_VALUE;
            _gridIndex = INVALID_VALUE;
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
            _dragging = true;
            stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            var globalPoint:Point = this.localToGlobal(new Point(0, 0))
            _clickDownOffsetX = e.stageX - globalPoint.x;
            _clickDownOffsetY = e.stageY - globalPoint.y;
            dispatchEvent(new ParaEvent(EVT_FRAGMENT_SELECTED));
        }

        private function onMouseUp(e:MouseEvent):void
        {
            tryStopDrag();
        }

        private function tryStopDrag():void
        {
            if (_dragging)
            {
                stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                _dragging = false;
                dispatchEvent(new ParaEvent(EVT_FRAGMENT_PLACED));
            }
        }

        private function onMouseMove(e:MouseEvent):void
        {
            this.x = e.stageX - _clickDownOffsetX;
            this.y = e.stageY - _clickDownOffsetY;
            if (this.x < _dragArea.x)
            {
                this.x = _dragArea.x;
            }
            if (this.x > _dragArea.width - this.width)
            {
                this.x = _dragArea.width - this.width;
            }
            if (this.y < _dragArea.y)
            {
                this.y = _dragArea.y;
            }
            if (this.y > _dragArea.height - this.height)
            {
                this.y = _dragArea.height - this.height;
            }

            if (e.stageX < 0 || e.stageX > SceneManager.s_stage.stageWidth ||
                e.stageY < 0 || e.stageY >SceneManager.s_stage.stageHeight)
            {
                tryStopDrag();
            }
        }

        public function switchDrag(value:Boolean):void
        {

        }

        public function setDragRectangle(area:Rectangle):void
        {
            _dragArea = area;
        }

        public function get currentX():int
        {
            return _currentX;
        }

        public function set currentX(value:int):void
        {
            _currentX = value;
        }

        public function get currentY():int
        {
            return _currentY;
        }

        public function set currentY(value:int):void
        {
            _currentY = value;
        }

        public function get gridIndex():int
        {
            return _gridIndex;
        }

        public function set gridIndex(value:int):void
        {
            _gridIndex = value;
        }
    }
}
