package com.pagesociety.cms.form
{
	import com.adobe.utils.DateUtil;
	import com.asual.swfaddress.SWFAddress;
	import com.pagesociety.persistence.Entity;
	import com.pagesociety.util.StringUtil;
	import com.pagesociety.ux.Margin;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.Gap;
	import com.pagesociety.ux.component.form.RadioGroup;
	import com.pagesociety.ux.component.text.Label;
	import com.pagesociety.ux.container.PopUpStyled;
	import com.pagesociety.ux.event.ComponentEvent;
	import com.pagesociety.ux.layout.FlowLayout;
	import com.pagesociety.web.ModuleRequest;
	import com.pagesociety.web.module.SiteManager;
	
	public class SystemInfo extends Container
	{
		
		public static const CHANGE_LANGUAGE:String = "change_language";
		
		private var _create_date:Label;
		private var _mod_date:Label;
		private var _publish:RadioGroup;
		private var _language_label:Label;
		private var _language:RadioGroup;
		private var _permalink:Label;
		
		
		public function SystemInfo(parent:Container)
		{
			super(parent);
			layout = new FlowLayout(FlowLayout.TOP_TO_BOTTOM);
			layout.margin.left = 10;
//			backgroundColor = 0xffffff;
//			backgroundVisible = true;
		}
		
		
		public function set value(e:Entity):void
		{
			top().clear();
			
			new Gap(top(),74);
						
			add_label("CREATED","black_small");
			_create_date = new Label(top());
			_create_date.text = StringUtil.formatDate(e.$.date_created);
			
			new Gap(top(),22);
			
			add_label("LAST MODIFIED","black_small");
			_mod_date = new Label(top());
			_mod_date.text = StringUtil.formatDate(e.$.last_modified);
			
			new Gap(top(),22);
			
			if (e.$._smm_permalink!=null)
			{
				add_label("PERMALINK","black_small");
				var rel_url:String = e.type.toLowerCase()+"/"+e.$._smm_permalink+".html"
				_permalink = new Label(top());
				_permalink.text = "/"+rel_url;
				_permalink.multiline = true;
				_permalink.widthDelta = -40;
				_permalink.addEventListener(ComponentEvent.CLICK, function(e:*):void {
					SWFAddress.href(ModuleRequest.SERVICE_URL+rel_url, "_blank");
				});
				
				new Gap(top(),24);
			}
			
			if (e.definition.fieldNames.indexOf(SiteManager.PUBLISHABLE_ENTITY_PUBLICATION_STATUS_FIELD_NAME)!=-1)
			{			
				add_label("PUBLISHED","black_small");
				_publish = new RadioGroup(top());
				_publish.layout = new FlowLayout(FlowLayout.TOP_TO_BOTTOM,{margin:new Margin(0,0,5,0)});
				_publish.addOption("YES", SiteManager.SITE_MANAGER_STATUS_PUBLISHED);
				_publish.addOption("NO", SiteManager.SITE_MANAGER_STATUS_UNPUBLISHED);
				_publish.addEventListener(ComponentEvent.CHANGE_VALUE, on_change_pub);
				_publish.value = e.$[SiteManager.PUBLISHABLE_ENTITY_PUBLICATION_STATUS_FIELD_NAME];
				new Gap(top(),22);
			}

			
			_language_label = add_label("LANGUAGE","black_small");
			_language = new RadioGroup(top());
			_language.layout = new FlowLayout(FlowLayout.TOP_TO_BOTTOM,{margin:new Margin(0,0,5,0)});
			_language.addEventListener(ComponentEvent.CHANGE_VALUE, on_change_lang);
			
		}
		
		public function get publishedValue():uint
		{
			return _publish.value as uint;
		}
		
		public function get hasPublishedValue():Boolean
		{
			return _publish != null;
		}
		
		public function set languages(a:Array):void
		{
			if(a.length == 0)
			{
				_language.visible 		= false;
				_language_label.visible = false;
			}
			else
			{
				_language.clear();
				_language.addOption("all",0);
				_language.addOption("primary",1);
				for (var i:uint=0; i<a.length; i++)
				{
					_language.addOption(a[i]);
				}
				_language.value = 1;
			}
		}
		
		public function get languageValue():Object
		{
			return _language.value;
		}
		
		private function on_change_pub(e:*):void
		{
			dispatchComponentEvent(ComponentEvent.CHANGE_VALUE);
		}
		
		private function on_change_lang(e:*):void
		{
			dispatchComponentEvent(CHANGE_LANGUAGE);
		}
	}
}