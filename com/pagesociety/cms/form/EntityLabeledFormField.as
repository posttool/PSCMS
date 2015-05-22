package com.pagesociety.cms.form
{
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.text.Label;
	import com.pagesociety.ux.event.ComponentEvent;
	
	public class EntityLabeledFormField extends Container
	{
		private var _label:Label;
		private var _editorc:Container;
		
		public var expanded:Boolean;
		
		public function EntityLabeledFormField(parent:Container)
		{
			super(parent);
			_label = new Label(this);
			_label.fontStyle = "black_small";
			_label.addEventListener(ComponentEvent.CLICK, on_click_label);

			_editorc = new Container(this);
			_editorc.y = 16;
			_editorc.x = 2;
			_editorc.widthDelta = -2;
			
			expanded = true;
		}
		
		public function get editorContainer():Container
		{
			return _editorc;
		}
		
		public function set label(s:String):void
		{
			_label.text = s.toUpperCase();
		}
		
		override public function get height():Number
		{
			if (_editorc.children.length==0 || !expanded)
				return _editorc.y + 5;
			else
				return _editorc.y + _editorc.children[0].height + 5;
		}
		
		override public function render():void
		{
			_editorc.visible = expanded;
			super.render();
		}
		
		private function on_click_label(e:ComponentEvent):void
		{
			expanded = !expanded;
			dispatchComponentEvent(ComponentEvent.CHANGE_SIZE, this);
		}
	}
}