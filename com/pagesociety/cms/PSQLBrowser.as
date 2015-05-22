package com.pagesociety.cms
{
	import com.pagesociety.cms.view.EntityView0;
	import com.pagesociety.cms.view.VV;
	import com.pagesociety.persistence.Entity;
	import com.pagesociety.persistence.EntityDefinition;
	import com.pagesociety.persistence.EntityDefinitionProvider;
	import com.pagesociety.ux.Margin;
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.container.Browser;
	import com.pagesociety.ux.component.text.Input;
	import com.pagesociety.ux.component.text.Label;
	import com.pagesociety.ux.component.text.Pager;
	import com.pagesociety.ux.event.ComponentEvent;
	import com.pagesociety.web.ErrorMessage;
	import com.pagesociety.web.ModuleRequest;

	public class PSQLBrowser extends Container
	{
		private var _def_provider:EntityDefinitionProvider;
		private var _def:EntityDefinition;
		private var _results:Array;
		
		private var _console:Input;
		private var _error:Label;
		private var _pager:Pager;
		private var _browser:Browser;
		
		private var _masked_defs:Array = [ "Resource" ];
		private var _masked_fields:Array = [ "date_created", "reverse_date_created", "last_modified", "reverse_last_modified", "creator" ];
		private var _cell_width:Number = 190;
		private var _cell_height:Number = 70;
		
		public function PSQLBrowser(parent:Container, def_provider:EntityDefinitionProvider)
		{
			super(parent);
			
			_def_provider = def_provider;
			var defs:Array = def_provider.provideEntityDefinitions();
			
			_console = new Input(this);
			_console.height = 100;
			_console.value = "SELECT * FROM "+defs[Math.floor(Math.random()*defs.length)].name+";";// WHERE (Weight < 2.0 OR Weight > 5) AND FirstName STARTSWITH 'Ez';"
			_console.addEventListener(ComponentEvent.CHANGE_VALUE, select_entities);
			
			_error = new Label(this);
			_error.widthPercent = 100;
			_error.height = 40;
			_error.y = 100;
			_error.multiline = true;
			//
			_pager = new Pager(this);
			_pager.y = 140;
			_pager.pageSize = 20;
			_pager.addEventListener(ComponentEvent.CHANGE_VALUE, select_entities);
			_pager.visible = false;
			
			_browser = new Browser(this);
			_browser.y = 160;
			_browser.heightDelta = -166;
			_browser.decorator.background.visible = false;
			_browser.cellRenderer = view_entity_in_browser;
//			_browser.onSelect = function(c:ComponentEvent):void 
//			{ 
//				var e:Entity = Entity(c.component.userObject); 
//				dispatchEvent(new CmsEvent(CmsEvent.EDIT_ENTITY, e));
//			};
		}
		
		
		private function select_entities(e:ComponentEvent):void
		{
			if (e.component.userObject!=null)
				_def = e.component.userObject;
			_error.text = "";
			_error.render();
			_browser.clear();
			_browser.render();
			var a:ModuleRequest = new ModuleRequest(""/*Cms.CMS_PSSQL*/, [_console.value, _pager.offset, _pager.pageSize]);
			a.addResultHandler(on_results);
			a.addErrorHandler(on_error);
			a.execute();
		}
		
		private function on_results(o:Object):void
		{
			_results = o.entities;
//			ObjectUtil.fillResourceUrls(_def_provider, _results, on_results_with_resources);
		} 
		
		private function on_results_with_resources(filled_results:Array):void
		{
			_results = filled_results;
			_browser.value = _results;
			_browser.render();
			_pager.totalCount = 100; // o.totalCount
			_pager.render();
			dispatchEvent(new ComponentEvent(ComponentEvent.CHANGE_VALUE, this));
		}
		
		private function on_error(e:ErrorMessage):void
		{
			_error.text = e.message;
			_error.render();
		}
		
		// VIEW FOR BROWSER
		private function view_entity_in_browser(p:Container, e:Entity):Component
		{
			return new EntityView0(p, e);
		}

		
	}
}