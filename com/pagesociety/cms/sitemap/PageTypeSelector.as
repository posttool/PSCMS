package com.pagesociety.cms.sitemap
{
	import com.pagesociety.persistence.Entity;
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.container.SingleSelectionContainer;
	import com.pagesociety.ux.component.text.Label;
	import com.pagesociety.ux.component.text.Link;
	import com.pagesociety.ux.event.ComponentEvent;
	import com.pagesociety.ux.layout.FlowLayout;
	import com.pagesociety.ux.layout.GridLayout;
	import com.pagesociety.web.module.SiteManager;
	
	[Event(type="com.pagesociety.ux.event.ComponentEvent", name="change_value")]
	public class PageTypeSelector extends Container
	{
		
		private var _sel_type:String;
		private var _page_types:Array;
		private var _list:SingleSelectionContainer;
		
		public function PageTypeSelector(parent:Container)
		{
			super(parent);
			_list = new SingleSelectionContainer(this);
			_list.layout = new FlowLayout(FlowLayout.TOP_TO_BOTTOM);
			_list.x = 10;
			_list.y = 10;
			_list.widthDelta = -20;
			_list.heightDelta = -20;
			_list.addEventListener(ComponentEvent.CHANGE_VALUE, on_select);
			backgroundVisible = true;
			backgroundColor = 0xffffff;
			cornerRadius = 15;
			width = 400;
			height = 500;
		}
		
		public function set pageTypes(types:Array):void
		{
			_page_types = types;
			update_ui();
		}
		
		public function get selectedType():String
		{
			return _sel_type;
		}
		
		public function on_select(e:ComponentEvent):void
		{
			_sel_type = _list.selected.userObject.name;//SiteManager.MetaInfo.pageTypeEntities[_list.selected.userObject];
			dispatchComponentEvent(ComponentEvent.CHANGE_VALUE, this, _sel_type);
		}
		
		private function update_ui():void
		{
			_list.clear();
			for (var i:uint=0; i<_page_types.length; i++)
			{
				var l:Link = new Link(_list);
				l.userObject = _page_types[i];
				l.text = _page_types[i].name;
				l.fontStyle = "black_big";
			}
		}
		
	}
}