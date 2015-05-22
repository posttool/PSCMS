package com.pagesociety.cms.component.reference
{
	import com.pagesociety.ux.IEditor;
	import com.pagesociety.web.ResourceModuleProvider;
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.Progress;
	import com.pagesociety.ux.event.ComponentEvent;
	import com.pagesociety.web.ErrorMessage;
	import com.pagesociety.web.upload.MultipartUpload;
	import com.pagesociety.web.upload.MultipartUpload1;
	import com.pagesociety.web.upload.UploadEvent;
	import com.pagesociety.web.upload.UploadProgressInfo;
	
	import flash.net.FileReference;

	[Event(type="com.pagesociety.web.upload.UploadEvent", name="upload_complete")]
	[Event(type="com.pagesociety.web.upload.UploadEvent", name="uploads_complete")]
	[Event(type="com.pagesociety.web.upload.UploadEvent", name="upload_error")]
	public class ResourceArrayEditor1 extends ReferenceArrayEditor implements IEditor, IResourceEditor
	{

		private var _upload:MultipartUpload1;
		private var _loading:Progress;
		private var _file_types:Array;
		
		public function ResourceArrayEditor1(parent:Container)
		{
			super(parent);
			cellHeight 			= 90;
		}
		
		public function set moduleProvider(module_provider:ResourceModuleProvider):void
		{
			_upload 			= new MultipartUpload1(module_provider);
			_upload.addEventListener(UploadEvent.SELECT_FILE, select_files_for_upload);
			_upload.addEventListener(UploadEvent.UPLOAD_PROGRESS, on_upload_progress_info_ok);
			_upload.addEventListener(UploadEvent.UPLOAD_ERROR, on_upload_err);
		}
		
		public function set uploadTypes(preferred_file_types:Array):void
		{
			_file_types = preferred_file_types == null ? MultipartUpload.DEFAULT_TYPES : preferred_file_types;
		}
		
		override public function set value(o:Object):void
		{
			if (o==null)
			{
				_browser.value = [];
			}
			else 
			{
				if (like(o as Array,_browser.value as Array))
				{
					_browser.dirty = false;
					return;
				}
				_browser.value = o;
			}
			if (variableHeight)
				dispatchComponentEvent(ComponentEvent.CHANGE_SIZE, this);
		}
		
		public function get uploading():Boolean
		{
			return _upload.uploading;
		}
		
		override protected function on_click_add(e:ComponentEvent):void
		{
			_upload.showFileSystemBrowser(_file_types);
		}
		
		private function select_files_for_upload(e:UploadEvent):void
		{
			var new_refs:Array = e.data;
			var c:Progress;
			
			for (var i:uint=0; i<new_refs.length; i++)
			{
				c = get_progress(_browser, new_refs[i]);
				c.addEventListener(ComponentEvent.CANCEL, on_click_cancel_progress);
			}
			
			render();
		}
		
		protected function get_progress(parent:Container, file_ref:FileReference=null):Progress
		{
			return new Progress(parent, file_ref);
		}
		
		private function get_session_id_err(e:ErrorMessage):void
		{
			Logger.error(e.stacktrace);
		}
		
		private function on_upload_progress_info_ok(e:UploadEvent):void
		{
				
			var upload:UploadProgressInfo 	= e.info;
			
			_loading 						= _browser.children[index_of_first_progress];
			_loading.progress 				= upload.progress/100;
			render();
			
			if (upload.completionObject != null)
			{
				if (hasEventListener(UploadEvent.UPLOAD_COMPLETE))
					dispatchComponentEvent(UploadEvent.UPLOAD_COMPLETE, this, upload.completionObject);
				else
					add_to_browser(upload.completionObject);
			}
			
		}

		private function on_upload_err(e:UploadEvent):void
		{
			for (var i:uint=0; i<_browser.children.length; i++)
			{
				if (_browser.children[i] is Progress)
				{
					_browser.removeComponent(_browser.children[i]);
					i--;
				}
			}
			dispatchComponentEvent(UploadEvent.UPLOAD_ERROR, this, e);
		}
		
		private function on_click_cancel_progress(e:ComponentEvent):void
		{
			var p:Progress = e.component as Progress;
			_upload.cancel(p.fileReference);
			_browser.removeComponent(p)
			render();
		}
		
		public function add_to_browser(o:Object):void
		{
			var c:Component = _browser.addValue(o);
			_browser.reIndexComponent(c, index_of_first_progress);
			_browser.removeComponent(_loading);
			render();
			dispatchEvent(new ComponentEvent(ComponentEvent.CHANGE_VALUE, this));
		}

		
		private function get index_of_first_progress():int
		{
			for (var i:uint=0; i<_browser.children.length; i++)
			{
				if (_browser.children[i] is Progress)
					return i;
			}
			throw new Error("NO PROGRESSES HERE");
		}
		
		
	}
}