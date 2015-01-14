package
{
    import flash.display.Sprite;
    import flash.text.TextField;

    import manager.LoaderManager;

    [SWF(width="1280" , height="960" , backgroundColor="#000000" , frameRate=30)]
    public class Puzzle extends Sprite
    {
        public function Puzzle ()
        {
            LoaderManager.getInstance().loadFile("configuration/config.info", LoaderManager.LOAD_DATA_FORMAT_TEXT);
        }
    }
}
