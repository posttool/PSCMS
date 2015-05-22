package com.pagesociety.cms.component.text
{
	import com.pagesociety.util.StringUtil;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.button.DeleteButton;
	import com.pagesociety.ux.component.text.Link;
	import com.pagesociety.ux.event.ComponentEvent;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	[Event(type="com.postera.cms.components.LinkEditor", name="change_link")]
	[Event(type="com.postera.cms.components.LinkEditor", name="remove_link")]
	
	public class LinkEditor extends Container
	{
		public static const CHANGE_LINK:String = "change_link";
		public static const REMOVE_LINK:String = "remove_link";
		
		private var _link:Link;
		private var _change:Link;
		private var _remove:Link;
		private var _close:DeleteButton;
		
		private var _url:String;
		
		public function LinkEditor(parent:Container, index:Number=-1)
		{
			super(parent, index);

			height = 30;
			backgroundVisible = true;
			cornerRadius = 11;
//			backgroundColor = PosteraColor.GRAY_1;
			backgroundShadowSize = 13;
			backgroundShadowStrength = .3;
			
			_link = add_link("");
//			_link.fontStyle = PosteraFont.SMALL_TITLE;
			_link.addEventListener(ComponentEvent.CLICK, on_click_link);

			_change = add_link("CHANGE LINK");
			_change.addEventListener(ComponentEvent.CLICK, translateEvent(CHANGE_LINK));

			_remove = add_link("REMOVE LINK");
			_remove.addEventListener(ComponentEvent.CLICK, translateEvent(REMOVE_LINK));

			_close = new DeleteButton(this);
			_close.addEventListener(ComponentEvent.CLICK, on_click_close);
				
		}
		
		public function set value(s:String):void
		{
			_url = s;
		}
		
		private function on_click_link(e:ComponentEvent):void
		{
			if (StringUtil.beginsWith(_url,"http://"))
				navigateToURL(new URLRequest(_url), "_blank");
		}
		
		private function on_click_close(e:ComponentEvent):void
		{
			visible = false;
			render();
		}
		
		override public function render():void
		{
			if (_url!=null)
			{
				if (_url.length>23)
					_link.text = _url.substring(0,23)+"..."
				else
					_link.text = _url;
			}
			
			var cx:Number = 5;
			var cy:Number = 5;
			
			_link.x = cx;
			_link.y = cy;
			cx += _link.width+15;
			cy = 9;
			_change.x = cx;
			_change.y = cy;
			cx += _change.width+7;
			_remove.x = cx;
			_remove.y = cy;
			cx += _remove.width+5;
			cy -= 1;
			_close.x = cx;
			_close.y = cy;
			cx += _close.width+13;
			width = cx;
			
			super.render();
		}
		
		
	}
}