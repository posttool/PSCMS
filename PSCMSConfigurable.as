package 
{
    import com.pagesociety.cms.CMS2;
    import com.pagesociety.cms.Constants;
    import com.pagesociety.cms.Dialog;
    import com.pagesociety.cms.Login;
    import com.pagesociety.persistence.Entity;
    import com.pagesociety.ux.ModuleApplication;
    import com.pagesociety.ux.event.ComponentEvent;
    import com.pagesociety.web.ErrorMessage;
    import com.pagesociety.web.module.User;
    
    import flash.utils.describeType;
    import flash.utils.getQualifiedClassName;
    
    [SWF(backgroundColor=0xFFFFFF, frameRate=30)]
    public class PSCMSConfigurable extends ModuleApplication
    {
        
        private var _cms:CMS2;
        private var _login:Login;
        public function PSCMSConfigurable()
        {
            super();
        }
        
        override public function init(params:Object=null):void
        {
            initModuleApplication(params, "static/style/cms.css", ["univers_55"]);
        }
        
        override public function initRootContainer():void 
        {
            super.initRootContainer();
            User.GetUser(on_get_user,error);
        }
        
        private function on_get_user(user:Entity):void
        {
            if (user==null)
            {
                _login = new Login(container);
                _login.addEventListener(ComponentEvent.CHANGE_VALUE, do_login);
                pushTakeOver(_login);
            }
            else
            {
                this.user = user;
                start_cms();
            }
            render();
        }
        
        private function do_login(e:ComponentEvent):void
        {
            User.Login(_login.email, _login.password, on_login_ok, error);
        }
        
        
        private function on_login_ok(r:Entity):void
        {
            this.user = r;
            hideTakeOver();
            container.removeComponent(_login);
            start_cms();
        }
        
        private function start_cms():void
        {
            var cfg:String = bootstrap.params.cms_config;
            var use_site_manager:Boolean = bootstrap.params.site_manager != null &&  bootstrap.params.site_manager.toLowerCase() == "true";
            var type:uint = use_site_manager ? CMS2.SERVICE_TYPE_SITE_MANAGER : CMS2.SERVICE_TYPE_CMS_ONLY;
            if (cfg==null)
            {
                _cms = new CMS2(container,type);
                render();
            }
            else
            {
                loadJson(cfg, function(config:*):void{
                    _cms = new CMS2(container,type,config);
                    render();
                } );
            }
        }
        
        override public function error(e:*):void
        {
            var msg:String = e.toString();
            if (e is Error)
                msg = Error(e).message;
            if (e is ErrorMessage)
                msg = ErrorMessage(e).message;//+"\n"+ErrorMessage(e).stacktrace;
            var d:Dialog = Dialog.createDialog(container,"ERROR",msg,Dialog.TYPE_CANCEL);
            d.addEventListener(Dialog.CANCEL, function():void { popTakeOver(); d.destroy() });
            pushTakeOver(d, function():void { popTakeOver(); d.destroy() }, Constants.TAKE_OVER_COLOR, Constants.TAKE_OVER_ALPHA);
        }
        
        
        
        
        
    }
}
