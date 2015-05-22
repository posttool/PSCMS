package com.pagesociety.cms.component.reference
{
	import com.pagesociety.cms.CmsEvent;
	import com.pagesociety.cms.view.EntityView0;
	import com.pagesociety.cms.view.VV;
	import com.pagesociety.persistence.Entity;
	import com.pagesociety.ux.IEditor;
	import com.pagesociety.ux.ISelectable;
	import com.pagesociety.ux.Margin;
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.container.Browser;
	import com.pagesociety.ux.component.text.Label;
	import com.pagesociety.ux.component.text.Link;
	import com.pagesociety.ux.event.BrowserEvent;
	import com.pagesociety.ux.event.ComponentEvent;
	import com.pagesociety.ux.layout.GridLayout;

	[Event(type="com.pagesociety.ux.component.form.ReferenceEditor", name="create_reference")]
	[Event(type="com.pagesociety.ux.component.form.ReferenceEditor", name="link_reference")]
	[Event(type="com.pagesociety.ux.event.BrowserEvent", name="dragging")]
	[Event(type="com.pagesociety.ux.event.BrowserEvent", name="double_click")]
	[Event(type="com.pagesociety.ux.event.BrowserEvent", name="add")]
	[Event(type="com.pagesociety.ux.event.BrowserEvent", name="remove")]
	
	public class ReferenceEditor extends Container implements IEditor
	{
		public static var CREATE_REFERENCE:String = "create_reference";
		public static var LINK_REFERENCE:String = "link_reference";
				
		protected var _browser:Browser;
		protected var _grid_layout:GridLayout;
		protected var _add:Component;
		protected var _link:Component;
		
		public function ReferenceEditor(parent:Container)
		{
			super(parent);
			
			_browser = new Browser(this);
					
			_browser.addDropTargetForChildren(_browser);
			_browser.reorderable = true;
			_browser.deletable = true;
//			_browser.addEventListener(BrowserEvent.SINGLE_CLICK, select_component_event);
			_browser.addEventListener(ComponentEvent.CHANGE_VALUE, on_change_value);
			_browser.addEventListener(BrowserEvent.DOUBLE_CLICK, onBubbleEvent);
			_browser.addEventListener(BrowserEvent.DRAGGING, onBubbleEvent);
			_browser.addEventListener(BrowserEvent.ADD, onBubbleEvent);
			_browser.addEventListener(BrowserEvent.REMOVE, onBubbleEvent);
			_browser.addEventListener(ComponentEvent.CHANGE_VALUE, onBubbleEvent);
			_browser.cellRenderer = entity_cell_renderer;
			_grid_layout = _browser.layout as GridLayout;
			variableHeight = true;
			
			_add = get_add_button();
			if (_add != null)
				_add.addEventListener(ComponentEvent.CLICK, on_click_add);
		
			_link = get_link_button();
			if (_link != null)
				_link.addEventListener(ComponentEvent.CLICK, on_click_link);
		}
		
		private function entity_cell_renderer(p:Container, e:Entity):EntityView0
		{
			var ee:EntityView0 = new EntityView0(p, e);
			ee.addEventListener(CmsEvent.DELETE_ENTITY, onBubbleEvent);
			return ee;
		}
		
		public function get browser():Browser
		{
			return _browser;
		}
		
		protected function get_add_button():Component
		{
			var add:Link = new Link(this);
			add.fontStyle = "black_small";
			add.text = "+ CREATE";
			add.align = Label.ALIGN_RIGHT;
			add.x = -70;
			add.y = -15;
			return add;
		}
		
		protected function get_link_button():Component
		{
			var link:Link = new Link(this);
			link.fontStyle = "black_small";
			link.text = "> BROWSE";
			link.align = Label.ALIGN_RIGHT;
			link.x = -5;
			link.y = -15;
			return link
		}
		
		protected function on_click_add(e:ComponentEvent):void
		{
			dispatchComponentEvent(ReferenceEditor.CREATE_REFERENCE, this);
		}
		
		protected function on_click_link(e:ComponentEvent):void
		{
			dispatchComponentEvent(ReferenceEditor.LINK_REFERENCE, this);
		}
		
		public function set cellWidth(n:Number):void
		{
			_grid_layout.cellWidth = n;
		}
		
		public function get cellWidth():Number
		{
			return _grid_layout.cellWidth;
		}
		
		public function set cellHeight(n:Number):void
		{
			_grid_layout.cellHeight = n;
		}
		
		public function get cellHeight():Number
		{
			return _grid_layout.cellHeight;
		}
		
		public function get selectionIndex():int
		{
			return _browser.selectionIndex;
		}
		
		public function set selectionIndex(i:int):void
		{
			_browser.selectionIndex = i;
		}
		
		public function get dirty():Boolean
		{
			return _browser.dirty;
		}
		
		public function set dirty(b:Boolean):void
		{
			_browser.dirty = b;
		}
		
		public function set value(o:Object):void
		{
			if (o==null)
				_browser.value = [];
			else
				_browser.value = [ o ]; 
			render();
		}
		
		public function get value():Object
		{
			var v:Array = _browser.value as Array;
			if (v==null || v.length==0)
				return null;
			else
				return v[0];
		}
		
		public function set cellRenderer(f:Function):void
		{
			_browser.cellRenderer = f;
		}
		
		///////////////////////////////////////
		private var _var_height:Boolean;
		public function set variableHeight(b:Boolean):void
		{
			_var_height = b;
			if (_var_height && isHeightUnset)
				height = 0;
			else if (!_var_height && height==0)
				heightUnset();
		}
		
		public function get variableHeight():Boolean
		{
			return _var_height;
		}
		
		override public function get height():Number
		{
			if (_var_height)
				return _browser.layout.calculateHeight()+20;
			else
				return super.height;
		}
		
		private function on_change_value(e:*):void
		{
			dispatchComponentEvent(ComponentEvent.CHANGE_SIZE,this);
		}
		
	}
}