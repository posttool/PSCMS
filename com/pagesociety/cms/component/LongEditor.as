package com.pagesociety.cms.component
{
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.text.Input;
	import com.pagesociety.web.amf.AmfLong;

	public class LongEditor extends Input
	{
		public function LongEditor(parent:Container)
		{
			super(parent);
			restrict = "0-9";
		}
		
		override public function get value():Object
		{
			var i:String = super.value as String;
			var ii:int = parseInt(i);
			if (isNaN(ii))
				return new AmfLong(0);
			return new AmfLong(ii);
		}
		
		
		
	}
}