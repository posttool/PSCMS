package com.pagesociety.cms.component.button
{
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.text.Label;
	import com.pagesociety.ux.decorator.ShapeFactory;
	
	public class CancelButton extends Container
	{
		private var _icon:Component;
		private var _label:Label;
		public function CancelButton(parent:Container, index:int=-1)
		{
			super(parent, index);
			_icon = new Component(this);
			ShapeFactory.plus(_icon.decorator.midground.graphics, 6,8,4,0,1,4);
			_icon.decorator.rotation = 45;
			_label = new Label(this);
			_label.text = "CANCEL";
			_label.x = 15;
			height = 18;
			add_mouse_over_default_behavior();
		}
		
		override public function render():void
		{
			decorator.color = _over ? 0 : 0x777777;
			super.render();
		}
		
		override public function get width():Number
		{
			return _label.x + _label.width + 5;
		}
	}
}