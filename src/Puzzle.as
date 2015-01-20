package
{
import flash.display.Bitmap;
import flash.display.Sprite;
    import flash.events.Event;

import manager.AssetManager;

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

            AssetManager.getInstance().load(["asset/map/world.jpg"], bitmapLoadComplete);

            // TODO: Load sfx
            // TODO: Init game scene
            // TODO: Start game work flow
        }

        private function bitmapLoadComplete():void
        {
            var bitmap:Bitmap = AssetManager.getInstance().getBitmap("asset/map/world.jpg");
            addChild(bitmap);
        }
    }
}
