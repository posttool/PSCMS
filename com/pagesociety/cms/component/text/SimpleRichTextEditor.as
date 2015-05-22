package com.pagesociety.cms.component.text
{
	import com.pagesociety.cms.config.CmsConfigEntityElement;
	import com.pagesociety.ux.IEditor;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.ToggleButton;
	import com.pagesociety.ux.component.text.RichTextEditor;
	import com.pagesociety.ux.event.ComponentEvent;
	import com.pagesociety.ux.event.InputEvent;
	import com.pagesociety.ux.layout.FlowLayout;
	
	import flash.events.Event;
	import flash.utils.getTimer;

	[Event(type="com.pagesociety.ux.event.InputEvent",name="lose_focus_while_dirty")]

	public class SimpleRichTextEditor extends Container implements IEditor
	{
		protected var _rte:RichTextEditor;
		protected var _buttons:Container;
		protected var _bold:ToggleButton;
		protected var _italic:ToggleButton;
		protected var _underline:ToggleButton;
		protected var _link:ToggleButton;
		protected var _glyph:ToggleButton;
		protected var _link_editor:LinkEditor;
			
		public function SimpleRichTextEditor(p:Container)
		{
			super(p);
			
			var t = getTimer();
			
						
			_rte = new RichTextEditor(this);
			_rte.richTextDecorator.normalColor = 0;
			_rte.richTextDecorator.linkColor = 0x444444;
			_rte.richTextDecorator.thumbColor = 0x555555;
			_rte.addEventListener(RichTextEditor.SELECTION_CHANGE, on_selection_change);
			_rte.addEventListener(RichTextEditor.RTE_LINK, on_link);
			_rte.addEventListener(RichTextEditor.RTE_SCROLL, on_scroll);
			_rte.addEventListener(ComponentEvent.CHANGE_VALUE, onBubbleEvent);
			_rte.addEventListener(InputEvent.LOSE_FOCUS_WHILE_DIRTY, onBubbleEvent);
			
			_buttons = new Container(this);
			_buttons.layout = new FlowLayout(FlowLayout.LEFT_TO_RIGHT);
			_buttons.layout.margin.left = 6;
			_bold = get_button(on_click_bold,"B");
			_italic = get_button(on_click_italic,"I");
			_underline = get_button(on_click_underline,"U");
			_glyph = get_button(on_click_glyph,"¶");
			_link = get_button(on_click_link,"LINK");
			//get_button(on_print,"PRINT");
			_link_editor = new LinkEditor(this);
			_link_editor.visible = false;
			_link_editor.addEventListener(LinkEditor.CHANGE_LINK, on_change_link);
			_link_editor.addEventListener(LinkEditor.REMOVE_LINK, on_remove_link);
			
			height = 300;
			
		}
		
		
		public function get value():Object 
		{ 
			return _rte.value;
		}
		
		public function set value(o:Object):void 
		{ 
			_rte.value = o;
		}
		
		public function get dirty():Boolean 
		{ 
			return _rte.dirty; 
		}
		
		public function set dirty(b:Boolean):void 
		{ 
			_rte.dirty=b; 
		}

		private function get_button(f:Function,s:String):ToggleButton
		{
			var tb:ToggleButton = new ToggleButton(_buttons);
			tb.fontStyle =  "black_small";
			tb.label = s;
			tb.falseColor = 0xffffff;
			tb.trueColor = 0x888888;
			tb.height = 12;
			tb.addEventListener(ComponentEvent.CLICK, f);
			return tb;
		}
		
		private function on_click_bold(e:ComponentEvent):void
		{
			_rte.bold = true;
			on_selection_change();
		}
		
		private function on_click_underline(e:ComponentEvent):void
		{
			_rte.underline = true;
			on_selection_change();
		}
		
		private function on_click_italic(e:ComponentEvent):void
		{
			_rte.italic = true;
			on_selection_change();
		}
		
		private function on_click_link(e:ComponentEvent):void
		{
			var s:String = _rte.url;
			showLinkDialog(s, on_submit_link);

		}
		
		private function on_submit_link(s:String):void
		{
			if (s!="")
				s = "event:"+s;
			trace("SUBMIT LINK "+s);
			_rte.url = s;
			_rte.dirty = true;
			on_selection_change();
		}
		
		private function on_click_glyph(e:ComponentEvent):void
		{
			showGlyphDialog(on_submit_glyph);
		}
		
		private function on_submit_glyph(s:String):void
		{
			_rte.replaceSelectedText(s);
		}
		
		private function on_print(e:ComponentEvent):void
		{
			trace(_rte.value);
		}
		
		protected function on_selection_change(e:ComponentEvent=null):void
		{
			update_buttons();
			_buttons.render();
		}
		
		private function on_link(e:ComponentEvent):void
		{
			_link_editor.value = e.data;
			_link_editor.visible = true;
			_link_editor.render();
			var x:Number = _rte.richTextDecorator.selectionX+8;
			var y:Number = _rte.richTextDecorator.selectionY+29;
			if (x+_link_editor.width>width)
				x = width-_link_editor.width+10;
			if (x<0)
				x = 0;
			_link_editor.updatePosition( x, y);
		}
		
		private function on_change_link(e:ComponentEvent):void
		{
			_link_editor.visible = false;
			_link_editor.render();
			var s:String = _rte.url;
			showLinkDialog(s, on_submit_link);
		}
		
		private function on_remove_link(e:ComponentEvent):void
		{
			_rte.url = "";
			_link_editor.visible = false;
			_link_editor.render();
		}
		
		private function on_scroll(e:ComponentEvent):void
		{
			_link_editor.visible = false;
			_link_editor.render();
		}
		
		override public function render():void
		{
			_buttons.y = -15;
			_buttons.x = width - _buttons.layout.calculateWidth();
			_rte.height = height - _rte.y;
			update_buttons();
			super.render();
		}
		
		private function update_buttons():void
		{
			_bold.value = _rte.bold;
			_italic.value = _rte.italic;
			_underline.value = _rte.underline;
			_link.value = _rte.link;
			if (!_rte.link)
			{
				_link_editor.visible = false;
				_link_editor.render();
			}

		}
		
		
		
		
		
		
		
		/// stuff for glyph editor/dialog
		protected  var _link_dialog:LinkDialog;
		protected  var _glyph_dialog:GlyphDialog;
		protected  var _link_target:Function;
		protected  var _glyph_target:Function;
		

		
		public function showLinkDialog(s:String, f:Function):void
		{
			_link_target = f;
			
			_link_dialog = new LinkDialog(this);
			_link_dialog.addEventListener(InputEvent.SUBMIT, on_hide_link_dialog);
			
			if (s.substring(0,6)=="event:")
				s=s.substring(6);
			_link_dialog.value = s;
			_link_dialog.focus();
			application.pushTakeOver(_link_dialog, on_hide_link_dialog, 0xffffff, .77, true);
		}

		public function showGlyphDialog(f:Function):void
		{
			_glyph_target = f;
			
			_glyph_dialog = new GlyphDialog(this);
			_glyph_dialog.addEventListener(GlyphDialog.SELECT_GLYPH, on_hide_glyph_dialog);
			
			application.pushTakeOver(_glyph_dialog, on_hide_glyph_dialog, 0xffffff, .77, true);
		}
		
		private function on_hide_link_dialog(e:*):void
		{
			application.hideTakeOver();
			_link_target(_link_dialog.value);
//			removeComponent(_link_dialog);
//			_link_dialog = null;
		}
		
		private function on_hide_glyph_dialog(e:*):void
		{
			application.hideTakeOver();
			_glyph_target(e.data);
//			removeComponent(_glyph_dialog);
//			_glyph_dialog = null;
		}

		
	}
}