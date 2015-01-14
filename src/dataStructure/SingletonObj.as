package dataStructure
{
    public class SingletonObj
    {
        private var m_created:Boolean = false;

        public function SingletonObj ()
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
