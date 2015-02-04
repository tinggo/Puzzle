package manager
{
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;

    public class LogManager extends BaseManager
    {
        private static var _instance:LogManager;
        private static var fileName:String = "statistic/statistic.csv";

        private var _fileStream:FileStream = new FileStream();

        private var _cacheString:String = null;

        public function LogManager()
        {
            super();
        }

        public static function getInstance():LogManager
        {
            if (_instance == null)
            {
                _instance = new LogManager();
            }
            return _instance;
        }

        public function openLogFile():void
        {
            var file:File = File.applicationDirectory;
            file = new File(file.resolvePath(fileName).nativePath);
            _fileStream.open(file, FileMode.APPEND);
        }

        public function writeToFile(str:String):void
        {
            _fileStream.writeUTFBytes(str);
        }

        public function closeLogFile():void
        {
            _fileStream.close();
        }

        public function cacheString(value:String):void
        {
            _cacheString += value;
            _cacheString += ",";
        }

        public function reset():void
        {
            _cacheString = "";
            openLogFile();
        }

        public function writeCache():void
        {
            _cacheString += "\n";
            if (PlayerManager.getInstance().isTest == false)
            {
                writeToFile(_cacheString);
            }
            closeLogFile();
        }
    }
}
