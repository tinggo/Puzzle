package manager
{
    import flash.events.EventDispatcher;

    public class BaseManager extends EventDispatcher
    {
        private var m_created:Boolean = false;

        public function BaseManager ()
        {
            if (!m_created)
            {
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
