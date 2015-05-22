package com.pagesociety.cms.component.text
{
	import com.pagesociety.cms.component.button.AddButton;
	import com.pagesociety.ux.IEditor;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.dim.Guide;
	import com.pagesociety.ux.event.ComponentEvent;
	
	public class StringArrayEditor extends TableInput implements IEditor
	{
		private var _add:AddButton;
		public function StringArrayEditor(parent:Container)
		{
			super(parent);
			columns = [ {label:"value"} ];
			headingVisible = false;
			inputStyle = "SmallInput";
			_add = new AddButton(this,"ADD");
			_add.addEventListener(ComponentEvent.CLICK, add_value);
		}
		
		private function add_value(e:*):void
		{
			addValue([""]);
			dispatchComponentEvent(ComponentEvent.CHANGE_SIZE, this);
		}
		
		override public function get height():Number
		{
			return super.height+20;
		}
		
		override public function render():void
		{
			_add.y = height-15;
			super.render();
		}
		
		
	}
}