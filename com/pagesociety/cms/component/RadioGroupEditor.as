package com.pagesociety.cms.component
{
	import com.pagesociety.cms.config.CmsConfigEntityElement;
	import com.pagesociety.ux.IEditor;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.form.RadioGroup;
	import com.pagesociety.ux.event.ComponentEvent;

	[Event(type="com.pagesociety.ux.event.ComponentEvent", name="change_value")]
	public class RadioGroupEditor extends RadioGroup
	{
		
		public function RadioGroupEditor(parent:Container)
		{
			super(parent);
			height = 30;
		}
		
		public function set options(v:Array):void
		{
			clear();
			for (var i:uint=0; i<v.length; i++)
			{
				if (v[i] is String)
					addOption(v[i]);
				else if (v[i] is Array && v[i].length>1)
					addOption(v[i][0],v[i][1]);
				else if (v[i] is Object)
					addOption(v[i].name, v[i].value);
				else 
					addOption(v[i].toString());
			}
		}
		
		
	}
}