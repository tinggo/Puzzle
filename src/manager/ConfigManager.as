package manager
{
    import manager.BaseManager;

    public class ConfigManager extends BaseManager
    {
        public var oneRoundTime:int;
        public var map:String;
        public var gridX:int;
        public var gridY:int;
        public var money:int;
        public var fee:int;

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
            LoaderManager.getInstance().loadFile("configuration/config.info", LoaderManager.LOAD_DATA_FORMAT_TEXT, configLoadComplete);
        }

        private function configLoadComplete(content:Object):void
        {
            var configContent:String = content as String;
            anysicsConfig(configContent);
        }

        private function anysicsConfig(rawConfig:String):void
        {
            var configPair:Array = rawConfig.split("\r\n");
            for (var i:int = 0; i < configPair.length; ++i)
            {
                var oneLine:String = configPair[i];
                if (oneLine.indexOf("//") == 0)
                {
                    continue;
                }
                var key:String = getKey(oneLine);
                var value:String = getValue(oneLine);
                fillConfigKeyValue(key, value);
            }
        }

        private function fillConfigKeyValue(key:String, value:String):void
        {
            switch(key)
            {
                case "oneRoundTime":
                    this.oneRoundTime = int(value);
                    break;
                case "map":
                    this.map = value;
                    break;
                case "grid":
                    this.gridY = int(value.split("*")[0]);
                    this.gridX = int(value.split("*")[1]);
                    break;
                case "money":
                    this.money = int(value);
                    break;
                case "fee":
                    this.fee = int(value);
                    break;
            }
        }

        private function getKey(config:String):String
        {
            return config.split("=")[0];
        }

        private function getValue(config:String):String
        {
            return config.split("=")[1];
        }

    }
}