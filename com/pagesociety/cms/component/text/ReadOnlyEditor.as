package com.pagesociety.cms.component.text
{
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.text.Input;
	import com.pagesociety.ux.decorator.LabelDecorator;
	
	public class ReadOnlyEditor extends Input
	{
		public function ReadOnlyEditor(parent:Container)
		{
			super(parent);
			enabled = false;
			
		}
		
		
	}
}