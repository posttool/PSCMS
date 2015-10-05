package com.pagesociety.cms.form
{
    import com.pagesociety.cms.CmsEvent;
    import com.pagesociety.cms.Constants;
    import com.pagesociety.cms.component.Row;
    import com.pagesociety.cms.component.button.CloseButton;
    import com.pagesociety.cms.component.reference.IResourceEditor;
    import com.pagesociety.cms.config.CmsConfig;
    import com.pagesociety.cms.config.CmsConfigEntity;
    import com.pagesociety.cms.config.CmsConfigEntityBucket;
    import com.pagesociety.cms.config.CmsConfigEntityElement;
    import com.pagesociety.cms.view.VV;
    import com.pagesociety.persistence.Entity;
    import com.pagesociety.util.StringUtil;
    import com.pagesociety.ux.IEditor;
    import com.pagesociety.ux.Margin;
    import com.pagesociety.ux.component.Button;
    import com.pagesociety.ux.component.Component;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.container.ScrollingContainer;
    import com.pagesociety.ux.component.form.ResourceArrayEditor1;
    import com.pagesociety.ux.component.form.ResourceEditor;
    import com.pagesociety.ux.component.text.Label;
    import com.pagesociety.ux.container.List;
    import com.pagesociety.ux.container.ListEvent;
    import com.pagesociety.ux.event.ComponentEvent;
    import com.pagesociety.ux.layout.FlowLayout;
    import com.pagesociety.web.ResourceUtil;
    import com.pagesociety.web.module.SiteManager;
    import com.pagesociety.web.upload.MultipartUpload;
    
    import flash.utils.Dictionary;
    import flash.utils.getTimer;

    public class EntityForm extends Container implements IForm
    {
        protected var _label:Label;
        protected var _close:CloseButton;
        protected var _save:Button;
//      private var _delete:Button;
        private var _scroll:ScrollingContainer;
        protected var _left_col:Container;
        protected var _right_col:Container;
        protected var _system_info:SystemInfo;
        
        private var _entity:Entity;
        private var _fields:Array;
        private var _field_config:Dictionary;
        private var _field_containers:Array;

        
        public function EntityForm(parent:Container)
        {
            super(parent);
            
            backgroundVisible           = true;
            backgroundColor             = Constants.COLOR_LIGHT;
            backgroundAlpha             = .999;
            backgroundShadowSize        = 23;
            backgroundShadowStrength    = .33;
//          cornerRadius                = 7;
            
                        
            _scroll = new ScrollingContainer(this);
            _scroll.backgroundVisible = true;
            _scroll.backgroundAlpha = 0;
            
            _label = new Label(_scroll);
            _label.fontStyle = "black_title";//"cyan_big";
            _label.x = 25;
            _label.y = 15;

            _left_col = new Container(_scroll);
            _left_col.layout = new FlowLayout(FlowLayout.TOP_TO_BOTTOM, { margin: new Margin(23,0,0,0) } );
            _left_col.y = 50;
            _left_col.id = "left";
            
            _right_col = new Container(_scroll);
            _right_col.layout = new FlowLayout(FlowLayout.TOP_TO_BOTTOM, { margin: new Margin(23,0,0,0) } );
            _right_col.y = 50;
            _right_col.id = "right";

            _system_info = new SystemInfo(this);
            _system_info.width = 140;
            _system_info.xDelta = -170;
            _system_info.addEventListener(ComponentEvent.CHANGE_VALUE, on_field_value_changed);
            _system_info.addEventListener(SystemInfo.CHANGE_LANGUAGE, on_change_lang);
            
            _close = new CloseButton(this,10);
            _close.y = 11;
            _close.xDelta = -40;
            _close.addEventListener(ComponentEvent.CLICK, do_close);
            
            _save = new Button(this);
            _save.y = 11;
            _save.xDelta =  -160;
            _save.label = "SAVE"; 
            _save.fontStyle = "black_big";
            _save.addEventListener(ComponentEvent.CLICK, do_save);

        }
        
        override public function render():void
        {
            var w:Number = width-140;
            _left_col.x = 25;
            if (_right_col.children.length==0)
            {
                _left_col.width = w - 40;
                _right_col.visible = false;
            }
            else
            {
                _left_col.width = (w-85)/2;
                _right_col.visible = true;
                _right_col.width = _left_col.width;
                _right_col.x = 25+_left_col.width+15;
            }
            _save.enabled = dirty;
            
            _scroll.contentHeight = 110+Math.max(_left_col.layout.calculateHeight(), _right_col.layout.calculateHeight());
            //WindowSize.setHeight(height+150);
            
            super.render();
            
        }
        
        
        private function do_close(e:ComponentEvent):void
        {
            dispatchEvent(new CmsEvent(CmsEvent.CLOSE_FORM, this, value));
        }
        
        private function do_save(e:ComponentEvent):void
        {
            dispatchEvent(new CmsEvent(CmsEvent.SAVE_FORM, this, value));
        }
        
        public function init(e:Entity, config:CmsConfig):void
        {
            var display_info:CmsConfigEntity = config.getCmsConfigEntities().getDisplayInfo(e.type);

            if (e.id!=Entity.UNDEFINED)
            {
                _label.text = display_info.name+" "+e.id;
            }
            else
            {
                _label.text = "Unsaved "+display_info.name;
                e = new Entity(e.definition.name);
            }
        
            _fields = [];
            _field_config = new Dictionary();
            _field_containers = [];
            for (var p:String in display_info.buckets)
            {
                var bucket:CmsConfigEntityBucket = display_info.getBucket(p);
                var c:Container = getById(bucket.name) as Container;
                c.clear();
                _field_containers.push(c);
                var els:Array = bucket.elements;
                for (var i:uint=0; i<els.length; i++)
                {
                    var el:CmsConfigEntityElement = els[i];
                
                    if (el.isEditor)
                    {
                        var lf:EntityLabeledFormField = new EntityLabeledFormField(fieldContainer);
                        lf.addEventListener(ComponentEvent.CHANGE_SIZE, on_change_size);    
                        lf.label = el.name;
//                      lf.widthDelta = -20;
//                      if (el.field.isReference)
//                          lf.expanded = false;
                        
                        var eff:Object = config.getFieldEditor(lf.editorContainer, el); //as IEditor
                        if (el.props!=null)
                            application.style.apply(eff,el.props);
                        eff.addEventListener(ComponentEvent.CHANGE_VALUE, on_field_value_changed);
                        eff.addEventListener(ComponentEvent.CHANGE_SIZE, on_change_size);   
                        eff.addEventListener(ListEvent.DOUBLE_CLICK_ITEM, on_double_click_ref);
                        eff.addEventListener(CmsEvent.CREATE_ENTITY,  on_create_ref);
                        eff.addEventListener(CmsEvent.BROWSE_ENTITY_TYPE, on_link_ref);
                        eff.addEventListener(CmsEvent.DELETE_ENTITY, on_delete_entity);
                        
                        // set the context if this field has the appropriate setter/field
                        // if eff is IFormFieldEditor
                        if (eff.hasOwnProperty("form"))
                            eff.form = this;
                        
                        if (eff is IResourceEditor)
                        {
                            init_uploader(eff,el);
                        }
                        //
                        if (eff.isHeightUnset)
                        {
                            eff.height = 30;
                        }
    
                        _fields.push(eff);
                        _field_config[eff] = el;
                        
                    }
                    else if (el.component!=null)
                    {
                        if (el.component.indexOf("$")==0) // special  processing - when config has an array in a bucket, it becomes a row...
                        {
                            switch (el.component)
                            {
                                case "${":
                                    var r:Row = new Row(fieldContainer);
                                    _field_containers.push(r);
                                    break;
                                case "$}":
                                    _field_containers.pop();
                                    break;
                            }
                        }
                        else
                        {
                            var cp:Object = config.getComponent(fieldContainer, el);
                            if (el.props!=null)
                                application.style.apply(cp,el.props);
                            // set the context if this field has the appropriate setter/field
                            try {
                                eff.form = this;
                            }catch (e:Error){}
                        }
                    }
                }
            }
            
            value = e;
            
            _system_info.value = e;
            if(SiteManager.MetaInfo != null)
            {
                _system_info.languages = SiteManager.MetaInfo.additionalLanguages;
                update_lang();
            }
            else
            {
                _system_info.languages = [];
            }
            
            render();
        }
        
        private function get fieldContainer():Container
        {
            return _field_containers[_field_containers.length-1];
        }
        
        private function on_change_size(e:*):void
        {
            render();
        }
        
        private function init_uploader(c:Object, el:CmsConfigEntityElement):void
        {
            var r:IResourceEditor = IResourceEditor(c);
            r.moduleProvider = ResourceUtil.getModuleProvider(el.field);
            r.uploadTypes = [MultipartUpload.AllTypeFilter];
        }

        private function on_field_value_changed(c:ComponentEvent):void
        {
            collect_values();
            _save.enabled = true;
            _save.render();
        }
        
        private function on_change_lang(c:*=null):void
        {
            update_lang();
            render();
            
        }
        
        private function update_lang():void
        {
            for (var i:uint=0; i<_field_containers.length; i++)
            {
                for (var j:uint=0; j<_field_containers[i].children.length; j++)
                {
                    var lf:EntityLabeledFormField = _field_containers[i].children[j];
                    var config:CmsConfigEntityElement = _field_config[lf.editorContainer.children[0]];
                    //if (_system_info.languageValue==0)
                    //{
                    lf.visible = true;
                    //}
                    if (_system_info.languageValue==0)
                    {
                        
                    }
                    else if (_system_info.languageValue==1)
                    {
                        if (SiteManager.MetaInfo.isMultilingualField(_entity.type, config.field.name))
                        {
                            if (!SiteManager.MetaInfo.isPrimaryMultilingualField(_entity.type, config.field.name))
                                lf.visible = false;
                        }
                    }
                    else
                    {
                        lf.visible = StringUtil.endsWith(config.field.name,"_"+_system_info.languageValue);
                    }
                }
            }
        }
        
        
        private var _state:uint = FormState.OK;
        private var _target:IEditor;
        private var _target_config:CmsConfigEntityElement;
        
        private function on_double_click_ref(b:ComponentEvent):void
        {
            _state = FormState.WAITING_FOR_UPDATE;
            _target = IEditor(b.component);
            _target_config = _field_config[_target];
            var e:Entity = Entity(b.data); 
            dispatchEvent(new CmsEvent(CmsEvent.EDIT_ENTITY, this, e));
        }

        
        
        protected function on_create_ref(c:ComponentEvent):void
        {
            _state = FormState.WAITING_FOR_CREATE;
            _target = IEditor(c.component);
            _target_config = _field_config[_target];
            dispatchEvent(new CmsEvent(CmsEvent.CREATE_ENTITY,c.component,_target_config.field.referenceType));
        }
        
        protected function on_link_ref(c:ComponentEvent):void
        {
            _state = FormState.WAITING_FOR_REFERENCE;
            _target = c.component as IEditor;
            _target_config = _field_config[_target];
            dispatchEvent(new CmsEvent(CmsEvent.BROWSE_ENTITY_TYPE,c.component,_target_config));
        }
        
        protected function on_delete_entity(c:CmsEvent):void
        {
            var b:List = c.currentTarget as List;
            var sel:Array = b.selected;
            var msg:String = "Do you really want to remove "+(sel.length==1?"this":"these")+"?";
            var d:Container = VV.confirm(this, msg,
                ["yes", "cancel"],
                [function():void{
                    b.removeSelected();
                    b.dirty = true;
                    render();
                    close_takeover();
                }, close_takeover]);
            application.pushTakeOver(d, close_takeover, 0xffffff, .7);
        }
        
        private function close_takeover(e:*=null):void
        {
            application.popTakeOver();
        }
        
        public function get state():uint
        {
            return _state;
        }
        
        public function returnToForm(e:*):void
        {
            if (e==null)
                throw new Error("EntityForm.endWait NULL!");
            if (!(e is Array) && !(e is Entity))
                throw new Error("EntityForm.endWait UNKNOWN TYPE "+e);
            if (e is Entity &&  e.id.longValue==-1)
                return;
            var i:uint;
            var a:Array;
            
            if (_state==FormState.WAITING_FOR_CREATE)
            {
                if (_target_config.field.isArray())
                {
                    a = _entity.$[_target_config.field.name];
                    if (a == null) a = [];
                    a.push(e);
                    _entity.setAttribute(_target_config.field.name, a);
                }
                else
                    _entity.setAttribute(_target_config.field.name, e);
                set_field_value(_target);
                _target.dirty = true;
            }
            else if (_state==FormState.WAITING_FOR_UPDATE)
            {
                if (_target_config.field.isArray())
                {
                    for (i=0; i<_entity.$[_target_config.field.name].length; i++)
                    {
                        if (e.eq(_entity.$[_target_config.field.name][i]))
                            _entity.$[_target_config.field.name][i] = e;
                    }
                }
                else
                    _entity.$[_target_config.field.name] = e;
                set_field_value(_target);
            }
            else if (_state==FormState.WAITING_FOR_REFERENCE)
            {
                if (_target_config.field.isArray())
                {
                    a = _entity.$[_target_config.field.name];
                    if (a == null) a = [];
                    if (e is Entity)
                        a.unshift(e);
                    else if (e is Array)
                        for (i=0; i<e.length; i++)
                            a.unshift(e[i]);
                    _entity.setAttribute(_target_config.field.name, a);
                }
                else
                    if (e is Entity)
                        _entity.setAttribute(_target_config.field.name, e);
                    else if (e is Array)
                        _entity.setAttribute(_target_config.field.name, e[0]);

                set_field_value(_target);
                if (_target is List)
                {
                    var sel_idx:Array = [];
                    for (var j:uint=0; j<e.length; j++)
                        sel_idx.push(j);
                    List(_target).selected = sel_idx;
                    List(_target).page = 0;
                }
                _target.dirty = true;
            }
            
            _state = FormState.OK;
            render();
        }
        
        private function set_field_value(t:IEditor):void
        {
            var config:CmsConfigEntityElement = _field_config[t];
            if (config.isForSingleField)
            {
                t.value = _entity.$[config.field.name];
            }
            else
            {
                var a:Array = new Array();
                for (var i:uint=0; i<config.fields.length; i++)
                    a.push(_entity.$[config.fields[i].name]);
                t.value = a;
            }
        }
        
        
        
        
        /////
        
        public function set value(o:Object):void
        {
            _entity = o as Entity;
            for (var i:uint; i<_fields.length; i++)
                set_field_value(_fields[i]);
        }
        
        
        public function get value():Object
        {
            collect_values();
            return _entity;
        }
        
        private function collect_values():void
        {
            for (var i:uint; i<_fields.length; i++)
            {
                if (!_fields[i].dirty)
                    continue;
                var o:Object = _fields[i].value;
                var config:CmsConfigEntityElement = _field_config[_fields[i]];
                if (config.isForSingleField)
                {
                    _entity.setAttribute(config.field.name, o);
                }
                else
                {
                    if (config.fields.length!=o.length)
                        throw new Error("EntityForm cannot collect values- config.fields.length="+config.fields.length+" but IEditor.value.length="+o.length);
                    for (var j:uint=0; j<config.fields.length; j++)
                    {
                        _entity.setAttribute(config.fields[j].name, o[j]);
                    }
                }
            }
            if (_system_info.hasPublishedValue)
                _entity.setAttribute(SiteManager.PUBLISHABLE_ENTITY_PUBLICATION_STATUS_FIELD_NAME,_system_info.publishedValue);
        }

        public function get dirty():Boolean
        {
            for (var i:uint=0; i<_fields.length; i++)
                if (_fields[i].dirty)
                    return true;
            return false;
        }
        
        public function set dirty(b:Boolean):void
        {
            for (var i:uint=0; i<_fields.length; i++)
                _fields[i].dirty = b;
        }
        
        public function get uploading():Boolean
        {
            return find_uploading_resource_editor(this);
        }
        
        private function find_uploading_resource_editor(c:Component):Boolean
        {
            if (c is ResourceEditor)
            {
                var r0:ResourceEditor = c as ResourceEditor;
                if (r0.uploading)
                    return true;
            }
            if (c is ResourceArrayEditor1)
            {
                var r1:ResourceArrayEditor1 = c as ResourceArrayEditor1;
                if (r1.uploading)
                    return true;
            }
            if (c is Container)
            {
                var cc:Container = c as Container;
                for (var i:uint=0; i<cc.children.length; i++)
                {
                    if (find_uploading_resource_editor(cc.children[i]))
                        return true;
                }
            }
            return false;
        }
        
    }
}
