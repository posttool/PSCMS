package com.pagesociety.cms.form
{
    import com.pagesociety.WindowSize;
    import com.pagesociety.cms.CmsEvent;
    import com.pagesociety.cms.Constants;
    import com.pagesociety.cms.component.Row;
    import com.pagesociety.cms.component.button.CloseButton;
    import com.pagesociety.cms.component.media.VideoControllerB;
    import com.pagesociety.cms.component.reference.IResourceEditor;
    import com.pagesociety.cms.config.CmsConfig;
    import com.pagesociety.cms.config.CmsConfigEntity;
    import com.pagesociety.cms.config.CmsConfigEntityBucket;
    import com.pagesociety.cms.config.CmsConfigEntityElement;
    import com.pagesociety.cms.view.EntityView0;
    import com.pagesociety.cms.view.VV;
    import com.pagesociety.persistence.Entity;
    import com.pagesociety.persistence.FieldDefinition;
    import com.pagesociety.util.StringUtil;
    import com.pagesociety.ux.IEditor;
    import com.pagesociety.ux.Margin;
    import com.pagesociety.ux.component.Button;
    import com.pagesociety.ux.component.Component;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.Image;
    import com.pagesociety.ux.component.ImageResource;
    import com.pagesociety.ux.component.container.ScrollingContainer;
    import com.pagesociety.ux.component.dim.Guide;
    import com.pagesociety.ux.component.form.ReferenceEditor;
    import com.pagesociety.ux.component.form.ResourceArrayEditor1;
    import com.pagesociety.ux.component.form.ResourceEditor;
    import com.pagesociety.ux.component.media.Video;
    import com.pagesociety.ux.component.text.Label;
    import com.pagesociety.ux.container.List;
    import com.pagesociety.ux.container.ListEvent;
    import com.pagesociety.ux.decorator.ShapeFactory;
    import com.pagesociety.ux.decorator.VideoDecorator;
    import com.pagesociety.ux.event.BrowserEvent;
    import com.pagesociety.ux.event.ComponentEvent;
    import com.pagesociety.ux.layout.FlowLayout;
    import com.pagesociety.web.ResourceUtil;
    import com.pagesociety.web.ResourceModuleProvider;
    import com.pagesociety.web.module.Resource;
    import com.pagesociety.web.module.SiteManager;
    import com.pagesociety.web.upload.MultipartUpload;
    
    import flash.utils.Dictionary;

    public class ResourceForm extends Container implements IForm
    {
        private var _label:Label;
        private var _close:CloseButton;
//      private var _save:Button;
        private var _content:Container;
        private var _text:Label;
        private var _system_info:SystemInfo;
        
        private var _entity:Entity;
        
        public function ResourceForm(parent:Container)
        {
            super(parent);
            
            backgroundVisible           = true;
            backgroundColor             = Constants.COLOR_LIGHT;
            backgroundAlpha             = .99;
            backgroundShadowSize        = 23;
            backgroundShadowStrength    = .33;
//          cornerRadius                = 7;
            
            _label = new Label(this);
            _label.fontStyle = "black_title";//"cyan_big";
            _label.x = 25;
            _label.y = 15;

            _system_info = new SystemInfo(this);
            _system_info.width = 140;
            _system_info.xDelta = -170;
//          _system_info.addEventListener(ComponentEvent.CHANGE_VALUE, on_field_value_changed);
//          _system_info.addEventListener(SystemInfo.CHANGE_LANGUAGE, on_change_lang);
            
            _close = new CloseButton(this,10);
            _close.y = 11;
            _close.addEventListener(ComponentEvent.CLICK, do_close);
            
//          _save = new Button(this);
//          _save.y = 5;
//          _save.label = "SAVE"; 
//          _save.fontStyle = "black_big";
//          _save.addEventListener(ComponentEvent.CLICK, do_save);
            
            _content = new Container(this);
            _content.y = 120;
            _content.x = 25;
            _content.widthDelta = -150;
            _content.heightDelta = -220;
            
            _text = new Label(this);
            _text.multiline = true;
            _text.widthDelta = -100;
            _text.x = 25;
            _text.y = 50;
            _text.labelDecorator.linkEnabled = true;
            
        }
        
        override public function render():void
        {
            
//          _save.x = width - 160;
//          _save.enabled = dirty;
            _close.x = width - 40;
            
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
            value = e;
            var url:String = ResourceUtil.getPath(e);
            var display_info:CmsConfigEntity = config.getCmsConfigEntities().getDisplayInfo(e.type);
            _label.text = display_info.name+" "+e.id;
            _content.clear();
            switch(e.$[Resource.RESOURCE_FIELD_SIMPLE_TYPE])
            {
                case Resource.SIMPLE_TYPE_IMAGE_STRING:
                case Resource.SIMPLE_TYPE_SWF_STRING:
                    var img:Image = new Image(_content);
                    img.src = url;
                    break;
                case Resource.SIMPLE_TYPE_VIDEO_STRING:
                    var vid:VideoControllerB = new VideoControllerB(_content);
                    vid.resource = e;
                    //vid.video.scaleType = VideoDecorator.VIDEO_SCALE_VALUE_NONE;
                    vid.play();
                    break;
                case Resource.SIMPLE_TYPE_AUDIO_STRING:
                    //TODO
                    throw new Error("AUDIO PREVIEW UNHANDLED");
                    break;
            }
            _text.text = "<p>";
            _text.append("<a href='"+url+"' target='blank'>"+url+"</a> \n\n");
            for (var i:uint=0; i<e.definition.fieldNames.length; i++)
            {
                var fn:String = e.definition.fieldNames[i];
                var v:Object = e.$[fn];
                _text.append("<b>"+fn+"</b> "+v+"   ");
            }
            _text.append("</p>");
            
            render();
        }
        
        public function set value(o:Object):void
        {
            _entity = o as Entity;
        }
        
        
        public function get value():Object
        {
            return _entity;
        }
        
        

        public function get dirty():Boolean
        {
            return false;
        }
        
        public function set dirty(b:Boolean):void
        {
        }
        
        public function get uploading():Boolean
        {
            return false;
        }
        
        public function get state():uint
        {
            return FormState.OK;
        }
        
        public function returnToForm(e:*):void
        {
            //nothing returns to me- ever!
        }
        
    }
}
