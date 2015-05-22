package com.pagesociety.cms.component
{
	import com.pagesociety.cms.config.CmsConfigEntityElement;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.text.Calendar;
	import com.pagesociety.ux.component.text.Input;

	public class DateEditor extends Calendar
	{
		public function DateEditor(parent:Container)
		{
			super(parent);
		}
		
		override public function get value():Object
		{
			return new Date(super.value);
		}
		
		
		
	}
} 