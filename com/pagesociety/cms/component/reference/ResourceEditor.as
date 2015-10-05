package com.pagesociety.cms.component.reference
{
    import com.pagesociety.persistence.Entity;
    import com.pagesociety.ux.IEditor;
    import com.pagesociety.web.ResourceModuleProvider;
    import com.pagesociety.ux.component.Button;
    import com.pagesociety.ux.component.Component;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.ImageResource;
    import com.pagesociety.ux.component.Progress;
    import com.pagesociety.ux.decorator.ImageDecorator;
    import com.pagesociety.ux.event.ComponentEvent;
    import com.pagesociety.ux.event.ResourceEvent;
    import com.pagesociety.web.ErrorMessage;
    import com.pagesociety.web.ModuleRequest;
    import com.pagesociety.web.upload.MultipartUpload;
    import com.pagesociety.web.upload.UploadEvent;
    import com.pagesociety.web.upload.UploadProgressInfo;

    [Event(type="com.pagesociety.ux.event.ComponentEvent", name="change_value")]
    [Event(type="com.pagesociety.cms.CmsEvent", name="upload_failed")]
    public class ResourceEditor extends Container implements IEditor, IResourceEditor
    {
        private static var _channel_count:uint = 0;
        private var _module_provider:ResourceModuleProvider;

        protected var _resource_entity:Entity;

        protected var _upload:MultipartUpload;
        protected var _uploading:Boolean;
        
        protected var _cprogress:Container;
        protected var _cimage:Container;
        protected var _cbuttons:Container;

        protected var _add_button:Component;
        // protected var _replace_button:Component;
        protected var _delete_button:Component;

        protected var _resource_preview:ImageResource;
        protected var _upload_progress:Progress;

        private var _dirty:Boolean;
        private var _file_types:Array;

        public function ResourceEditor(parent:Container)
        {
            super(parent);
            
            _cprogress = new Container(this);
            _cimage = new Container(this);
            _cbuttons = new Container(this);

            _upload_progress = get_progress(_cprogress);
            _upload_progress.addEventListener(ComponentEvent.CLICK, cancel_upload);
            _upload_progress.widthDelta = -2;

            _add_button = create_add_component(_cbuttons);
            _add_button.addEventListener(ComponentEvent.CLICK, on_click_browse);
//          _replace_button = create_replace_component(_cbuttons);
//          _replace_button.addEventListener(ComponentEvent.CLICK, on_click_replace);
            _delete_button = create_delete_component(_cbuttons);
            _delete_button.addEventListener(ComponentEvent.CLICK, on_click_delete);

            _uploading = false;
            _cprogress.visible = false;
            _cbuttons.visible = true;
            _add_button.visible = true;
            _delete_button.visible = false;
            //_replace_button.visible = false;
            _cimage.visible = false;
        }
        
        
        public function set moduleProvider(module_provider:ResourceModuleProvider):void
        {
            _module_provider = module_provider;
        }
        
        public function set uploadTypes(preferred_file_types:Array):void
        {
            _file_types         = preferred_file_types == null ? MultipartUpload.DEFAULT_TYPES : preferred_file_types;
        }


        protected function create_add_component(p:Container):Component
        {
            var add_button:Button = new Button(p);
            add_button.label = "BROWSE...";
            return add_button;
        }

        protected function create_replace_component(p:Container):Component
        {
            var replace_button:Button = new Button(p);
            replace_button.label = "REPLACE...";
            return replace_button;
        }

        protected function create_delete_component(p:Container):Component
        {
            var del_button:Button = new Button(p);
            del_button.label = "DELETE";
            return del_button;
        }

        protected function get_progress(parent:Container):Progress
        {
            return new Progress(parent);
        }

        public function set value(o:Object):void
        {
            _resource_entity = o as Entity;
            _dirty = false;
            update_ui();
            render();
        }
        
        private function update_ui():void
        {
            _upload_progress.progress = 0;
            _cprogress.visible = false;
            _cbuttons.visible = true;
            if (_resource_entity == null)
            {
                _add_button.visible = true;
                _delete_button.visible = false;
                //_replace_button.visible = false;
                _cimage.visible = false;
            }
            else
            {
                _add_button.visible = false;
                _delete_button.visible = true;
                //_replace_button.visible = true;
                _cimage.visible = true;
                if (_resource_preview!=null)
                    _cimage.removeComponent(_resource_preview);
                _resource_preview = new ImageResource(_cimage);
                _resource_preview.imageScalingType = ImageDecorator.IMAGE_SCALING_VALUE_FIT;
                _resource_preview.resource = _resource_entity;
                _resource_preview.addEventListener(ResourceEvent.LOAD_RESOURCE, function(e:*):void { render(); });
            }
        }

        public function get value():Object
        {
            return _resource_entity;
        }

        public function get uploading():Boolean
        {
            return _uploading;
        }

        public function get dirty():Boolean
        {
            return _dirty;
        }

        public function set dirty(b:Boolean):void
        {
            _dirty = b;
        }

        override public function render():void
        {
            if (_resource_preview!=null)
                _delete_button.x = _resource_preview.imageWidth + 5;
//          _replace_button.x = _delete_button.x-10-_replace_button.width;
            super.render();
        }

        private function on_click_browse(e:ComponentEvent):void
        {
            init_upload();
            _upload.showFileSystemBrowser(_file_types);
        }

        private function on_click_replace(e:ComponentEvent):void
        {
            init_upload();
            _upload.data.resource_id = _resource_entity.id.stringValue;
            _upload.showFileSystemBrowser(_file_types);
        }
        
        private function init_upload():void
        {
            _upload = new MultipartUpload(_module_provider);
            _upload.addEventListener(UploadEvent.UPLOAD_PROGRESS, on_upload_progress);
            _upload.addEventListener(UploadEvent.UPLOAD_CANCELED, on_cancel_upload_ok);
            _upload.addEventListener(UploadEvent.UPLOAD_ERROR, on_upload_err);
        }

        private function on_click_delete(e:ComponentEvent):void
        {
            ModuleRequest.doModule(_module_provider.DeleteResource(), [_resource_entity.id], on_delete_complete, on_error);
        }
        private function on_delete_complete(e:*):void
        {
            value = null;
            render();
            dispatchEvent(new ComponentEvent(ComponentEvent.CHANGE_VALUE, this));
        }
        
        private function on_upload_progress(e:UploadEvent):void
        {
                
            var upload:UploadProgressInfo = e.info;
            _uploading = true;
                
            _cbuttons.visible = false;
            _cimage.visible = false;
            _cprogress.visible = true;
            
            _upload_progress.progress = upload.progress/100;
            
            if (upload.completionObject != null)
            {
                value = upload.completionObject as Entity;
                _uploading = false;
                _dirty = true;
                dispatchEvent(new ComponentEvent(ComponentEvent.CHANGE_VALUE, this));
            }
            
            render();
            
        }

        private function on_error(e:ErrorMessage):void
        {
            Logger.error(e);
        }

        private function cancel_upload(e:ComponentEvent):void
        {
            _upload.cancel();
        }

        private function on_cancel_upload_ok(o:*):void
        {
            _uploading = false;
            value = null;
            render();
        }

        private function on_upload_err(e:UploadEvent):void
        {
            _uploading = false;
            value = null;
            dispatchComponentEvent(UploadEvent.UPLOAD_ERROR, this, e);
        }

    }
}