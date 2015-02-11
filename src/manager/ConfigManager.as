package manager
{
    import flash.events.Event;

    import manager.BaseManager;

    public class ConfigManager extends BaseManager
    {
        public static const AREA_WIDTH:int = 920;
        public static const AREA_HEIGHT:int = 620;
        public static const POOL_X:int = 18;
        public static const POOL_Y:int = 62;
        public static const AREA_X:int = 332;
        public static const AREA_Y:int = 62;


        public var oneRoundTime:int;
        public var gridX:int;
        public var gridY:int;
        public var money:Number;
        public var fee:int;
        public var initFragmentCount:int;
        public var perTimeFragmentCount:int;
        public var perTimePurchase:int;
        public var perFragmentPrice:Number;
        public var testOneRoundTime:int;
        public var leastFragmentThreshold:int;

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
            dispatchEvent(new Event(Event.COMPLETE));
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
                case "grid":
                    this.gridY = int(value.split("*")[0]);
                    this.gridX = int(value.split("*")[1]);
                    break;
                case "money":
                    this.money = Number(value);
                    break;
                case "fee":
                    this.fee = int(value);
                    break;
                case "perTimeFragmentCount":
                    this.perTimeFragmentCount = int(value);
                    break;
                case "perTimePurchase":
                    this.perTimePurchase = int(value);
                    break;
                case "initFragmentCount":
                    this.initFragmentCount = int(value);
                    break;
                case "perFragmentPrice":
                    this.perFragmentPrice = Number(value);
                    break;
                case "testOneRoundTime":
                    this.testOneRoundTime = int(value);
                    break;
                case "leastFragmentThreshold":
                    this.leastFragmentThreshold = int(value);
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