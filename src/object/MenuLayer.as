package object
{
    import event.GameEvent;

    import flash.text.engine.ContentElement;

    import manager.GameManager;

    import menu.LoginMenu;
    import menu.PopupMenu;

    public class MenuLayer extends SceneLayer
    {
        private var m_login:LoginMenu;
        private var m_popup:PopupMenu;

        public function MenuLayer()
        {
            super();
            m_login = new LoginMenu(new login());
            m_popup = new PopupMenu(new popup());
        }

        override public function init():void
        {

        }

        public function clear():void
        {
            if (m_login.parent)
            {
                this.removeChild(m_login);
            }

            if (m_popup.parent)
            {
                this.removeChild(m_popup);
            }
        }

        public function showLogin():void
        {
            clear();
            this.addChild(m_login);
            m_login.show();
        }

        public function showPopup(message:String, btnCount:int, btnLabel:Array, btnCallback:Array):void
        {
            clear();
            this.addChild(m_popup);
            m_popup.showPopup(message, btnCount, btnLabel, btnCallback);
        }

        public function hidePopup():void
        {
            if (m_popup.parent)
            {
                this.removeChild(m_popup);
            }
        }

        public function onStageChanged(curState:int):void
        {
            if (curState == GameManager.GAME_STATE_INTRO)
            {
                showLogin();
            }
            else if (curState == GameManager.GAME_STATE_GAME)
            {
                clear();
            }
            else if (curState == GameManager.GAME_STATE_END)
            {

            }
        }

    }
}