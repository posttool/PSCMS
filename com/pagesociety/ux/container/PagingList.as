package com.pagesociety.ux.container
{
    import com.pagesociety.ux.component.Component;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.dim.Guide;
    import com.pagesociety.ux.component.text.Link;
    import com.pagesociety.ux.event.ComponentEvent;
    
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    
    public class PagingList extends List
    {
        public static const LEFT_RIGHT:uint = 0;
        public static const UP_DOWN:uint = 1;
        
        protected var _pager:Pager;
        protected var _back:ArrowButton;
        protected var _forth:ArrowButton;
        
        private var _type:uint;
        
        public function PagingList(parent:Container, type:uint)
        {
            super(parent);
//          backgroundVisible = true;
//          backgroundColor = 0xeeeeee;
//          backgroundAlpha = .5;
                        
            _type = type;
            
            switch(_type){
                case LEFT_RIGHT:
                    _mid.x = 20;
                    _mid.widthDelta = -40;
                    _mid.heightDelta = -20;
//                  _insert_art.width = 5;
//                  _insert_art.height = 20;
                    break;
                case UP_DOWN:
                    _mid.y = 20
                    _mid.heightDelta = -20;
//                  _insert_art.height = 2;
                    break;
            }
//          _insert_art.backgroundColor = 0;
//          _insert_art.backgroundVisible = true;
            
            switch(_type){
                case LEFT_RIGHT:
                    _back = new ArrowButton(_pagers, ArrowButton.LEFT);
                    _back.width = 20;
                    _back.alignX(Guide.LEFT);
                    break;
                case UP_DOWN:
                    _back = new ArrowButton(_pagers, ArrowButton.UP);
                    _back.height = 20;
                    _back.alignY(Guide.TOP);
                    break;
            }
            _back.addEventListener(ComponentEvent.CLICK, on_click_left);
            _back.addEventListener(ComponentEvent.MOUSE_OVER, on_over_left);
            _back.addEventListener(ComponentEvent.MOUSE_OUT, on_out_left);
            _back.visible = false;
            
            switch(_type){
                case LEFT_RIGHT:
                    _forth = new ArrowButton(_pagers, ArrowButton.RIGHT);
                    _forth.width = 20;
                    _forth.alignX(Guide.RIGHT);
                    break;
                case UP_DOWN:
                    _forth = new ArrowButton(_pagers, ArrowButton.DOWN);
                    _forth.height = 20;
                    _forth.alignY(Guide.BOTTOM,-20);
                    break;
            }
            _forth.addEventListener(ComponentEvent.CLICK, on_click_right);
            _forth.addEventListener(ComponentEvent.MOUSE_OVER, on_over_right);
            _forth.addEventListener(ComponentEvent.MOUSE_OUT, on_out_right);
            
            _pager = new Pager(_pagers);
//          switch(_type){
//              case LEFT_RIGHT:
//                  _pager.x = 20;
//                  _pager.alignY(Guide.BOTTOM);
//                  break;
//              case UP_DOWN:
//                  _pager.x = 0;
//                  _pager.alignY(Guide.BOTTOM);
//                  break;
//          }
            _pager.cellRenderer = pager_cell_renderer;
            _pager.addEventListener(ComponentEvent.CHANGE_VALUE, on_click_page);
            
        }
        
        private function pager_cell_renderer(p:Container, label:String):Component
        {
            var page:Link = new Link(p);
            page.text = label;
            page.addEventListener(ComponentEvent.MOUSE_OVER, on_over_page);
            page.addEventListener(ComponentEvent.MOUSE_OUT, on_out_page);
            return page;
        }
        
        override protected function update_ui():void
        {
            super.update_ui();
            if(value==null)
            {
                _pager.visible      = false;
            }
            else
            {
                _pager.visible      = true;
                _pager.pageSize     = itemsPerPage;
                _pager.totalCount   = totalCount;
            }
            _back.visible = false;
            _forth.visible = totalCount>itemsPerPage;
        }
        
        override public function set page(p:uint):void
        {
            super.page = p;
            update_page();
        }
        
        private function update_page():void
        {
            _pager.page = page;
            _back.visible = _pager.page!=0;
            _forth.visible = totalCount>itemsPerPage && (_pager.page!=_pager.pages-1);
            render();
            update_drag_item();
        }
        
        private function on_click_page(e:*=null):void
        {
            page = _pager.page;
            update_page();
        }
        
        private function on_click_left(e:*=null):void
        {
            page--;
            update_page();
        }
        
        private function on_click_right(e:*=null):void
        {
            page++;
            update_page();
        }
        
        //// overs
        private function on_over_page(e:*):void
        {
            if (!dragging)
                return;
            var offset:uint = e.component.userObject;
            execute_later("over_page", 
                function():void { 
                    _pager.offset = offset; 
                    on_click_page(); 
                }, 1000);
        }
        
        private function on_out_page(e:*):void
        {
            if (!dragging)
                return;
            cancel_execute_laters();
        }
        
        private var _timer:Timer;
        private function on_over_left(e:*):void
        {
            if (!dragging)
                return;
            _timer = new Timer(1000);
            _timer.addEventListener(TimerEvent.TIMER, on_left_time);
            _timer.start();
        }
        
        private function on_out_left(e:*):void
        {
            if (!dragging)
                return;
            _timer.stop();
            _timer = null;
        }
        
        private function on_left_time(e:*):void
        {
            if (!dragging)
                return;
            on_click_left();
        }
        
        private function on_over_right(e:*):void
        {
            if (!dragging)
                return;
            _timer = new Timer(1000);
            _timer.addEventListener(TimerEvent.TIMER, on_right_time);
            _timer.start();
        }
        
        private function on_out_right(e:*):void
        {
            if (!dragging)
                return;
            _timer.stop();
            _timer = null;
        }
        
        private function on_right_time(e:*):void
        {
            if (!dragging)
                return;
            on_click_right();
        }
    }
}