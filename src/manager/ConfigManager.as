package manager
{
    import config.Config;

    import dataStructure.SingletonObj;

    import flash.events.Event;

    import flash.filesystem.File;

    public class ConfigManager extends SingletonObj
    {
        private static var s_instance:ConfigManager;

        public function ConfigManager ()
        {
            super();
        }

        public static function getInstance():ConfigManager
        {
            if (!s_instance)
            {
                s_instance = new ConfigManager();
            }
            return s_instance;
        }

        public function loadConfig():void
        {

        }


    }
}
