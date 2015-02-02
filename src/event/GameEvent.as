
package event
{
    public class GameEvent extends ParaEvent
    {
        public static const GAME_STATE_CHANGED:String = "game_state_changed";
        public static const BUY_FRAGMENTS:String = "buy_fragments";

        public function GameEvent(type:String, para:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, para, bubbles, cancelable);
        }
    }
}
