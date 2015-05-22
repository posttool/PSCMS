package com.pagesociety.cms.config
{
	import com.pagesociety.persistence.EntityDefinition;
	import com.pagesociety.persistence.FieldDefinition;

	public class CmsConfigEntityElement
	{
		private var _el_name:String;
		private var _component_name:String;
		private var _name:String;
		private var _props:Object;
		private var _fields:Array;
		
		public function CmsConfigEntityElement(el:Object, def:EntityDefinition)
		{
			if (el is FieldDefinition)
			{
				_name = el.name;
				_fields = [ el ];
				return;
			}
			//otherwise, process raw object
			
			_el_name = el.editor;
			_component_name = el.component;
			_props = el.props == null ? {} : el.props;
			_name = el.name;
			
			if (el.fields)
				_fields = el.fields;
			else if (el.field)
				_fields = [ el.field ];
			
			if (def!=null && _fields!=null)
			{
				for (var i:uint=0; i<_fields.length; i++)
				{
					var fd:FieldDefinition = def.getField(_fields[i]);
					if (fd==null)
 						throw new Error("NO SUCH FIELD "+def.name+" "+_fields[i]+" ["+def.fieldNames+"]");
					_fields[i] = fd;
				}
			}
		}
		
		public function get fields():Array/*FieldDefs*/
		{
			return _fields==null?[]:_fields;
		}
		
		public function get field():FieldDefinition
		{
			if (_fields==null || _fields.length==0)
				return null;
			return _fields[0];
		}
		
		public function get isForSingleField():Boolean
		{
			return _fields!=null && _fields.length==1;
		}
		
		public function get hasReferenceFields():Boolean
		{
			for (var i:uint=0; i<_fields.length; i++)
				if (_fields[i].isReference)
					return true;
			return false;
		}
		
		public function get isEditor():Boolean
		{
			return _el_name!=null;
		}
		
		public function get editor():String
		{
			return _el_name;
		}
		
		public function get component():String
		{
			return _component_name;
		}
		
		public function get props():Object
		{
			return _props;
		}
		
		public function get name():String
		{
			if (_name!=null)
				return _name;
			if (field!=null)
				return field.name;
			return _el_name;
		}
		
		public function toString():String
		{
			return _el_name+"->"+_fields;
		}
	}
}