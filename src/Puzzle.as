package
{
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;

    import manager.AssetManager;
    import manager.ConfigManager;
    import manager.GameManager;
    import manager.LocManager;
    import manager.LogManager;
    import manager.SceneManager;

    [SWF(width="1280", height="720", backgroundColor="#666666", frameRate=30)]
    public class Puzzle extends Sprite
    {
        public function Puzzle()
        {
            new Include();
            // TODO: Stage setup
            this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }

        private function init():void
        {
            // Load config file
            ConfigManager.getInstance().loadConfig();
            ConfigManager.getInstance().addEventListener(Event.COMPLETE, onConfigLoadComplete);
        }

        private function onConfigLoadComplete(e:Event):void
        {
            LocManager.getInstance().loadLoc();
            LocManager.getInstance().addEventListener(Event.COMPLETE, onLocLoadComplete);
        }

        private function bitmapLoadComplete():void
        {
            onResourceLoadComplete();
        }

        private function onLocLoadComplete(e:Event):void
        {
            AssetManager.getInstance().load(["asset/map/world.jpg"], bitmapLoadComplete);
        }

        private function onAddedToStage(e:Event):void
        {
            this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            stage.scaleMode = StageScaleMode.EXACT_FIT;
            stage.align = StageAlign.TOP;
            this.init();
        }

        private function onResourceLoadComplete():void
        {
            // TODO: Load sfx
            SceneManager.s_stage = this.stage;
            SceneManager.getInstance().init();
            // TODO: Start game work flow
            GameManager.getInstance().init();
            GameManager.getInstance().resetGame();
        }
    }
}
