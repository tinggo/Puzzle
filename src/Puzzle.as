package
{
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;

    import manager.AssetManager;
    import manager.ConfigManager;
    import manager.GameManager;
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

            AssetManager.getInstance().load(["asset/map/world.jpg"], bitmapLoadComplete);

            // TODO: Load sfx
            SceneManager.s_stage = this.stage;
            SceneManager.getInstance().init();
            // TODO: Start game work flow
        }

        private function bitmapLoadComplete():void
        {
            onResourceLoadComplete();
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
            GameManager.getInstance().init();
            GameManager.getInstance().resetGame();
        }
    }
}
