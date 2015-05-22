package com.pagesociety.cms.component
{
	import com.pagesociety.cms.config.CmsConfigEntityElement;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.text.Input;
	import com.pagesociety.ux.event.ComponentEvent;

	public class NumberEditor extends Input
	{
		
		public function NumberEditor(parent:Container)
		{
			super(parent);
			restrict = "0-9.";
		}
		
		override public function get value():Object
		{
			return parseFloat(value as String);
		}
		
	}
		
}