package com.pagesociety.cms.component
{
	import com.pagesociety.cms.config.CmsConfigEntityElement;
	import com.pagesociety.ux.IEditor;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.text.Input;
	import com.pagesociety.ux.event.ComponentEvent;

	public class IntEditor extends Input implements IEditor
	{
		
		public function IntEditor(parent:Container)
		{
			super(parent);
			restrict = "0-9";
		}
		
		override public function get value():Object
		{
			return parseInt(super.value as String);
		}
		
	}
}