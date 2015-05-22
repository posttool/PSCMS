package com.pagesociety.cms.component
{
	import com.pagesociety.ux.IEditor;
	import com.pagesociety.ux.component.Container;
	
	
	public class MultiEditor extends Container implements IEditor
	{
		public function MultiEditor(parent:Container, index:int=-1)
		{
			super(parent, index);
		}
		
		public function get bindings():Array
		{
			throw new Error("MultiEditor get bindings is abstract... Overload in "+this);
		}
		
		public function get value():Object
		{
			var a:Array = new Array();
			var b:Array = bindings;
			for (var i:uint=0; i<b.length; i++)
				a.push(b[i].value);
			return a;
		}
		
		public function set value(o:Object):void
		{
			var b:Array = bindings;
			for (var i:uint=0; i<b.length; i++)
				b[i].value = o[i];
		}
		
		public function get dirty():Boolean
		{
			var b:Array = bindings;
			for (var i:uint=0; i<b.length; i++)
				if (b[i].dirty)
					return true;
			return false;
		}
		
		public function set dirty(d:Boolean):void
		{
			var b:Array = bindings;
			for (var i:uint=0; i<b.length; i++)
				b[i].dirty = d;

		}
	}
}