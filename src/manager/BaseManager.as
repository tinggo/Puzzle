package manager
{
    import flash.events.EventDispatcher;

    public class BaseManager extends EventDispatcher
    {
        private var m_created:Boolean = false;
        protected var m_em:EventManager;

        public function BaseManager ()
        {
            if (!m_created)
            {
                m_em = new EventManager();
                m_created = true;
            }
            else
            {
                var e:Error = new Error();
                throw(e);
            }
        }

    }
}
