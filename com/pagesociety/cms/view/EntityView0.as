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
	public class EntityView0 extends EntityView implements ISelectable
	{
		
		private var _ui:Container;
		private var _delete:DeleteButton;
		
		
		public function EntityView0(parent:Container, e:Entity)
		{
			super(parent, e);
			
			show_image();
			_label.multiline = true;
			
			_ui = new Container(this);
			_ui.layout = new FlowLayout(FlowLayout.RIGHT_TO_LEFT);
			_ui.visible = false;
			_ui.y = 0;
			_ui.height = 20;
			_ui.widthDelta = -3;

			_delete = new DeleteButton(_ui);
			_delete.addEventListener(ComponentEvent.CLICK, on_click_delete);

		}
		
			
		override public function render():void
		{
			if(_ui!=null)
				_ui.visible = _over;
			super.render();	
		}
		
		protected function on_click_delete(e:ComponentEvent):void
		{
			dispatchEvent(new CmsEvent(CmsEvent.DELETE_ENTITY, this, userObject));
		}
		
	
	}
}