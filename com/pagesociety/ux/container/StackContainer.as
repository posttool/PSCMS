package com.pagesociety.ux.container
{
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;

	public class StackContainer extends Container
	{
		
		public function StackContainer(parent:Container)
		{
			super(parent);
		}
		

		public function pop():Component
		{
			var last:Component = children[children.length-1];
			removeComponent(last);
			return last;
		}
		
		public function popUntil(o:Object):void
		{
			var p:Component = pop();
			while (p!=o)
				p = pop();
		}
		
		private var _number_of_children_to_show:uint = 4;
		override public function render():void
		{
			var c:uint = children.length;
			var n:int = c - _number_of_children_to_show;
			if (n<0) n = 0;
			for (var i:uint=0; i<n; i++)
				children[i].visible = false;

			for (i=n; i<c; i++)
			{
				var bc:Component = children[i];
				bc.visible = true;
				bc.x = x+(i-n)*15;
				bc.y = y+(i-n)*20;
				bc.heightDelta = -bc.y;
				if (i==c-1)
					bc.alpha = 1;
				else
					bc.alpha = Math.max(.1,.9-(c-i)*.3);
				//bc.blur = (c-i-1)*.75;
				//bc.decorator.rasterize = (i != c-1); //because they stretch, cant do
				bc.render();
			}
			decorator.decorate();


		}
		
		
		
		private var _x_step:Number = 80;
		private function render_little_pages():void
		{
			decorator.decorate();
			var c:Component;
			var xx:Number = 0;
			var b:Number = 1;
			for (var i:int=children.length-2; i>-1; i--)
			{
				
				c = children[i];
				c.x = xx;
				c.y = -75; // - (i%2)*10;
				c.backgroundColor = 0xFAFAFA;
				c.backgroundAlpha = 1;
				c.backgroundShadowSize = 8;
				c.decorator.scaleX = .075;
				c.decorator.scaleY = .075;
				c.decorator.rasterize = true;
				c.render();
				xx += _x_step;
				b -= .1;
				
			}
			c = children[children.length-1];
			c.x = 0;
			c.y = 0;
			c.backgroundColor = 0xFFFFFF;
			c.backgroundAlpha = 1;
			c.backgroundShadowSize = 0;
			c.decorator.scaleX = 1;
			c.decorator.scaleY = 1;
			c.decorator.rasterize = false;
			c.render();
		}
		
		
		
		
		public function render_blur_back():void
		{
			decorator.decorate();
			var a:Number = 1;
			var x:Number = 0;
			var y:Number = 0;
			for (var i:int=children.length-1; i>-1; i--)
			{
				var c:Component = children[i];
				c.alpha = a;
				//c.x = x;
				c.y = y;
				c.blur = x;
				x += 5;
				y -= 30;
				if (i==children.length-1)
					a -= .7
				else
					a -= .15;
				
				children[i].visible = (a>0);
				if (a>0) children[i].render();
			}
		}
		
	}
}