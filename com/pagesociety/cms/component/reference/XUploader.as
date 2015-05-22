package com.pagesociety.cms.component.reference
{
	import com.pagesociety.cms.CmsEvent;
	import com.pagesociety.cms.component.button.AddButton;
	import com.pagesociety.cms.component.button.CancelButton;
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
	
	public class XUploader extends Container implements IResourceEditor
	{
		public var cellRenderer:Function;
		
		private var _mid:Container;
		private var _cancel:CancelButton;
		private var _upload:MultipartUpload1;
		private var _loading:Progress;
		private var _file_types:Array;
		
		public function XUploader(parent:Container)
		{
			super(parent);
			
			_mid = new Container(this);
			_mid.layout = new GridLayout(GridLayout.GROW_VERTICALLY, 
				{ cellWidth: 100, cellHeight: 30, margin: new Margin(5,0,0,5)});
			_mid.backgroundColor = 0xffffff;
			_mid.backgroundAlpha = .99;
			_mid.backgroundVisible = true;

			_cancel = new CancelButton(this);
			_cancel.addEventListener(ComponentEvent.CLICK, on_click_cancel);
			_cancel.alignY(Guide.BOTTOM);
			_cancel.alignX(Guide.RIGHT);
		}
		
		private function on_click_cancel(e:*):void
		{
			_mid.clear();
			_upload.cancelAll();
			dispatchComponentEvent(UploadEvent.UPLOAD_CANCELED, this);
		}
		
		///////

		public function set moduleProvider(module_provider:ResourceModuleProvider):void
		{
			_upload 			= new MultipartUpload1(module_provider);
			_upload.addEventListener(UploadEvent.SELECT_FILE, select_files_for_upload);
			_upload.addEventListener(UploadEvent.DIALOG_CANCELED, translateEvent(UploadEvent.DIALOG_CANCELED));
			_upload.addEventListener(UploadEvent.UPLOAD_PROGRESS, on_upload_progress_info_ok);
			_upload.addEventListener(UploadEvent.UPLOAD_ERROR, on_upload_err);
		}
		
		public function set uploadTypes(preferred_file_types:Array):void
		{
			_file_types = preferred_file_types == null ? MultipartUpload.DEFAULT_TYPES : preferred_file_types;
		}
		
		public function get uploading():Boolean
		{
			return _upload.uploading;
		}
		
		public function init():void
		{
			_mid.clear();
			_upload.showFileSystemBrowser(_file_types);
		}
		
		public function get value():Array
		{
			var o:Array = [];
			for (var i:uint=0; i<_mid.children.length; i++)
				o.push(_mid.children[i].userObject);
			return o;
		}
		
		private function select_files_for_upload(e:UploadEvent):void
		{
			var new_refs:Array = e.data;
			var c:Progress;
			for (var i:uint=0; i<new_refs.length; i++)
			{
				c = get_progress(_mid, new_refs[i]);
				c.addEventListener(ComponentEvent.CANCEL, on_click_cancel_progress);
			}
			render();
		}
		
		protected function get_progress(parent:Container, file_ref:FileReference=null):Progress
		{
			return new Progress(parent, file_ref);
		}
		
		private function on_upload_progress_info_ok(e:UploadEvent):void
		{
			
			var upload:UploadProgressInfo 	= e.info;
			
			_loading 						= _mid.children[index_of_first_progress];
			_loading.progress 				= upload.progress/100;
			render();
			
			if (upload.completionObject != null)
			{
				add_to_browser(upload.completionObject);
				//_loading.complete = upload.completionObject;
				
				dispatchComponentEvent(UploadEvent.UPLOAD_COMPLETE, this, upload.completionObject);
				if (!has_progress)
					dispatchComponentEvent(UploadEvent.UPLOADS_COMPLETE, this, upload.completionObject);
			}
			
		}
		
		private function on_upload_err(e:UploadEvent):void
		{
			for (var i:uint=0; i<_mid.children.length; i++)
			{
				if (_mid.children[i] is Progress)
				{
					_mid.removeComponent(_mid.children[i]);
					i--;
				}
			}
			dispatchComponentEvent(UploadEvent.UPLOAD_ERROR, this, e);
		}
		
		private function on_click_cancel_progress(e:ComponentEvent):void
		{
			var p:Progress = e.component as Progress;
			_upload.cancel(p.fileReference);
			_mid.removeComponent(p)
			render();
		}
		
		public function add_to_browser(o:Object):void
		{
			var c:Component = cellRenderer(_mid,o);
			_mid.reIndexComponent(c, index_of_first_progress);
			_mid.removeComponent(_loading);
			render();
			dispatchEvent(new ComponentEvent(ComponentEvent.CHANGE_VALUE, this));
		}
		
		
		private function get index_of_first_progress():int
		{
			for (var i:uint=0; i<_mid.children.length; i++)
			{
				if (_mid.children[i] is Progress)
					return i;
			}
			throw new Error("NO PROGRESSES HERE");
		}
		
		private function get has_progress():Boolean
		{
			for (var i:uint=0; i<_mid.children.length; i++)
			{
				if (_mid.children[i] is Progress)
					return true;
			}
			return false;
		}
	}
}