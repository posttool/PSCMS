package com.pagesociety.cms.browser
{
	import com.pagesociety.cms.CmsEvent;
	import com.pagesociety.cms.Constants;
	import com.pagesociety.cms.component.button.CloseButton;
	import com.pagesociety.cms.config.CmsConfigEntityElement;
	import com.pagesociety.cms.view.EntityComplete;
	import com.pagesociety.cms.view.EntityView0;
	import com.pagesociety.cms.view.EntityView1;
	import com.pagesociety.cms.view.VV;
	import com.pagesociety.persistence.Entity;
	import com.pagesociety.persistence.EntityDefinition;
	import com.pagesociety.persistence.EntityDefinitionProvider;
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.container.Browser;
	import com.pagesociety.ux.component.dim.Guide;
	import com.pagesociety.ux.component.text.Label;
	import com.pagesociety.ux.container.ListEvent;
	import com.pagesociety.ux.event.ComponentEvent;
	import com.pagesociety.ux.event.SelectionEvent;
	import com.pagesociety.ux.layout.GridLayout;
	
	import flash.utils.getDefinitionByName;

	public class EntityBrowserLinkable extends Container
	{
	
		private var _cell_width:Number = 150;
		private var _cell_height:Number = 70;
		
		private var _def_provider:EntityDefinitionProvider;
		
		private var _browser:EntityBrowserOrderedPaged;
		private var _preview:EntityComplete;
		private var _close_button:CloseButton;
				
		public function EntityBrowserLinkable(parent:Container,cms:EntityDefinitionProvider,browser_classname:String=null)
		{
			super(parent);
			
			_def_provider = cms;
			
			_close_button = new CloseButton(this,10);
			_close_button.addEventListener(ComponentEvent.CLICK, function(e:*):void{ application.hideTakeOver(); });
			_close_button.y = 10;
			_close_button.alignX(Guide.RIGHT, -18);
			
			if(browser_classname == null)
				_browser = new EntityBrowserOrderedPaged(this, 150, 100);
			else
			{
				var C:Class = getDefinitionByName(browser_classname) as Class;
				_browser =  new C(this,150,100) as EntityBrowserOrderedPaged;
			}
			
			_browser.addEventListener(CmsEvent.EDIT_ENTITY, edit_entity);
			_browser.x = 10;
			_browser.y = 40;
			_browser.widthDelta = -230;
			_browser.heightDelta = -50;
			_browser.fillDeep = true;
			_browser.addEventListener(ListEvent.SELECTION_CHANGED, on_change_sel);
			
			_browser.cellRenderer = function(p:Container,e:Entity):Component
			{
				var cell:EntityView1 = new EntityView1(p,e);
				return cell;
			}
				
			_preview = new EntityComplete(this);
			_preview.xDelta = -230;
			_preview.width = 200;
			_preview.y = 70;
			_preview.heightDelta = -140;
			
			backgroundVisible = true;
			backgroundColor = Constants.COLOR_LIGHT;
			backgroundShadowColor = 0;
			backgroundShadowStrength = .4;
			backgroundShadowSize = 43;
//			cornerRadius = 40;
		
		}
		
		private function on_change_sel(e:ListEvent):void
		{
			if (e.data!=null && e.data.length!=0)
			{
				_preview.value = _browser.selected[0];
				_preview.render();
			}
			else
				_preview.value = null;

		}
		
		private function edit_entity(e:CmsEvent):void
		{
			dispatchEvent(new SelectionEvent(SelectionEvent.SELECT, this, e.data));
		}

		
		public function setSelectedType(config:CmsConfigEntityElement):void
		{
			_browser.title = "Select "+config.field.referenceType;
			var e:EntityDefinition = _def_provider.provideEntityDefinition(config.field.referenceType);
			_browser.selectEntities(e);
			_preview.value = null;
			render();
		}
		
		public function get selectionValue():Array
		{
			return _browser.selected;
		}
		
		

	}
}