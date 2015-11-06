package com.pagesociety.cms
{
    import com.asual.swfaddress.SWFAddress;
    import com.pagesociety.cms.browser.EntityBrowserOrderedPaged;
    import com.pagesociety.cms.browser.EntityDefinitions;
    import com.pagesociety.cms.component.reference.XRefArrayEditor;
    import com.pagesociety.cms.component.reference.XRefEditor;
    import com.pagesociety.cms.component.reference.XResArrayEditor;
    import com.pagesociety.cms.component.reference.XResEditor;
    import com.pagesociety.cms.config.CmsConfig;
    import com.pagesociety.cms.config.CmsConfigEntity;
    import com.pagesociety.cms.sitemap.SiteMap;
    import com.pagesociety.persistence.Entity;
    import com.pagesociety.persistence.EntityDefinition;
    import com.pagesociety.ux.INetworkEventHandler;
    import com.pagesociety.ux.component.Component;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.container.ModalContainer;
    import com.pagesociety.ux.component.container.NavigableApplicationContainer;
    import com.pagesociety.ux.component.container.NavigationInfo;
    import com.pagesociety.ux.event.ComponentEvent;
    import com.pagesociety.web.ModuleRequest;
    import com.pagesociety.web.module.CmsModule;
    import com.pagesociety.web.module.SiteManager;
    import com.pagesociety.web.module.User;
    
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    import flash.utils.Timer;
    
    public class CMS2 extends NavigableApplicationContainer implements INetworkEventHandler
    {
        
        private var _bg:Component;
        private var _nav:Navigation;
        private var _content:ModalContainer;
        private var _sitemap:SiteMap;
        private var _choose_defs:EntityDefinitions;
        private var _browser:EntityBrowserOrderedPaged;
        private var _cms:CmsForms;
        private var _networking:NetworkIndicator;
        private var _service_type:uint;
        private var _config:Object;
        private var _components:Object;
        
        public static const SERVICE_TYPE_CMS_ONLY:uint = 0;
        public static const SERVICE_TYPE_SITE_MANAGER:uint = 1;
        
        
        public function CMS2(parent:Container, service_type:uint=SERVICE_TYPE_SITE_MANAGER, config:Object=null, components:Object=null)
        {
            super(parent);
            
            application.initSharedObject("pscms2");
            
            _service_type = service_type;
            _config = config;
            _components = components==null?{}:components;
            
            _bg = new Component(this);
            
            //loading...
            switch (_service_type)
            {
                case SERVICE_TYPE_CMS_ONLY:
                    CmsModule.GetEntityDefinitions( 
                        function(defs:Array):void 
                        {
                            Entity.setDefinitions(defs);
                            CmsModule.GetEntityIndices0( 
                                function(ind:Object):void
                                {
                                    Entity.setIndices(ind);
                                    init_ui();
                                }, application.error);
                                
                        }, application.error);
                    break;
                case SERVICE_TYPE_SITE_MANAGER:
                    SiteManager.GetSiteManagerMetaInfo(
                        function(info:Object):void
                        { 
                            SiteManager.SetSiteManagerMetaInfo(info);
                            init_ui();
                            render();
                        }, 
                        application.error);
                    break;
            }
        }
        
        private function init_ui():void
        {       
            _nav = new Navigation(this,_service_type);
            _nav.x = 10;
            _nav.y = 8;
            _nav.addEventListener(ComponentEvent.CHANGE_VALUE, on_nav);
            
            _content = new ModalContainer(this);
            _content.y = 55;
            _content.heightDelta = -55;
            
            if (_service_type==SERVICE_TYPE_SITE_MANAGER)
                init_sitemap();
            init_forms();
            init_def_chooser();
            init_browser();
        
            _networking = new NetworkIndicator(this);
            ModuleRequest.timeout = 1000*60*20;
            ModuleRequest.networkEventHandler = this;

            on_everything_ready();
        }
        
        protected function init_sitemap():void
        {
            _sitemap = new SiteMap(_content);
        }
        
        protected function init_def_chooser():void
        {
            var defs:Array = [];
            switch (_service_type)
            {
                case SERVICE_TYPE_CMS_ONLY:
                    var cfges:Array = _cms.config.getTopLevelEntities();
                    for (var i:uint=0; i<cfges.length; i++)
                    {
                        var cfge:CmsConfigEntity = cfges[i];
                        defs.push(cfge.entityDefinition);
                    }
                    break
                case SERVICE_TYPE_SITE_MANAGER:
                    defs = SiteManager.MetaInfo.publishableEntities;
                    break;
            }
            _choose_defs = new EntityDefinitions(_content, defs);
            _choose_defs.addEventListener(CmsEvent.BROWSE_ENTITY_TYPE, function(e:ComponentEvent):void
            {
                var def:EntityDefinition = e.data as EntityDefinition;
                application.navigate("browse1", [def.name]);
            });
            _choose_defs.addEventListener(CmsEvent.CREATE_ENTITY, function(e:ComponentEvent):void
            {
                var def:EntityDefinition = e.data as EntityDefinition;
                application.navigate("create", [def.name]);
            });
        }
        
        protected function init_browser():void
        {
            _browser = new EntityBrowserOrderedPaged(_content);
            _browser.y = 15;
            _browser.heightDelta = -15;
            _browser.addEventListener(CmsEvent.EDIT_ENTITY, function(e:*):void 
            { 
                navigate("edit", [e.data[0].type, e.data[0].id]); 
            });
            _browser.addEventListener(CmsEvent.CREATE_ENTITY, function(e:*):void 
            { 
                navigate("create", [e.data.name]); 
            });
        }
        
        protected function init_forms():void
        {
            _cms = new CmsForms(_content,_config,_components);
            _cms.addEventListener(CmsEvent.CLOSE_FORM, function(e:*):void{ navigateBack(); });
        }
        
        public function get config():CmsConfig
        {
            return _cms.config;
        }
        
        override public function render():void
        {
            Constants.drawGradient(_bg.decorator.graphics, width, height);
            super.render();
        }
        
        private function on_nav(e:ComponentEvent):void
        {
            navigate(e.data.userObject);
        }
        
        override protected function create_ui(address:NavigationInfo):void
        {
            Logger.log("NAVIGATE: "+address.address);
            //WindowSize.set100Percent();
            
            _nav.update(address);
            switch (address.address)
            {
                case "browse":
                    _cms.closeForms();
                    _content.showChild(_choose_defs);
                    break;
                case "browse1":
                    var type:String = address.args[0];
                    var for_image:Boolean = type=="Image";
                    _browser.fillDeep = for_image;
                    _browser.title = type;
                    _browser.cellHeight = for_image?100:20;
                    _browser.cellWidth = for_image?150:350;
                    _browser.selectEntities(Entity.getDefinition(type));
                    _content.showChild(_browser);
                    break;
                case "create":
                case "edit":
                    _cms.createUi(address);
                    _content.showChild(_cms);
                    break;
                case "siteMap":
                default:
                    switch (_service_type)
                    {
                        case SERVICE_TYPE_CMS_ONLY:
                            _cms.closeForms();
                            _content.showChild(_choose_defs);
                            break;
                        case SERVICE_TYPE_SITE_MANAGER:
                            _cms.closeForms();
                            _sitemap.getData();
                            _content.showChild(_sitemap);
                            break;
                    }
                    break;
                case "logout":
                    logout();
                    break;
            }
            render();
            

        }
        
        
        private function logout():void
        {
            User.Logout(on_logout_ok, application.error); 
        }
        
        private function on_logout_ok(e:*=null):void
        {
//          navigateToURL(new URLRequest("."));
            SWFAddress.href("index.fhtml");
        }
        
        public function beginModuleRequest(r:ModuleRequest):void
        {
            networking = true;
        }
        
        public function endModuleRequest(r:ModuleRequest,status:uint,arg:Object):void
        {
            networking = false;
        }
        
        public function set networking(b:Boolean):void
        {
            if (_networking==null)
                return;
            _networking.visible = b;
            _networking.render();
        }
        
        private var _timeout_waiting:Boolean = false;
        public function timeout():void
        {
            if (_timeout_waiting)
                return;
            Dialog.confirm
            (this,"You have been inactive for too long. I am going to log you out!", 
                function():void
                {
                    _timeout_waiting = false;
                    User.GetUser(function(e:Entity):void{},application.error);
                },
                function():void
                {
                    logout();
                });
            var t:Timer = new Timer(1000*60*2, 1);
            t.addEventListener(TimerEvent.TIMER,
                function(e:*):void
                {
                    logout();
                });
            t.start();
        }
        
    }
}
