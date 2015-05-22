package com.pagesociety.ux.container
{
	import com.pagesociety.cms.Constants;
	import com.pagesociety.ux.IEditor;
	import com.pagesociety.ux.ISelectable;
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.text.Label;
	import com.pagesociety.ux.decorator.ShapeFactory;
	import com.pagesociety.ux.event.ComponentEvent;
	import com.pagesociety.ux.layout.FlowLayout;
	import com.pagesociety.ux.layout.GridLayout;
	import com.pagesociety.ux.layout.Layout;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class List extends Container implements IEditor
	{
		protected var _bg:Component;
		protected var _mid:Container;
		protected var _pagers:Container;
		protected var _controls:Container;
		protected var _fg:Container;
		private var _insert_art:Container;
		
		private var _drag_art:Container;
		private var _keyline:Component;
		
		private var _cell_renderer:Function;
		private var _value:Array = [];
		private var _result:Object;
		private var _use_result:Boolean;
		private var _dirty:Boolean;

		private var _page:uint;
		private var _items_per_page:uint;
		
		protected var _selected_indices:Array;		
		
		private var _dragging:Component;
		private var _drag_rect:Rectangle;
		private var _mod_key_down:Boolean;

		public function List(parent:Container, index:int=-1)
		{
			super(parent, index);
			application.stage.addEventListener(KeyboardEvent.KEY_DOWN,on_key_down);
			application.stage.addEventListener(KeyboardEvent.KEY_UP,on_key_up);
			_bg = new Component(this);
			_bg.backgroundVisible = true;
			_bg.backgroundAlpha = 0;
			_bg.addEventListener(ComponentEvent.DRAG_START, on_start_band);
			_bg.addEventListener(ComponentEvent.DRAG, on_drag_band);
			_bg.addEventListener(ComponentEvent.DRAG_STOP, on_stop_band);
			_mid = new Container(this);
			_pagers = new Container(this);
			_controls = new Container(this);
			_fg = new Container(this);
			_insert_art = new Container(_fg);
			_insert_art.visible = false;
			ShapeFactory.arrowDown(_insert_art.decorator.graphics, 0,-5, 12, Constants.COLOR_1, 1, 3);
			_drag_art = new Container(_fg);
			_keyline = new Component(_fg);
			
			_page = 0;
			_items_per_page = 1;
			_selected_indices = [];
		}
		
		////////////////////////
		//// cell rendered, value, ui
		public function set cellRenderer(f:Function):void
		{
			_cell_renderer = f;
		}
		
		public function set value(v:Object):void
		{
			if(v == null)
				v = [];
			_dirty = false;
			_use_result = false;
			_value = [];
			for (var i:uint=0; i<v.length; i++)
			{
				if (v[i]!=null)
					_value.push(v[i]);
			}
			_items_per_page = calc_items_per_page();
			update_ui();
		}
		
		public function get value():Object
		{
			return _value;
		}
		
//		public function addValue(v:Object):Component
//		{
//			_dirty = true;
//			_value.push(v);
//			dispatchComponentEvent(ComponentEvent.CHANGE_VALUE, this, _value);
//			return create_cell(v);
//		}
		
		public function removeSelected():void
		{
			for (var i:uint=0; i<_selected_indices.length; i++)
			{
				var ci:int = _selected_indices[i]-i;
				_value.splice(ci,1);
			}
			_selected_indices = [];
			update_ui();
		}
		
		public function removeValue(v:Object):Boolean
		{
			var idx:int = _value.indexOf(v);
			if (idx==-1)
				return false;
			_value.splice(idx,1);
			update_ui();
			return true;
		}
		
		public function set results(result:Object):void
		{
			_dirty = false;
			_use_result = true;
			_result = result;
			_value = result.entities;
			_items_per_page = calc_items_per_page();
			update_ui();
		}
		
		public function get dirty():Boolean
		{
			return _dirty;
		}
		
		public function set dirty(b:Boolean):void
		{
			_dirty = b;
		}		

		public function set page(p:uint):void
		{
			if (p==_page)
				return;
			_page = p;
			_items_per_page = calc_items_per_page();
			update_ui();
		}
		
		public function get page():uint
		{
			return _page;
		}
		
		
		public function get offset():uint
		{
			return _page*_items_per_page;
		}
		
		public function get totalPages():uint
		{
			return Math.ceil(totalCount/_items_per_page);
		}
		
		public function get totalCount():uint
		{
			if (_use_result)
				return _result.totalCount;
			else if (_value==null)
				return 0;
			else
				return _value.length;
		}
		
		public function get selected():Array
		{
			var s:Array = [];
			var i:uint;
			var ci:uint;
			if (_use_result)
			{
				for (i=0; i<_selected_indices.length; i++)
				{
					ci = _selected_indices[i]-_page*_items_per_page;
					if (ci>-1 && ci<_value.length)
						s.push(_value[ci]);
				}
			}
			else
			{
				for (i=0; i<_selected_indices.length; i++)
				{
					ci = _selected_indices[i];
					s.push(_value[ci]);
				}
			}
			return s;
		}
		
		public function set selected(idx:Array):void
		{
			_selected_indices = idx;
			update_ui();
		}
		
		protected function update_ui():void
		{
			if (_cell_renderer==null)
				throw new Error("List requires a cellRenderer -> function(parent:Container,value:Object):IListItem/Component");
			clear_mid();
			if (_value==null)
				return;
			var w:Array = _use_result ? _value : _value.slice(_page*_items_per_page, _page*_items_per_page+_items_per_page);
			for (var i:uint=0; i<w.length; i++)
			{
				var c:Component = create_cell(w[i]);
				if (_selected_indices.indexOf(i+_page*_items_per_page)!=-1)
					set_selectable(c,true);
			}
		}
		
		protected function create_cell(v:Object):Component/*IListItem*/
		{
			var c:Component/*IListItem*/ = _cell_renderer(_mid, v);
			c.addEventListener(ComponentEvent.MOUSE_DOWN, on_click_item);
			c.addEventListener(ComponentEvent.DOUBLE_CLICK, on_double_click_item);
			if (!_use_result) //reorderable
			{
				c.addEventListener(ComponentEvent.DRAG_START, on_drag_item_start);
				c.addEventListener(ComponentEvent.DRAG, on_drag_item);
				c.addEventListener(ComponentEvent.DRAG_STOP, on_drag_item_stop);
				c.dragDelay = 300;
			}
			c.userObject = v;
			return c;
		}
		
		// have to hang on to the component that initiated the dragging
		// or all the events are removed...!
		private function clear_mid():void
		{
			while(_mid.children.length!=0)
			{
				var c:Component = _mid.children.pop();
				if (c!=_dragging)
				{
					c.destroy();
					c = null;
				}
				else
				{
					c.visible = false;
					c.render();
				}
			}
		}
		
		public function get itemsPerPage():uint
		{
			return _items_per_page;
		}
		
		private function on_click_item(e:ComponentEvent):void
		{
			do_select_component(e.component);
			_mid.render();
		}
		
		private function on_double_click_item(e:ComponentEvent):void
		{
			dispatchEvent(new ListEvent(ListEvent.DOUBLE_CLICK_ITEM, this, e.component.userObject));
		}
		
		//////////
		///component overrides
		
		override public function set layout(l:Layout):void
		{
			_mid.layout = l;
		}

		override public function destroy():void
		{
			application.stage.removeEventListener(KeyboardEvent.KEY_DOWN,on_key_down);
			application.stage.removeEventListener(KeyboardEvent.KEY_UP,on_key_up);
		}
		
		override public function clear():void
		{
			value = [];
			_selected_indices = [];
		}
		
		override public function render():void
		{
			//if resized, calc_items_per_page
			var s:uint = calc_items_per_page();
			if (s!=_items_per_page)
			{
				_items_per_page = s;
				update_ui();
			}
			super.render();
		}
		
		private function on_key_up(e:KeyboardEvent):void
		{
			_mod_key_down = (e.shiftKey || e.ctrlKey);
			//trace("KEYUP "+_mod_key_down);
		}
		
		private function on_key_down(e:KeyboardEvent):void
		{
			_mod_key_down = (e.shiftKey || e.ctrlKey);
			//trace("KEYDOWN "+_mod_key_down);
		}
		
//		override public function onFocus(e:FocusEvent):void
//		{
//			switch(e.type)
//			{
//				case FocusEvent.UNFOCUS:
//					update_selection(false);
//					_selected_indices = [];
//					render();
//					break;
//			}
//		}
		
		
		////////////////////////
		/// selection index management
		
		protected function do_select_component(c:Component):void
		{
			var i:uint = _mid.indexOf(c) + _page*_items_per_page;
			var w:int = _selected_indices.indexOf(i);
			if (!_mod_key_down && w!=-1)
				return;
			update_selection(false);
			if (!_mod_key_down)
				_selected_indices = [];
			if (w!=-1)
				_selected_indices.splice(w,1);
			else
				_selected_indices.push(i);
			update_selection(true);
		}
		
		private function update_selection(b:Boolean):void
		{
			for (var i:uint=0; i<_selected_indices.length; i++)
			{
				var idx:int = _selected_indices[i] - _page*_items_per_page;
				if (idx>-1 && idx<_items_per_page)
					set_selectable(_mid.children[idx], b);
			}
			if (b)
				dispatchEvent(new ListEvent(ListEvent.SELECTION_CHANGED, this, _selected_indices));
		}
		
		private function set_selectable(o:*, b:Boolean):void
		{
			var s:ISelectable = o as ISelectable;
			if (s != null)
				s.selected = b;
		}
		
		
		//////////////////////////////////////
		///////////// rubber banding...
		
		private function on_start_band(e:ComponentEvent):void
		{
			var p:Point = getRootPosition();
			_drag_rect = new Rectangle(e.data.x - p.x, e.data.y - p.y);
		}
		
		private function on_drag_band(e:ComponentEvent):void
		{
			var p:Point = getRootPosition();
			var x1:Number = _drag_rect.x;
			var y1:Number = _drag_rect.y;
			var x2:Number = e.data.x-p.x-_drag_rect.x;
			var y2:Number = e.data.y-p.y-_drag_rect.y;
			if (x1+x2<0)
				x2 = -x1;
			if (y1+y2<0)
				y2 = -y1;
			if (x1+x2>width)
				x2 = width-x1;
			if (y1+y2>height)
				y2 = height-y1;
			
			_drag_rect.width = x2;
			_drag_rect.height = y2;
			
			var g:Graphics = _keyline.decorator.graphics;
			g.clear();
			g.lineStyle(1,0,.5);
			g.drawRect(x1,y1,x2,y2);
			
			//
			get_selection_from_box();
			_mid.render();
		}
		
		private function on_stop_band(e:ComponentEvent):void
		{
			var g:Graphics = _keyline.decorator.graphics;
			g.clear();
			//
			get_selection_from_box();
			_mid.render();
		}
		
		private function get_selection_from_box():void
		{
			var dr:Rectangle = _drag_rect.clone();
			if (dr.width<0)
			{
				dr.x = dr.x + dr.width
				dr.width = -dr.width;
			}
			if (dr.height<0)
			{
				dr.y = dr.y + dr.height;
				dr.height = -dr.height;
			}
			update_selection(false);
			if (!_mod_key_down)
				_selected_indices = [];
			for (var i:uint=0; i<_mid.children.length; i++)
			{
				var c:Component = _mid.children[i];
				var r:Rectangle = new Rectangle(c.x+_mid.x,c.y+_mid.y,c.width,c.height);
				var idx:int = i + _page*_items_per_page;
				if (r.intersects(dr) && _selected_indices.indexOf(idx)==-1)
					_selected_indices.push(idx);
			}
			update_selection(true);
		}
		
		private function calc_items_per_page():uint
		{
			var across:uint;
			var down:uint
			var per_page:uint;
			if (_mid.layout is GridLayout)
			{
				var g:GridLayout = _mid.layout as GridLayout;
				across = _mid.width/(g.cellWidth + g.margin.right + g.margin.left);
				down = _mid.height/(g.cellHeight + g.margin.top + g.margin.bottom);
				per_page = across*down;
			}
			else if (_mid.layout is FlowLayout)
			{
				var f:FlowLayout = _mid.layout as FlowLayout;
				switch(f.type)
				{
					case FlowLayout.LEFT_TO_RIGHT:
					case FlowLayout.RIGHT_TO_LEFT:
						per_page = _mid.width/(f.cellWidth + f.margin.right + f.margin.left);
						break;
					case FlowLayout.TOP_TO_BOTTOM:
					case FlowLayout.BOTTOM_TO_TOP:
						per_page = _mid.height/(f.cellHeight + f.margin.top + f.margin.bottom);
						break;
				}
			}
			else
				throw new Error("Unknown layout "+_mid.layout);
			return per_page;
		}
		
		
		//////////////////////////////////////////////////
		// dragging selection
		private var b:Bitmap;
		private function on_drag_item_start(e:ComponentEvent):void
		{
			_dragging = e.component;
			if (_selected_indices.length==1)
			{
				var c:Component = get_selected_children()[0];
				b = c.decorator.createBitmap(.5);
				_drag_art.decorator.addChild(b);
			}
			else
			{
				var l:Label = new Label(_drag_art);
				l.text = _selected_indices.length+" items";
				l.backgroundColor = 0xffffff;
				l.backgroundVisible = true;
				l.backgroundBorderColor = 0x333333;
				l.backgroundBorderVisible = true;
				l.cornerRadius = 8;
			}
			var p:Point = getRootPosition();
			_drag_art.x = e.data.x-p.x+6;
			_drag_art.y = e.data.y-p.y+6;
//			_drag_art.x = _dragging.x + _mid.x +6;
//			_drag_art.y = _dragging.y + _mid.y +6;
			_drag_art.render();
			_insert_art.visible = true;
		}
		
		private function get_selected_children():Array
		{
			var a:Array = new Array();
			for (var i:uint=0; i<_selected_indices.length; i++)
				a.push(_mid.children[_selected_indices[i] - _page*_items_per_page]);
			return a;
		}
		
		private function on_drag_item(e:ComponentEvent):void
		{
			//trace(">"+e.data.x+","+e.data.y);
			_drag_art.x += e.data.dx;
			_drag_art.y += e.data.dy;
			_drag_art.render();
			update_drag_item();
		}
		
		protected function update_drag_item():void
		{
			var c:Component;
			var idx:int = _mid.layout.calculateIndex(_drag_art.x, _drag_art.y);
			idx = Math.max(0,idx);
			if (idx>=_mid.children.length)
			{
				c = _mid.lastChild;
				_insert_art.x = c.x+c.width+_mid.x;
				_insert_art.y = c.y+_mid.y;
			}
			else
			{
				c = _mid.children[idx];
				_insert_art.x = c.x+_mid.x;
				_insert_art.y = c.y+_mid.y;
			}
			_insert_art.render();
		}
		
		private function on_drag_item_stop(e:ComponentEvent):void
		{
			if (_mid.indexOf(_dragging)==-1)//was it hanging around for the events? kilit
			{
				_dragging.destroy();
				_dragging = null;
			}
			_drag_art.clear();
			if (b!=null)
			{
				_drag_art.decorator.removeChild(b);
				b=null;
			}
			_insert_art.visible = false;
			
			//update value
			var insert_idx:uint = _mid.layout.calculateIndex(_drag_art.x, _drag_art.y);
			insert_idx = Math.max(0,insert_idx);
			insert_idx = Math.min(_mid.children.length,insert_idx);
			insert_idx += _page*_items_per_page;
			var vals:Array = [];
			var new_sel:Array = [];
			for (var i:uint=0; i<_selected_indices.length; i++)
			{
				var ci:uint = _selected_indices[i];
				var v:Object = _value[ci];
				vals.push(v);
			}
			for (i=0; i<_selected_indices.length; i++)
			{
				ci = _selected_indices[i]-i;
				if (ci<insert_idx)
					insert_idx--;
				_value.splice(ci,1);
			}
			for (i=0; i<vals.length; i++)
			{
				_value.splice(insert_idx+i,0,vals[i]);
				new_sel.push(insert_idx+i);
			}
			_selected_indices = new_sel;
			update_ui();
			_dirty = true;
			dispatchComponentEvent(ComponentEvent.CHANGE_VALUE, this, value);
			render();
		}
		
		public function get dragging():Boolean
		{
			return _dragging!=null	;
		}
		
		
	}
}