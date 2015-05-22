package com.pagesociety.cms.component.reference
{
	import com.pagesociety.web.ResourceModuleProvider;

	public interface IResourceEditor
	{
		function set moduleProvider(mp:ResourceModuleProvider):void;
		function set uploadTypes(a:Array):void;
	}
}