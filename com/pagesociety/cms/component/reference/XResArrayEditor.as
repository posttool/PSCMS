package com.pagesociety.cms.component.reference
{
	import com.pagesociety.cms.CmsEvent;
	import com.pagesociety.cms.component.button.AddButton;
	import com.pagesociety.cms.component.button.LinkButton;
	import com.pagesociety.cms.config.CmsConfigEntityElement;
	import com.pagesociety.cms.view.EntityView0;
	import com.pagesociety.persistence.Entity;
	import com.pagesociety.persistence.FieldDefinition;
	import com.pagesociety.ux.Margin;
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.Progress;
	import com.pagesociety.ux.component.container.Browser;
	import com.pagesociety.ux.component.dim.Guide;
	import com.pagesociety.ux.component.text.Label;
	import com.pagesociety.ux.component.text.Link;
	import com.pagesociety.ux.component.text.Pager;
	import com.pagesociety.ux.container.List;
	import com.pagesociety.ux.container.PagingList;
	import com.pagesociety.ux.decorator.ShapeFactory;
	import com.pagesociety.ux.event.ComponentEvent;
	import com.pagesociety.ux.layout.FlowLayout;
	import com.pagesociety.ux.layout.GridLayout;
	import com.pagesociety.web.ResourceModuleProvider;
	import com.pagesociety.web.upload.MultipartUpload;
	import com.pagesociety.web.upload.MultipartUpload1;
	import com.pagesociety.web.upload.UploadEvent;
	import com.pagesociety.web.upload.UploadProgressInfo;
	
	import flash.net.FileReference;
	
	public class XResArrayEditor extends XRefArrayEditor  implements IResourceEditor
	{
		
		private var _upload:XUploader;
		
		public function XResArrayEditor(parent:Container)
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
			_pager.visible = false;
			_upload.visible = true;
			_upload.init();
			render();
		}
		
		private function on_upload_complete(e:*):void
		{
			_controls.visible = true;
			_pager.visible = true;
			_upload.visible = false;
			var v:Array = value as Array;
			var uv:Array = _upload.value;
			var sel:Array = [];
			for (var i:uint=0; i<uv.length; i++)
			{
				v.unshift(uv[uv.length-i-1]);
				sel.push(i);
			}
			_selected_indices = sel;
			value = v;
			page = 0;
			dirty = true;
			dispatchComponentEvent(ComponentEvent.CHANGE_VALUE,this,value);
			render();
		}
		
		private function on_upload_canceled(e:*):void
		{
			_controls.visible = true;
			_pager.visible = true;
			_upload.visible = false;
			render();
		}
		
	}
}