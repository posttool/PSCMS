package com.pagesociety.cms.component.reference
{
    import com.pagesociety.cms.CmsEvent;
    import com.pagesociety.cms.component.button.AddButton;
    import com.pagesociety.cms.component.button.LinkButton;
    import com.pagesociety.cms.view.EntityView0;
    import com.pagesociety.persistence.Entity;
    import com.pagesociety.ux.Margin;
    import com.pagesociety.ux.component.Component;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.dim.Guide;
    import com.pagesociety.ux.container.PagingList;
    import com.pagesociety.ux.event.ComponentEvent;
    import com.pagesociety.ux.layout.FlowLayout;
    import com.pagesociety.ux.layout.GridLayout;
    import com.pagesociety.ux.layout.Layout;
    
    public class XRefArrayEditor extends PagingList 
    {
        protected var _add:AddButton;
        protected var _link:LinkButton;
        
        public function XRefArrayEditor(parent:Container,
                                        add_text:String="CREATE", link_text:String="BROWSE",
                                        cell_width:Number=130, cell_height:Number=80)
        {
            super(parent,PagingList.LEFT_RIGHT);
            
            _bg.backgroundAlpha = .9;
            _bg.backgroundColor = 0xffffff;
            _bg.heightDelta = -20;
            _bg.backgroundShadowSize = 7;
            _bg.backgroundShadowStrength = .07;
            _mid.layout = new GridLayout(GridLayout.GROW_VERTICALLY, 
                { cellWidth: cell_width, cellHeight: cell_height, margin: new Margin(5,0,0,5)});
            _mid.heightDelta = -20;
            cellRenderer = default_cell_render;
            
            _controls.height = 19;
            _controls.alignY(Guide.BOTTOM);
            _controls.layout = new FlowLayout(FlowLayout.LEFT_TO_RIGHT, {invisibleComponentsInFlow: false});
            
            _add = new AddButton(_controls, add_text);
            _add.addEventListener(ComponentEvent.CLICK, on_click_create);
            
            if (link_text!=null)
            {
                _link = new LinkButton(_controls, link_text);
                _link.addEventListener(ComponentEvent.CLICK, on_click_browse);
            }
            
            _pager.alignY(Guide.BOTTOM);
            _pager.alignX(Guide.RIGHT);
            
            height = 200;
        }
        
        override public function set layout(layout:Layout):void
        {
            _mid.layout = layout;
        }
        
        override public function get layout():Layout
        {
            return _mid.layout;
        }
        
        protected function on_click_create(e:ComponentEvent):void
        {
            dispatchComponentEvent(CmsEvent.CREATE_ENTITY, this);
        }
        
        protected function on_click_browse(e:ComponentEvent):void
        {
            dispatchComponentEvent(CmsEvent.BROWSE_ENTITY_TYPE, this);
        }
        
        protected function default_cell_render(p:Container, e:Entity):Component
        {
            var es:EntityView0 = new EntityView0(p, e);
            es.addEventListener(CmsEvent.DELETE_ENTITY, onBubbleEvent);
            return es;
        }
        
        public function set showAdd(b:Boolean):void
        {
            _add.visible = b;
            _add.render();
        }
        
        public function set showLink(b:Boolean):void
        {
            if (_link==null)
                return;
            _link.visible = b;
            _link.render();
        }
        
        public function set showControls(b:Boolean):void
        {
            _controls.visible = b;
            _controls.render();
        }
        
        public function getBg():Component
        {
            return _bg;
        }
        
    }
}