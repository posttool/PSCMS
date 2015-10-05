package com.pagesociety.cms.form
{
    import com.pagesociety.WindowSize;
    import com.pagesociety.cms.CmsEvent;
    import com.pagesociety.cms.Constants;
    import com.pagesociety.cms.browser.EntityBrowserLinkable;
    import com.pagesociety.cms.browser.EntityBrowserOrderedPaged;
    import com.pagesociety.cms.config.CmsConfig;
    import com.pagesociety.cms.view.VV;
    import com.pagesociety.persistence.Entity;
    import com.pagesociety.persistence.EntityDefinition;
    import com.pagesociety.persistence.EntityDefinitionProvider;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.container.ScrollingContainer;
    import com.pagesociety.ux.container.StackContainer;
    import com.pagesociety.ux.decorator.ScrollBarDecorator;
    import com.pagesociety.ux.event.ComponentEvent;
    import com.pagesociety.ux.event.SelectionEvent;
    import com.pagesociety.web.ErrorMessage;
    import com.pagesociety.web.amf.AmfLong;
    import com.pagesociety.web.module.CmsModule;
    
    import flash.events.Event;

    public class EntityEditorStack extends Container
    {
        
        private var _def_provider:EntityDefinitionProvider;
        private var _config:CmsConfig;
        
        private var _stack_container:StackContainer;
        private var _browser:EntityBrowserLinkable;
        
        public function EntityEditorStack(parent:Container,def_provider:EntityDefinitionProvider,cms_config:CmsConfig,fully_qualified_browser_classname:String=null)
        {
            super(parent);
            _def_provider = def_provider;
            _config = cms_config;
            

            _browser = new EntityBrowserLinkable(this,_def_provider,fully_qualified_browser_classname);
            _browser.visible = false;
            _browser.addEventListener(SelectionEvent.SELECT, 
                function(e:*):void{ do_close_ref(_browser.selectionValue); });
            
            _stack_container = new StackContainer(this);
//          _stack_container.x = 10;
//          _stack_container.y = 10;
        }
        
    
        
        override public function render():void
        {
            if (_def_provider.provideEntityDefinitions()==null)
                return;
            
            super.render();
        }
        
        private function init_form(e:Entity):Object
        {
            var form:IForm = _config.getEntityEditor(_stack_container, e.type) as IForm; //new EntityForm(_stack_container); // todo COULD USE AN INTERFACE!!!!
            form.init(e, _config);
            form.addEventListener(CmsEvent.BROWSE_ENTITY_TYPE, open_browser);
            form.addEventListener(CmsEvent.CREATE_ENTITY, create_entity_event_1);
            form.addEventListener(CmsEvent.CLOSE_FORM, close_form);
            form.addEventListener(CmsEvent.SAVE_FORM, save_form);
            form.addEventListener(CmsEvent.EDIT_ENTITY, edit_entity_event_1);
            form.widthDelta = -120;
            return form;
        }
        
        private function open_browser(e:*):void
        {
//          var s:Object = WindowSize.getWindowSize();
            _browser.width = application.width-180;
            _browser.height = application.height-100;
            _browser.setSelectedType(e.data);
            application.pushTakeOver(_browser, on_close, Constants.TAKE_OVER_COLOR, Constants.TAKE_OVER_ALPHA);
        }

        private function on_close(e:*=null):void
        {
            application.popTakeOver();
        }
        
        private function create_entity_event_1(c:CmsEvent):void
        {
            createEntity(c.data as String);
            render();
        }
        
        public function createEntity(type:String):void
        {
            init_form(new Entity(type));
            render();
        }
    
        private function edit_entity_event_1(c:CmsEvent):void
        {
            editEntity(c.data.type, c.data.id);
        }

        public function editEntity(type:String, id:AmfLong):void
        {
            CmsModule.GetEntityById(type, id, edit_filled_entity, application.error);
        }
        
        private function edit_filled_entity(e:Entity):void
        {
            init_form(e);
            render();
        }
        
        private function close_form(e:CmsEvent=null):void
        {
            var form:IForm = _stack_container.children[_stack_container.children.length-1];
            var c:Container;
            if (form.dirty) 
            {
                 c = VV.confirm(this, "This page has been updated.\nWhat do you want to do?",
                    ["save", "save & close", "discard changes & close", "cancel"],
                    [save_only, save_and_close, on_discard_changes_close, cancel_close]);
                
                application.pushTakeOver(c, cancel_close);
            }
            else if (form.uploading)
            {
                c = VV.confirm(this, "An upload is in progress.\nPlease wait...",
                    ["ok"],
                    [cancel_close]);
                
                application.pushTakeOver(c, cancel_close);
            }
            else
            {
                do_close(form.value);
            }
        }
        
        private function save_form(e:CmsEvent):void
        {
            save_only(null);
        }
        
        private function save_only(c:ComponentEvent):void
        {
            var form:IForm = _stack_container.children[_stack_container.children.length-1];
            var e:Entity = form.value as Entity;
            save_entity(e, save_only_complete);
        }
        
        private function save_entity(e:Entity, on_complete:Function):void
        {
            
            if (e.id.longValue==-1)
                CmsModule.CreateEntity(e, on_complete, application.error);
            else
                CmsModule.UpdateEntity(e.type, e.id, e.dirtyValues, on_complete, application.error);
        }
        
        private function save_only_complete(o:Object):void
        {
            var form:IForm = _stack_container.children[_stack_container.children.length-1];
//          var e:Entity = o as Entity;
            CmsModule.GetEntityById(o.type,o.id, 
                function(e:Entity):void
                {
                    form.init(e, _config);  //after create, updates the id...
                    form.render();      
                }, application.error);
            application.hideTakeOver();
        }
        
        private function save_and_close(c:ComponentEvent):void
        {
            var form:IForm = _stack_container.children[_stack_container.children.length-1];
            var e:Entity = form.value as Entity;
            save_entity(e, do_close);
        }
        
        private function do_close(o:Object):void
        {
             _stack_container.pop();
             if(o != null)
             {
                 var form:IForm = _stack_container.children[_stack_container.children.length-1];
                 if (form!=null)
                     if (form.state==FormState.WAITING_FOR_CREATE || form.state==FormState.WAITING_FOR_UPDATE)
                        form.returnToForm(o);
             }
             render();
             application.hideTakeOver();

             if (_stack_container.children.length==0)
                dispatchEvent(new CmsEvent(CmsEvent.CLOSE_FORM, this, o));
             
        }
        
        private function on_discard_changes_close(e:ComponentEvent):void
        {
            do_close(null);
            
        }
        
        private function do_close_ref(o:Object):void
        {
            var form:IForm = _stack_container.children[_stack_container.children.length-1];
            if (form!=null)
                if (form.state==FormState.WAITING_FOR_REFERENCE)
                    form.returnToForm(o);
            render();
            application.hideTakeOver();
        }
        
        private function cancel_close(o:Object):void
        {
            application.hideTakeOver();
        }
        

        public function closeForms():Boolean
        {
            while (_stack_container.children.length!=0)
            {
                var form:IForm = _stack_container.children[_stack_container.children.length-1];
                if (form.dirty || form.uploading)
                    return false;
                _stack_container.pop();
            }
            return true;
        }
        
        public function forceCloseForms(autosave:Boolean,on_complete:Function):void
        {
            while (_stack_container.children.length!=0)
            {
                var form:IForm = _stack_container.pop() as IForm;
                if (form.dirty && autosave)
                {
                    save_entity(form.value as Entity, function(e:Entity):void
                    {
                        Logger.log("Autosaved "+e+" ... but didn't link in progress refs");
                    });
                }
            }
            if (on_complete!=null)
                on_complete();
        }
        
        
    
    }
}