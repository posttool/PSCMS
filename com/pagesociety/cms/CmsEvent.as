package com.pagesociety.cms
{
	import com.pagesociety.ux.IComponent;
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.event.ComponentEvent;
	
	import flash.events.Event;
	
	public class CmsEvent extends ComponentEvent 
	{
		public static var UPLOAD_COMPLETE:String = "upload_complete";
		public static var UPLOAD_FAILED:String = "upload_failed";
		public static var CLOSE_FORM:String = "close_form";
		public static var SAVE_FORM:String = "save_form";
		public static var CREATE_ENTITY:String = "create_entity";
		public static var EDIT_ENTITY:String = "edit_entity";
		public static var DELETE_ENTITY:String = "delete_entity";
		public static var BROWSE_ENTITY_TYPE:String = "browse_entity_type";
		public static var LOGOUT:String = "logout";
		
		private var _data:Object;
		
		public function CmsEvent(type:String, c:IComponent, o:*, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, c as Component, o, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new CmsEvent(type,component,data,bubbles,cancelable);
		}

	}
}