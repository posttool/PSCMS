package com.pagesociety.cms.component.reference
{
	import com.pagesociety.cms.CmsEvent;
	import com.pagesociety.cms.component.button.AddButton;
	import com.pagesociety.cms.component.button.LinkButton;
	import com.pagesociety.cms.view.EntityView0;
	import com.pagesociety.persistence.Entity;
	import com.pagesociety.ux.Margin;
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.dim.Guide;
	import com.pagesociety.ux.container.List;
	import com.pagesociety.ux.event.ComponentEvent;
	import com.pagesociety.ux.layout.FlowLayout;
	import com.pagesociety.ux.layout.GridLayout;
	import com.pagesociety.web.ResourceModuleProvider;
	import com.pagesociety.web.upload.UploadEvent;
	
	public class XResEditor extends XRefEditor  implements IResourceEditor
	{
		private var _add:AddButton;
		private var _link:LinkButton;
		
		private var _upload:XUploader;
		
		public function XResEditor(parent:Container)
		{
			super(parent,"UPLOAD");
						
			_upload = new XUploader(this);
			_upload.cellRenderer = default_cell_render;
			_upload.visible = false;
			_upload.addEventListener(UploadEvent.UPLOADS_COMPLETE, on_upload_complete);
			_upload.addEventListener(UploadEvent.UPLOAD_CANCELED, on_upload_canceled);
			_upload.addEventListener(UploadEvent.DIALOG_CANCELED, on_upload_canceled);

		}

	
		public function set moduleProvider(module_provider:ResourceModuleProvider):void
		{
			_upload.moduleProvider = module_provider;
		}
		
		public function set uploadTypes(preferred_file_types:Array):void
		{
			_upload.uploadTypes = preferred_file_types;
		}
		
		public function get uploading():Boolean
		{
			return _upload.uploading;
		}
		
		override protected function on_click_create(e:ComponentEvent):void
		{
			_controls.visible = false;
			_upload.visible = true;
			_upload.init();
			render();
		}
		
		private function on_upload_complete(e:*):void
		{
			_controls.visible = true;
			_upload.visible = false;
			value = _upload.value[0];
			dirty = true;
			page = 0;
			dispatchComponentEvent(ComponentEvent.CHANGE_VALUE, this);
			render();
		}
		
		private function on_upload_canceled(e:*):void
		{
			_controls.visible = true;
			_upload.visible = false;
			render();
		}
		
	}
}