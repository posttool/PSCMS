package com.pagesociety.ux.container
{
    import com.pagesociety.ux.event.ComponentEvent;
    
    import flash.events.Event;
    
    public class ListEvent extends ComponentEvent
    {
        public static const SELECTION_CHANGED:String = "selection_changed";
        
        public static const CLICK_ITEM:String = "click_item";
        public static const DOUBLE_CLICK_ITEM:String = "double_click_item";
        public static const DRAGGING_ITEM:String = "dragging_item";
        
        public static const REMOVE_ITEM:String = "remove_item";
        public static const ADD_ITEM:String = "browser_item_add";
        public static const REORDER_ITEM:String = "reorder_item";
        
        private var _new_index:int;
        
        public function ListEvent(type:String, list:List, data:Object, new_index:int=-1)
        {
            super(type, list, data);
            _new_index = new_index;
        }
        
        public function get list():List
        {
            return component as List;
        }
        
        public function get changeIndex():uint
        {
            return _new_index;
        }
        
        override public function clone():Event
        {
            return new ListEvent(type,component as List,data,_new_index);
        }
        
        
    }
}