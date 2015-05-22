package com.pagesociety.cms.config
{
	import com.adobe.serialization.json.JSON;
	import com.pagesociety.persistence.Entity;
	import com.pagesociety.persistence.EntityDefinition;
	import com.pagesociety.persistence.EntityDefinitionProvider;
	import com.pagesociety.persistence.FieldDefinition;
	import com.pagesociety.persistence.Types;
	import com.pagesociety.util.StringUtil;
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.web.ResourceUtil;
	import com.pagesociety.web.module.SiteManager;
	
	import flash.utils.getDefinitionByName;

	public class CmsConfig
	{
		private var _raw:Object;
//		private var _defp:EntityDefinitionProvider;
		
		private var _background_color:uint;
		private var _entities:CmsConfigEntities;
		private var _components:Object;
		
		public function CmsConfig(o:Object=null)
		{
			_raw = o == null ? get_config_from_defs() : o ;
			_background_color = parseInt(_raw.backgroundColor, 16);
			_entities = new CmsConfigEntities(_raw.entities, this);
		}
		
		public function set components(o:Object):void
		{
			_components = o;
		}
		
		public function getCmsConfigEntities():CmsConfigEntities
		{
			return _entities;
		}
		
		public function toString():String
		{
			return _entities.toString();
		}
		
		public function getTopLevelEntities():Array/*CmsConfigEntity*/
		{
			return _entities.getTopLevelEntities();
		}
		
		public function getDefinition(entity_type:String):EntityDefinition
		{
			return Entity.getDefinition(entity_type);//_defp.
		}
		
		public function getClass(name:String):Class
		{
			if (_components==null)
				throw new Error("NO COMPONENT DEFINITIONS!");
			var fully_qualified_class_name:String 	= _components[name];
			if (fully_qualified_class_name==null)
				throw new Error("UNKNOWN EDITOR: "+name);
			return getDefinitionByName(fully_qualified_class_name) as Class;
		}
		
		public function getEntityEditor(parent:Container,entity_type:String):Component
		{
			var C:Class = getClass(_entities.getDisplayInfo(entity_type).editor);
			return new C(parent) as Component;
		}
		
		public function getFieldEditor(parent:Container, el:CmsConfigEntityElement):Component
		{
			var C:Class = getClass(el.editor);
			var c:Component = new C(parent) as Component;
			return c;
		}
		
		public function getComponent(parent:Container, el:CmsConfigEntityElement):Component
		{
			var C:Class = getClass(el.component);
			var c:Component = new C(parent) as Component;
			return c;
		}
		
		
		
		//
		
		
		public function removeLanguageFields(to_remove:Array):void
		{
			var i:uint;
			var p:String;
			var n:uint;
			var ee:CmsConfigEntity;
			var elements:Array;
			var ce:Array = _entities.getConfigEntitiesAsArray();
			for(n = 0;n < ce.length;n++)
			{
				ee 		= ce[n];
				for (p in ee.buckets)
				{
					var ff:CmsConfigEntityBucket 	= ee.buckets[p];
					elements = ff.elements;
					
					var num_removed:uint = 0;
					for(i = 0;i < elements.length;i++)
					{
						for(var ii:uint = 0; ii< to_remove.length;ii++)
						{
							var element:CmsConfigEntityElement = CmsConfigEntityElement(elements[i]);
							if(StringUtil.endsWith(elements[i].field.name,'_'+to_remove[ii]))
							{
								elements.splice(i,1);
								i--;
								break;
							}
						}
						
					}
				}
			}
		}
		
		private function get_config_from_defs(defs:Array=null):Object
		{
			var o:Object = 
				{
					backgroundcolor	: "ffffff",
					entities :
					[
						{
							entity : "*",
							editor : "DefaultEditor",
							toplevel : false,
							buckets :
							{
								system :
								[
									{editor:"ReadOnly", field:"creator"},
									{editor:"ReadOnly", field:"last_modified"},
									{editor:"ReadOnly", field:"date_created"}
								]
							}
						}
					]
				};

			if(defs == null)
				 defs = Entity.getDefinitions();

			for (var i:uint=0; i<defs.length; i++)
			{
				var d:EntityDefinition = defs[i];
				o.entities.push(getConfigFromEntityDef(d));
			}
			trace("---------Generated CMS Meta Data---------");
			trace(JSON.encode(o));
			trace("-----------------------------------------");
			return o;
		}
		
		public static function getConfigFromEntityDef(d:EntityDefinition):Object
		{
			var c:Object = {
				entity: d.name,
					name: d.name,
					toplevel: true,
					buckets: 
					{
						left: [],
						right: []
					}
			}
			//
			var has_resource:Boolean = ResourceUtil.hasResourceModuleProvider(d.name);
			if (has_resource)
			{
				c.editor = "ResourceForm";
			}
			else
			{
				A: for (var j:uint=0; j<d.fields.length; j++)
				{
					var f:FieldDefinition = d.fields[j];
					if (f.name == "id" || f.name == "creator" || f.name == "last_modified" || f.name == "date_created")
						continue;
					if (f.name.charAt(0)=="_")
						continue;
					var fr:Object = { field: f.name };
					//					if (SiteManager.MetaInfo.isMultilingualField(d.name, f.name))
					//					{
					//						fr.languages = SiteManager.MetaInfo.additionalLanguages;
					//						j += SiteManager.MetaInfo.additionalLanguages.length;
					//					}
					var is_array:Boolean = f.isArray();
					if (f.baseType == Types.TYPE_REFERENCE)
					{
						has_resource = ResourceUtil.hasResourceModuleProvider(f.referenceType);
						if (has_resource)
						{
							if (is_array)
								fr.editor = "ResourceArrayEditor";
							else
								fr.editor = "ResourceEditor";
						}
						else
						{
							if (is_array)
								fr.editor = "ReferenceArrayEditor";
							else
								fr.editor = "ReferenceEditor";
						}
						c.buckets.right.push(fr);
					}
					else
					{
						if (is_array)
						{
							switch (f.baseType)
							{
								case Types.TYPE_BOOLEAN:
									fr.editor = "BooleanArrayEditor";
									break;
								case Types.TYPE_INT:
									fr.editor = "IntsEditor";
									break;
								case Types.TYPE_LONG:
									fr.editor = "LongArrayEditor";
									break;
								case Types.TYPE_DOUBLE:
									fr.editor = "DoubleArrayEditor";
									break;
								case Types.TYPE_FLOAT:
									fr.editor = "FloatArrayEditor";
									break;
								case Types.TYPE_DATE:
									fr.editor = "DateArrayEditor";
									break;
								case Types.TYPE_STRING:
								case Types.TYPE_TEXT:
									fr.editor = "StringArrayEditor";
									break;
							}
						}
						else
						{
							switch (f.baseType)
							{
								case Types.TYPE_BOOLEAN:
									fr.editor = "BooleanEditor";
									break;
								case Types.TYPE_INT:
									fr.editor = "IntEditor";
									break;
								case Types.TYPE_LONG:
									fr.editor = "LongEditor";
									break;
								case Types.TYPE_DOUBLE:
									fr.editor = "DoubleEditor";
									break;
								case Types.TYPE_FLOAT:
									fr.editor = "FloatEditor";
									break;
								case Types.TYPE_DATE:
									fr.editor = "DateEditor";
									break;
								case Types.TYPE_STRING:
									fr.editor = "StringEditor";
									break;
								case Types.TYPE_TEXT:
									fr.editor = "RichTextEditor";
									break;
							}
						}
						c.buckets.left.push(fr);
					}
				}
			}
			return c;
		}
		
	}
	
	
}
