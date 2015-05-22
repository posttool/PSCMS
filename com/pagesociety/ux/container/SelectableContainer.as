package com.pagesociety.ux.container
{
	import com.pagesociety.ux.ISelectable;
	import com.pagesociety.ux.component.Container;

	public class SelectableContainer extends Container implements ISelectable
	{
		
		protected var _selected:Boolean = false;
		
		public function SelectableContainer(parent:Container, index:Number=-1)
		{
			super(parent, index);
		}
		
		public function set selected(b:Boolean):void
		{
			_selected = b;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		override public function render():void
		{
			render_selected(_selected);
			super.render();
		}
		
		protected function render_selected(sel:Boolean):void
		{
			if (_selected)
			{
				backgroundBorderThickness = 3;
				backgroundShadowSize = 4;
				backgroundShadowStrength = .4;
			}
			else
			{
				backgroundBorderThickness = .5;
				backgroundShadowSize = 0;
			}
		}
		
		
	}
}