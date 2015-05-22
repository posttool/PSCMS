package com.pagesociety.cms.view
{
	import com.pagesociety.cms.CmsEvent;
	import com.pagesociety.cms.Constants;
	import com.pagesociety.persistence.Entity;
	import com.pagesociety.persistence.FieldDefinition;
	import com.pagesociety.persistence.Types;
	import com.pagesociety.util.StringUtil;
	import com.pagesociety.ux.ISelectable;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.ImageResource;
	import com.pagesociety.ux.component.text.Label;
	import com.pagesociety.ux.decorator.ImageDecorator;
	import com.pagesociety.ux.decorator.MaskedDecorator;
	import com.pagesociety.web.ResourceUtil;
	import com.pagesociety.web.module.Resource;
	import com.pagesociety.web.module.SiteManager;

	[Event(type="com.pagesociety.cms.CmsEvent", name="delete_entity")]
	public class EntityView extends Container implements ISelectable
	{
		protected var _bg:Container;
		protected var _image:ImageResource;
		protected var _label:Label;
		
		protected var _selected:Boolean;
		
		public function EntityView(parent:Container,e:Entity)
		{
			super(parent);

			userObject = e;
			
			decorator = new MaskedDecorator();

			backgroundVisible = true;	
			backgroundColor = 0xFFFFFF;
			backgroundAlpha = 1;
			backgroundShadowSize = 4;
			backgroundShadowStrength = .27;
			
			_bg = new Container(this);
			
			if (e==null)
				return;
			
			_label = new Label(this);
			_label.x = 1;
			_label.y = 1;
			_label.widthDelta = -25;
			_label.text = get_label(e);
			_label.fontStyle = "black_medium";
			_label.backgroundShadowColor = 0xffffff;
			_label.backgroundShadowSize = 1;
			_label.backgroundShadowDistance= 1;
			_label.backgroundShadowStrength = .7;
			
			add_mouse_over_default_behavior();

		}
		
		public function get entity():Entity
		{
			return userObject as Entity;
		}
		
		protected function show_image():void
		{
			if (entity==null)
				return;
			var res:Entity = get_resource();
			if (res==null)
				return;
			add_image(res);
		}
		
		protected function get_resource():Entity
		{
			var fields:Array;
			if (entity.definition!=null)
			{
				for (var i:uint=0; i<entity.definition.fields.length; i++)
				{
					var f:FieldDefinition = entity.definition.fields[i];
					if (f.baseType==Types.TYPE_REFERENCE && ResourceUtil.hasResourceModuleProvider(f.referenceType))
					{
						var o:Object = entity.$[f.name];
						if (o is Array && o.length!=0)
							return (o[0]);
						else if (o is Entity)
							return(o as Entity);
						break;
					}
				}
			}
			
			if (ResourceUtil.hasResourceModuleProvider(entity.type))
			{
				return(entity);
			}
			
			return null;
		}
		
		protected function add_image(e:Entity):void
		{
			var stype:String = e.$[Resource.RESOURCE_FIELD_SIMPLE_TYPE];
			if (stype=="????")
				return;
			_image = new ImageResource(_bg);
			_image.smoothing = true;
			_image.x = 2;
			_image.y = 2;
			_image.widthDelta = -4;
			_image.heightDelta = -4;
			_image.imageScalingType = ImageDecorator.IMAGE_SCALING_VALUE_MASK_FULL_BLEED;
			_image.resource = e;
		}
		
		protected function get_label(e:Entity):String
		{
			
			if (!empty(e.$.name))
				return e.$.name;
			if (!empty(e.$.first_name)||!empty(e.$.last_name))
				return e.$.first_name+" "+e.$.last_name;
			if (!empty(e.$.title))
				return e.$.title;
			if (e.type==Resource.RESOURCE_ENTITY)
				return e.id.stringValue
			for (var i:uint=0; i<e.definition.fieldNames.length; i++)
			{
				var fn:String = e.definition.fieldNames[i];
				if (VV.SYS_FIELDS.indexOf(fn)!=-1)
					continue;
				if (SiteManager.MetaInfo && SiteManager.MetaInfo.isSecondaryMultilingualField(e.definition.name, fn))
					continue;
				var s:String = StringUtil.stripTags(e.$[fn]);
				if (!empty(s))
					return s;
			}
			return "";
		}
		
		private function empty(s:String):Boolean
		{
			return s==null || StringUtil.trim(StringUtil.stripTags(s))=="";
		}
			
	
		public function set selected(b:Boolean):void
		{
			_selected = b;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		override public function render():void
		{
			backgroundColor = _selected ? Constants.COLOR_1 : 0xffffff;
			backgroundAlpha = _over ? 1 : .95;
			super.render();	
		}
		
	
	}
}