package com.pagesociety.cms
{
	import com.pagesociety.cms.art.Logo;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.SpriteComponent;
	import com.pagesociety.ux.component.container.NavigationInfo;
	import com.pagesociety.ux.component.container.SingleSelectionContainer;
	import com.pagesociety.ux.component.dim.Guide;
	import com.pagesociety.ux.component.text.Link;
	import com.pagesociety.ux.event.ComponentEvent;
	import com.pagesociety.ux.layout.FlowLayout;
	
	[Event(type="com.pagesociety.ux.event.ComponentEvent", name="change_value")]
	public class Navigation extends Container
	{
		private var _logo:SpriteComponent;
		private var _tabs:SingleSelectionContainer;
		private var _logout:Link;
		
		
		public function Navigation(parent:Container, type:uint)
		{
			super(parent);
			
			_logo = new SpriteComponent(this, new Logo());
			_logo.alignX(Guide.RIGHT,-30);
			_logo.y = 5;
//			_logo.color = Constants.COLOR_1;
			
			_tabs = new SingleSelectionContainer(this);
			_tabs.layout = new FlowLayout(FlowLayout.LEFT_TO_RIGHT);
			_tabs.layout.margin.right = 25;
			_tabs.x = 0;
			_tabs.y = 7;
			_tabs.widthDelta = -200;
			_tabs.addEventListener(ComponentEvent.CHANGE_VALUE, onBubbleEvent);
			
			var l:Array = [];
			if (type==CMS2.SERVICE_TYPE_SITE_MANAGER)
				l.push( ["Site Map","siteMap"] );
			l.push( ["Content Types","browse"] );
			l.push( ["Log Out","logout"] );
			links = l;
		}
		
		public function set links(labels:Array):void
		{
			_tabs.clear();
			for (var i:uint=0; i<labels.length; i++)
			{
				var l:Link = new Link(_tabs);
				l.fontStyle = "small_nav";
				l.text = labels[i][0].toUpperCase();
				l.userObject = labels[i][1];
			}
		}
		
		public function enable(idx:uint, b:Boolean):void
		{
			var l:Link = _tabs.children[idx];
			l.visible = b;
		}
		
		public function update(address:NavigationInfo):void
		{
			for (var i:uint=0; i<_tabs.children.length; i++)
			{
				if (_tabs.children[i].userObject == address.address)
				{
					_tabs.selectionIndex = i;
					return;
				}
			}
			_tabs.selectionIndex = -1;
		}
		
	}
}