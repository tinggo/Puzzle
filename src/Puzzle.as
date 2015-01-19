package
{
    import flash.display.Sprite;
    import flash.events.Event;

    import manager.ConfigManager;

    [SWF(width="1280" , height="960" , backgroundColor="#000000" , frameRate=30)]
    public class Puzzle extends Sprite
    {
        public function Puzzle ()
        {
            // TODO: Stage setup
            //
            this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }

        private function onAddedToStage(e:Event):void
        {
            this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            this.init();
        }

        private function init():void
        {
            // Load config file
            ConfigManager.getInstance().loadConfig();
            // TODO: load assets
            // TODO: Load sfx
            // TODO: Init game scene
            // TODO: Start game work flow
        }
    }
}
