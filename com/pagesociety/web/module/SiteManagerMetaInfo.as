package com.pagesociety.web.module
{
	import com.pagesociety.persistence.Entity;
	import com.pagesociety.util.StringUtil;
	
	import flash.utils.getDefinitionByName;

	public class SiteManagerMetaInfo
	{
		public var entityDefinitions:Array;
		public var entityIndices:Object;
		public var additionalLanguages:Array;
		public var multilingualEntities:Array;
		public var multilingualEntityFieldMap:Object;
		public var publishableEntities:Array/*String*/;
		public var pageTypeEntities:Array/*String*/;
		
		public function SiteManagerMetaInfo(info:Object)
		{
			entityDefinitions 			= info[SiteManager.KEY_SITEMANAGER_METAINFO_ENTITY_DEFINITIONS];
			entityIndices 				= info[SiteManager.KEY_SITEMANAGER_METAINFO_ENTITY_INDICES];

			Entity.setDefinitions(entityDefinitions);
			Entity.setIndices(entityIndices);
			
			additionalLanguages 		= info[SiteManager.KEY_SITEMANAGER_METAINFO_ADDITIONAL_LANGUAGES];
			multilingualEntities 		= info[SiteManager.KEY_SITEMANAGER_METAINFO_MULTILINGUAL_ENTITIES];
			multilingualEntityFieldMap 	= info[SiteManager.KEY_SITEMANAGER_METAINFO_MULTILINGUAL_ENTITY_FIELD_MAP];
			
			var pes:Array 				= [];
			for (var i:uint=0; i<info[SiteManager.KEY_SITEMANAGER_METAINFO_PUBLISHABLE_ENTITIES].length; i++)
				pes.push(Entity.getDefinition(info[SiteManager.KEY_SITEMANAGER_METAINFO_PUBLISHABLE_ENTITIES][i]));
			publishableEntities 		= pes;
			
			var ptes:Array 				= [];
			for (i=0; i<info[SiteManager.KEY_SITEMANAGER_METAINFO_PAGE_TYPE_ENTITIES].length; i++)
				ptes.push(Entity.getDefinition(info[SiteManager.KEY_SITEMANAGER_METAINFO_PAGE_TYPE_ENTITIES][i]));
			pageTypeEntities 			= ptes;
		}
		
		public function isMultilingualField(entity_name:String, field_name:String):Boolean
		{
			for (var i:uint=0; i<additionalLanguages.length; i++)
			{
				var sfx:String = "_"+additionalLanguages[i];
				if (StringUtil.endsWith(field_name,sfx))
				{
					field_name = field_name.substr(0,field_name.length-sfx.length);
					break;
				}
			}
			var fields:Array = multilingualEntityFieldMap[entity_name];
			if (fields==null)
				return false;
			return fields.indexOf(field_name)!=-1;
		}
		
		public function isPrimaryMultilingualField(entity_name:String, field_name:String):Boolean
		{
			var fields:Array = multilingualEntityFieldMap[entity_name];
			if (fields==null)
				return false;
			return fields.indexOf(field_name)!=-1;
		}
		
		public function isSecondaryMultilingualField(entity_name:String, field_name:String):Boolean
		{
			for (var i:uint=0; i<additionalLanguages.length; i++)
			{
				var sfx:String = "_"+additionalLanguages[i];
				if (StringUtil.endsWith(field_name,sfx))
				{
					return true;
				}
			}
			return false;
		}
	}
}