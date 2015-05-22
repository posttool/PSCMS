package com.pagesociety.cms.form
{
	import com.pagesociety.cms.config.CmsConfig;
	import com.pagesociety.persistence.Entity;
	import com.pagesociety.ux.IComponent;
	import com.pagesociety.ux.IEditor;

	public interface IForm extends IEditor, IComponent
	{
		function init(e:Entity, config:CmsConfig):void;
		function get uploading():Boolean;
		function get state():uint;
		function returnToForm(data:*):void;
	}
}