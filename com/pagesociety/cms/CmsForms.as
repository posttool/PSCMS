package com.pagesociety.cms
{
    import com.pagesociety.cms.config.CmsComponents;
    import com.pagesociety.cms.config.CmsConfig;
    import com.pagesociety.cms.form.EntityEditorStack;
    import com.pagesociety.cms.view.VV;
    import com.pagesociety.persistence.Entity;
    import com.pagesociety.persistence.EntityDefinition;
    import com.pagesociety.persistence.EntityDefinitionProvider;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.container.NavigationInfo;
    import com.pagesociety.ux.event.ComponentEvent;
    import com.pagesociety.web.amf.AmfLong;
    import com.pagesociety.web.module.CmsModule;
    
    import flash.events.Event;
    import flash.utils.getQualifiedClassName;

    public class CmsForms extends Container implements EntityDefinitionProvider
    {
        private var _config_obj:Object;
        private var _config:CmsConfig;
        private var _imported_editors:Object;
        
        private var _edit_entities:EntityEditorStack; 

        public function CmsForms(parent:Container, config_obj:Object, editors:Object)
        {
            super(parent);
            _imported_editors = {};
            add_editors(CmsComponents.STD_IMPORTS);
            add_editors(editors);
            _config_obj = config_obj;
            if (_config_obj==null)
                _config = new CmsConfig();
            else
                _config = new CmsConfig(_config_obj);
            _config.components = _imported_editors;
        }
        
        public function get config():CmsConfig
        {
            return _config;
        }
        
        private function add_editors(o:Object):void
        {
            for (var p:String in o)
                _imported_editors[p] = getQualifiedClassName(o[p]);
        }

//      protected function ok_to_go(try_again:Function):Boolean
//      {
//          if (!_edit_entities.closeForms())
//          {
//              _try_again = try_again;
//              
//              var c:Container = VV.confirm(this, "There are unsaved records.",
//                  ["save all", "cancel"],
//                  [confirm_f, cancel_f]);
//              
//              application.pushTakeOver(c, cancel_f);
//              return false;
//          }
//          return true;
//      }
        
        public function closeForms(force_save:Boolean=true,try_again:Function=null):void
        { 
            //application.hideTakeOver(); 
            if (_edit_entities!=null)
                _edit_entities.forceCloseForms(force_save,try_again);
            //render();
        }
        
        private function cancel_f(c:Event):void
        {
            application.hideTakeOver();
        }
        
        public function createUi(address:NavigationInfo):void
        {
            clear();
            _edit_entities = new EntityEditorStack(this, this, _config);
            _edit_entities.x = 10;
            _edit_entities.y = 10;
            _edit_entities.addEventListener(CmsEvent.CLOSE_FORM, onBubbleEvent);
            switch (address.address)    
            {
                case "create":
                    if (address.args.length==1)
                        _edit_entities.createEntity(address.args[0]);
                    break;
                case "edit":
                    if (address.args.length==2)
                        _edit_entities.editEntity(address.args[0], new AmfLong(address.args[1]));
                    break;
            }
            render();
        }

        public function provideEntityDefinition(n:String):EntityDefinition
        {
            return Entity.getDefinition(n);
        }
        
        public function provideEntityDefinitions():Array
        {
            return Entity.getDefinitions();
        }

    }
}