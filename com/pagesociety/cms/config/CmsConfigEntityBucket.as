package com.pagesociety.cms.config
{
	import com.pagesociety.persistence.EntityDefinition;

	public class CmsConfigEntityBucket
	{
		private var _name:String;
		private var _elements:Array;
		private var _fields:Array;

		public function CmsConfigEntityBucket(name:String, elements:Array, def:EntityDefinition)
		{
			_name = name;
			_elements = new Array();
			_fields = new Array();
			for (var i:uint=0; i<elements.length; i++)
			{
				if (elements[i] is Array)
				{
					add_config({component:"${"},def);
					for (var j:uint=0; j<elements[i].length; j++)
						add_config(elements[i][j], def);
					add_config({component:"$}"},def);
				}
				else
				{
					add_config(elements[i], def);
				}
			}
		}
		
		private function add_config(o:Object, def:EntityDefinition):void
		{
			var el:CmsConfigEntityElement = new CmsConfigEntityElement(o, def);
			for (var j:uint=0; j<el.fields.length; j++)
				_fields.push(el.fields[j]);
			_elements.push(el);
		}
		
		public function get fields():Array/*FieldDefs*/
		{
			return _fields;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get elements():Array
		{
			return _elements;
		}
		
		public function toString():String
		{
			return _name + " {"+_elements+"}";
		}
		
		
	}
}