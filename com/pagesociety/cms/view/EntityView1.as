package com.pagesociety.cms.view
{
	import com.pagesociety.cms.CmsEvent;
	import com.pagesociety.cms.Constants;
	import com.pagesociety.ux.container.SelectableContainer;
	import com.pagesociety.persistence.Entity;
	import com.pagesociety.persistence.FieldDefinition;
	import com.pagesociety.persistence.Types;
	import com.pagesociety.ux.ISelectable;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.ImageResource;
	import com.pagesociety.ux.component.button.DeleteButton;
	import com.pagesociety.ux.component.button.ForwardButton;
	import com.pagesociety.ux.component.text.Label;
	import com.pagesociety.ux.decorator.ImageDecorator;
	import com.pagesociety.ux.decorator.MaskedDecorator;
	import com.pagesociety.ux.event.ComponentEvent;
	import com.pagesociety.ux.layout.FlowLayout;
	import com.pagesociety.web.ResourceUtil;
	import com.pagesociety.web.module.Resource;
	
	import flash.events.Event;

	[Event(type="com.pagesociety.cms.CmsEvent", name="delete_entity")]
	public class EntityView1 extends EntityView implements ISelectable
	{
	
		
		public function EntityView1(parent:Container, e:Entity)
		{
			super(parent,e);
			_label.multiline = true;
			show_image();
		}
	
		
	
	}
}