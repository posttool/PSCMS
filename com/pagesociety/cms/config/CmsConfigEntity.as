package com.pagesociety.cms.config
{
	import com.pagesociety.persistence.EntityDefinition;
	import com.pagesociety.persistence.FieldDefinition;

	public class CmsConfigEntity
	{
		private var _entity_def:EntityDefinition;
		private var _entity_type:String;
		private var _entity_name:String;
		private var _entity_description:String;
		private var _editor_type:String;
		private var _toplevel:Boolean;
		private var _buckets:Object;
		private var _fields:Array;
		
		public function CmsConfigEntity(o:Object, entity_def:EntityDefinition=null, defaults:CmsConfigEntity=null)
		{
			_entity_def = entity_def;
			
			if (defaults!=null)
			{
				_entity_type 	= defaults.entityType;
				_editor_type 	= defaults.editor;
				_toplevel 		= defaults.toplevel;			
			}
			
			_entity_type 		= o.entity;
			_entity_name 		= o.name;
			_entity_description = o.description;
			if (o.editor!=null)
				_editor_type 		= o.editor;
			if (o.toplevel!=null)
				_toplevel 			= o.toplevel;
			
			_buckets = new Object();
			_fields = new Array();
			var p:String;
			var bd:CmsConfigEntityBucket;
			if (defaults!=null)
			{
				for (p in defaults.buckets)
				{
					bd  = defaults.buckets[p];
					//_buckets[p] = new CmsConfigEntityBucket(p, bd.json, entity_def);//defaults.buckets[p];
				}
			}
			for (p in o.buckets)
			{
				bd = new CmsConfigEntityBucket(p, o.buckets[p], entity_def);
				_buckets[p] = bd;
				_fields.push(bd.fields);
			}
		}
		
		public function get entityDefinition():EntityDefinition
		{
			return _entity_def;
		}
		
		public function get entityType():String
		{
			return _entity_type;
		}
		
		public function get name():String
		{
			return _entity_name ? _entity_name : _entity_type;
		}
		
		public function set name(s:String):void
		{
			 _entity_name = s;
		}
		
		public function get description():String
		{
			return _entity_description;
		}
		
		public function get editor():String
		{
			return _editor_type;
		}
		
		public function get toplevel():Boolean
		{
			return _toplevel;
		}
		
		public function get buckets():Object
		{
			return _buckets;
		}
		
		public function get fields():Array
		{
			return _fields;
		}
		
		public function getBucket(name:String):CmsConfigEntityBucket
		{
			return _buckets[name];
		}
		
		public function isMasked(f:FieldDefinition):Boolean
		{
			return _fields.indexOf(f)==-1;
		}
		
		public function toString():String
		{
			var s:String = "";
			for (var p:String in _buckets)
				s += "   "+_buckets[p].toString()+"\n";
			return s;
		}
		
		// for modifying config...
		
		public function removeFields(names:Array):void
		{
			for (var i:uint=0; i<names.length; i++)
				removeField(names[i]);
		}
		
		public function removeField(name:String):void
		{
			var p:String;
			var elements:Array;
			var i:uint;
			for (p in _buckets)
			{
				elements = _buckets[p].elements;
				for(i= 0;i < elements.length;i++)
				{
					if(elements[i].field.name == name)
					{
						elements.splice(i,1);
						return;
					}
				}
			}
		}
		
		public function getField(name:String):CmsConfigEntityElement
		{
			var p:String;
			var elements:Array;
			var i:uint;
			for (p in _buckets)
			{
				elements = _buckets[p].elements;
				for(i= 0;i < elements.length;i++)
				{
					if(elements[i].field.name == name)
					{
						return elements[i];
					}
				}
			}
			return null;
		}
	}
}