package com.pagesociety.cms
{
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.text.Label;
	import com.pagesociety.ux.component.text.Link;
	import com.pagesociety.ux.event.ComponentEvent;
	import com.pagesociety.ux.layout.FlowLayout;
	import com.pagesociety.web.ErrorMessage;

	[Event(type="com.pagesociety.cms.Dialog", name="affirm")]
	[Event(type="com.pagesociety.cms.Dialog", name="cancel")]
	public class Dialog extends Container
	{
		public static const AFFIRM:String = "affirm";
		public static const CANCEL:String = "cancel";
		
		public static const TYPE_NONE:uint=0;
		public static const TYPE_CANCEL:uint=1;
		public static const TYPE_YES_NO:uint=2;
		public static function createDialog(parent:Container,title:String,msg:String,type:uint=TYPE_NONE):Dialog
		{
			var p:Dialog = new Dialog(parent);
			p._title.text = title;
			p.add_message();
			p._msg.text = msg;
			switch(type){
				case TYPE_NONE:
					break;
				case TYPE_CANCEL:
					p.add_cancel();
					break;
				case TYPE_YES_NO:
					p.add_cancel_affirm();
					break;
			}
			return p;
		}

		public static function confirm(p:Container, s:String, no:Function, yes:Function):void
		{
			var dialog:Dialog = createDialog(p, "ALERT", s, TYPE_YES_NO);
			var on_close_dialog:Function = function (e:*=null):void
			{
				p.application.hideTakeOver();
				try {
					p.removeComponent(dialog);
				} catch(e:*){}
				dialog = null;
			};
			dialog.addEventListener(CANCEL, function(e:ComponentEvent):void{ on_close_dialog(); no(e.clone()); });
			dialog.addEventListener(AFFIRM, function(e:ComponentEvent):void{ on_close_dialog(); yes(e.clone()); });
			p.application.pushTakeOver(dialog, on_close_dialog, Constants.TAKE_OVER_COLOR, Constants.TAKE_OVER_ALPHA, true);
		}
		
		protected var _title:Label;
		protected var _msg:Label;
		protected var _controls:Container;
		
		public function Dialog(parent:Container)
		{
			super(parent);
			
			width=440;
			height=350;
			backgroundVisible = true;
			backgroundColor = 0xEEEEEE;
			backgroundShadowColor = 0;
			backgroundShadowStrength = .4;
			backgroundShadowSize = 43;
//			cornerRadius = 40;
			clear();
		}
		
		override public function clear():void
		{
			super.clear();
			
			_title = new Label(this);
//			_title.fontStyle = PosteraFont.SMALL_BODY;
			_title.text = "";
			_title.y = 20;
			_title.x = 20;
			_msg = null;
			_controls = null;
		}
		
		public function set error(e:ErrorMessage):void
		{
			_msg.text = e.message;
		}
		
		public function set text(s:String):void
		{
			_msg.text = s;
		}
		
		protected function init_controls():void
		{
			if (_controls==null)
			{
				_controls = get_row(this,6);
			}
			else
			{
				_controls.clear();
			}
		}
		
		protected function add_cancel(cancel:String="cancel"):void
		{
			init_controls();
			get_link(_controls, cancel.toUpperCase()).
				addEventListener(ComponentEvent.CLICK, translateEvent(CANCEL));
		}
		
		protected function add_cancel_affirm(cancel:String="no", affirm:String="yes"):void
		{
			init_controls();
			get_link(_controls, cancel.toUpperCase()).
				addEventListener(ComponentEvent.CLICK, translateEvent(CANCEL));
			get_gap(_controls,15);
			get_link(_controls, affirm.toUpperCase()).
				addEventListener(ComponentEvent.CLICK, translateEvent(AFFIRM));
		}
		
		protected function add_message():void
		{
			_msg = new Label(this);
			_msg.multiline = true;
			_msg.width = 350;
			_msg.x = 20;
			_msg.y = 50;
			_msg.fontStyle = "black_big";
		}
		
		override public function render():void
		{
			if (_controls!=null)
			{
				_controls.y = height-40;
				_controls.x = width-30-_controls.layout.calculateWidth();
			}
			super.render();
		}
		

		
		
		// stuff
		public function get_link(p:Container,s:String):Link
		{
			var link:Link = new Link(p);
			link.text = s ;
//			link.arrow = arrow;
			return link;
		}
		
		public function get_gap(p:Container,h:Number=6):Component
		{
			var c:Component = new Component(p);
			c.height = h;
			c.width = h;
			return c;
		}
		
		public function get_row(p:Container,space_between_elements:uint=0,style_props:Object=null):Container
		{
			var c:Container = new Container(p);
			c.layout = new FlowLayout(FlowLayout.LEFT_TO_RIGHT);
			c.layout.margin.right = space_between_elements;
			if (style_props!=null)
				application.style.apply(c, style_props);
			return c;
		}
		
	}
}