package com.pagesociety.cms.component.button
{
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.text.Label;
	import com.pagesociety.ux.decorator.ShapeFactory;
	
	public class CloseButton extends Container
	{
		
		private var _icon:Component;
		private var _xs:Number;
		public function CloseButton(parent:Container, xs:Number=18)
		{
			super(parent);
			_xs = xs;
			_icon = new Component(this);
			ShapeFactory.x(_icon.decorator.midground.graphics, xs*.5,xs*.5,xs,0,1,1);
			backgroundVisible = true;
			backgroundAlpha = 0;
			add_mouse_over_default_behavior();
		}
		
		override public function render():void
		{
			decorator.color = _over ? 0 : 0x777777;
			super.render();
		}
		
		override public function get width():Number
		{
			return _xs;
		}
	}
}