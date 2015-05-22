package com.pagesociety.cms.sitemap
{
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.TreeNode;
	import com.pagesociety.ux.decorator.ShapeFactory;
	
	import flash.geom.Point;

	public class CmsTreeNodeAdd extends TreeNode
	{

		public function CmsTreeNodeAdd(parent:Container)
		{
			super(parent);
			backgroundVisible = false;
//			tooltip = "  Add a page... ";
			add_mouse_over_default_behavior();

		}
		
		override public function getToolTipOffset():Point
		{
			return new Point(width/2+13, height/2+6)
		}
		
		override public function acceptsChild(t:TreeNode):Boolean
		{
			return false;
		}
		
		
		override public function render():void
		{
			decorator.updatePosition(x,y);
			var c:Number = _over ? 0x333333 : 0x888888;
			ShapeFactory.plus(decorator.graphics, width*.5, height*.5, width*.1, c, 1, 6);
		
		}
		
		
	}
}