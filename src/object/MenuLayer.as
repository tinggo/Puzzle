package object
{
    import event.GameEvent;

    import flash.text.engine.ContentElement;

    import manager.GameManager;

    import menu.LoginMenu;
    import menu.PopupMenu;
    import menu.PurchaseMenu;

    public class MenuLayer extends SceneLayer
    {
        private var m_login:LoginMenu;
        private var m_popup:PopupMenu;
        private var m_purchase:PurchaseMenu;

        public function MenuLayer()
        {
            super();
            m_login = new LoginMenu(new login());
            m_popup = new PopupMenu(new popup());
            m_purchase = new PurchaseMenu(new purchase());
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

            if (m_purchase.parent)
            {
                this.removeChild(m_purchase);
            }
        }

        public function showLogin():void
        {
            clear();
            this.addChild(m_login);
            m_login.show();
        }

        public function showPurchase():void
        {
            clear();
            this.addChild(m_purchase);
            m_purchase.show();
        }

        public function showPopup(message:String, btnCount:int, btnLabel:Array, btnCallback:Array):void
        {
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