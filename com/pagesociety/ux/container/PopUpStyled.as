package com.pagesociety.ux.container
{
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.PopUpMenu;
	import com.pagesociety.ux.decorator.ShapeFactory;
	
	import flash.display.Graphics;

	public class PopUpStyled extends PopUpMenu 
	{
		public static const TYPE_LARGE:uint = 0;
		public static const TYPE_SMALL:uint = 1;
		private var _type:uint;
		public function PopUpStyled(parent:Container, type:uint=1)
		{
			super(parent, PopUpMenu.TYPE_SCROLL_BAR);
			_type = type;
			
			button.backgroundVisible 		= true;
			button.backgroundAlpha			= .9;
			menuBackground.backgroundColor	= 0xffffff;
			menuBackground.backgroundAlpha	= .97;
			menuBackground.cornerRadius		= 9;  
			menuBackground.backgroundShadowStrength	= .4;  
			menuBackground.backgroundShadowSize	= 27;  
			switch (_type)
			{
				case TYPE_LARGE:
					height 							= 28;
					lineHeight 						= 23;
//					button.styleName				= PosteraStyle.POPUP1_LINK;
					button.labelComponent.x			= 3;
					button.labelComponent.y			= 3;
					menu.layout.margin.right		= 8;
					menu.layout.margin.left			= 4;
//					linkStyle 						= PosteraStyle.POPUP1_LINK;
					break;
				case TYPE_SMALL:
					height 							= 18;
					lineHeight 						= 16;
//					button.styleName				= PosteraStyle.POPUP2_LINK;
					button.labelComponent.y	= 1;
					menu.layout.margin.right		= 4;
					menu.layout.margin.left			= 4;
//					linkStyle 						= PosteraStyle.POPUP2_LINK;
					break;
			}
		}
		
		private static var xo:Number=-20;
		private static var yo:Number=13;
		override public function render():void
		{
			_button.width = width;
			_button.height = height;
			var g:Graphics = _button.decorator.midground.graphics;
			g.clear();
			var yo:Number = _type==TYPE_LARGE?9:5;
			ShapeFactory.chevron_down(g,width-15,yo+2,1,8,3,0,1);
			super.render();
		}
		
		public function set options(values:Array):void
		{
			_menu.clear();
			for (var i:uint=0; i<values.length; i++)
			{
				var v:Object = values[i];
				if (v is String)
					addOption(v as String);
				else if (v is Array)
					addOption(v[0],v[1]);
			}
			if (_value!=null)
				value = _value;
		}
		
		
		
		private var _value:Object;
		override public function set value(o:Object):void
		{
			_value = o;
			super.value = o;
		}
		
	}
}