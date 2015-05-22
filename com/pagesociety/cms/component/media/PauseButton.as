package com.pagesociety.cms.component.media
{
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.SpriteComponent;
//	import com.postera.art.PauseIcon;
	
	import flash.display.Graphics;
	
	public class PauseButton extends Component
	{
		public function PauseButton(parent:Container, index:int=-1)
		{
			super(parent);
//			super(parent, new PauseIcon());
//			sprite.mouseChildren = false;
//			sprite.x = 6;
//			sprite.y = 4;
			backgroundVisible = true;
			backgroundAlpha = 0;
		}
	}
}