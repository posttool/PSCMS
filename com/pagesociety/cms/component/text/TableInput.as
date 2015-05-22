package com.pagesociety.cms.component.text
{
	import com.pagesociety.util.StringUtil;
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.container.Browser;
	import com.pagesociety.ux.component.text.Input;
	import com.pagesociety.ux.component.text.Label;
	import com.pagesociety.ux.event.BrowserEvent;
	import com.pagesociety.ux.event.ComponentEvent;
	import com.pagesociety.ux.layout.FlowLayout;
	import com.pagesociety.ux.layout.TableLayout;

	[Event(type="com.pagesociety.ux.event.ComponentEvent", name="change_value")]
	public class TableInput extends Container
	{
		private var _labels:Container;
		private var _sections:Browser;
		private var _is:String;
		private var _columns:uint;
		private var _widths:Array;
		
		public function TableInput(parent:Container)
		{
			super(parent);
			_labels = new Container(this);
			_labels.layout = new FlowLayout(FlowLayout.LEFT_TO_RIGHT);
			_labels.x = 10;//PosteraSection.LPAD;
			_labels.y = 4;
			
			_sections = new Browser(this);
			_sections.layoutType = Browser.LAYOUT_FLOW_VERTICAL;
//			_sections.layout.margin.bottom = 12;
//			_sectons.decorator = _sbdec = new PosteraScrollBarDecorator();
			_sections.cellRenderer = row_renderer;
			_sections.addDropTargetForChildren(_sections);
			_sections.reorderable = true;
			_sections.deletable = true;	
			_sections.y = 18;
			_sections.addEventListener(BrowserEvent.REORDER, translateEvent(ComponentEvent.CHANGE_VALUE));
		}
		
		public function set columns(a:Array):void
		{
			_columns = a.length;
			_widths = [];
			_labels.clear();
			for (var i:uint=0; i<a.length; i++)
			{
				var l:Label = new Label(_labels);
				l.text = a[i].label;
				if (a[i].width!=null) 
				{
					l.width = a[i].width;
					_widths[i] = a[i].width;
				}
			}
		}
		
		public function set headingVisible(b:Boolean):void
		{
			_labels.visible = b;
			_sections.y = b ? 18 : 0;
			
		}
		 
		public function get value():Object
		{
			var a:Array = new Array();
			for (var i:uint=0; i<_sections.children.length; i++)
			{
				var b:Array = _sections.children[i].value;
				for (var j:uint=0; j<b.length; j++)
					a.push(b[j]);
			}
			return a;
		}
		
		public function set value(o:Object):void
		{
			var two_dim:Array = [];
			if (o!=null)
				for (var i:uint=0; i<o.length; i+=_columns)
					two_dim.push(o.slice(i,i+_columns));
			_sections.value = two_dim;
		}
		
		public function addValue(o:Object):void
		{
			_sections.addValue(o);
			render();
		}
		
		private function row_renderer(s:Container,o:Object):TableRow
		{
			var tr:TableRow = new TableRow(s);
			tr.inputStyle = _is;
			tr.widths = _widths;
			tr.value = o;
			tr.addEventListener(ComponentEvent.CHANGE_VALUE, onBubbleEvent);
			tr.addEventListener(TableRow.DELETE_ROW, on_delete_row);
			return tr;
		}
		
		private function on_delete_row(c:ComponentEvent):void
		{
			dirty =true;
			_sections.removeComponent(c.component);
			dispatchComponentEvent(ComponentEvent.CHANGE_SIZE, this);
			dispatchComponentEvent(ComponentEvent.CHANGE_VALUE, this);
		}
		
		override public function get height():Number
		{
			return _sections.layout.calculateHeight()+_sections.y;
		}
		
		public function set inputStyle(s:String):void
		{
			_is = s;
		}
		
		public function get inputStyle():String
		{
			return _is;
		}
		
		public function get dirty():Boolean
		{
			//for sections
			return _sections.dirty;
		}
		
		public function set dirty(b:Boolean):void
		{
			 _sections.dirty = b;
		}
	}
}