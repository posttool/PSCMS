package com.pagesociety.cms.config
{
	import com.pagesociety.persistence.EntityDefinition;

	public class CmsConfigEntities
	{
		public static const DEFAULT_TYPE:String = "*";
		private var _cms_config:CmsConfig;
		private var _default_entity_config:CmsConfigEntity;
		private var _config_entities:Object;
		private var _top_level_entities:Array;
		
		public function CmsConfigEntities(o:Array, cms_config:CmsConfig)
		{
			_cms_config = cms_config;
			_config_entities = new Array();
			_top_level_entities = new Array();

			var i:uint, e:String, def:EntityDefinition;
			for (i=0; i<o.length; i++)
			{
				e = o[i].entity;
				if (e==DEFAULT_TYPE)
				{
					_default_entity_config = new CmsConfigEntity(o[i]);
					break;
				}
			}
			for (i=0; i<o.length; i++)
			{
				e = o[i].entity;
				if (e!=DEFAULT_TYPE)
				{
					def = _cms_config.getDefinition(e);
					if (def==null)
					{
						Logger.error("No such type: "+e);
						continue;
					}
					var c:CmsConfigEntity = new CmsConfigEntity(o[i], def, _default_entity_config) ;
					_config_entities[e] = c;
					if (c.toplevel)
						_top_level_entities.push(c);
				}
			}

		}
		
		public function toString():String
		{
			var s:String = "";
			if (_default_entity_config!=null)
				s+= "DEFAULT\n"+_default_entity_config.toString();
			
			for (var p:String in _config_entities)
			{
				s += p+"\n"+_config_entities[p].toString();
			}
			
			return s;
		}
		
		public function getDisplayInfo(entity_type:String):CmsConfigEntity
		{
			return _config_entities[entity_type];
		}
		
		public function getConfigEntitiesAsArray():Array
		{
			var a:Array = [];
			for(var k:String in _config_entities)
				a.push(_config_entities[k]);

			return a;
		}
		public function getTopLevelEntities():Array/*CmsConfigEntity*/
		{
			return _top_level_entities;
		}
		
	}
}