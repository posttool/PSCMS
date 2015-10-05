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
    import com.pagesociety.ux.container.List;
    import com.pagesociety.ux.container.PagingList;
    import com.pagesociety.ux.event.ComponentEvent;
    import com.pagesociety.ux.layout.FlowLayout;
    import com.pagesociety.ux.layout.GridLayout;
    
    public class XRefEditor extends List 
    {
        private var _add:AddButton;
        private var _link:LinkButton;
        
        public function XRefEditor(parent:Container,
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
                { cellWidth: cell_width, cellHeight: cell_height, margin: new Margin(5,0,0,25)});
            _mid.heightDelta = -20;
            cellRenderer = default_cell_render;
            
            _controls.height = 19;
            _controls.alignY(Guide.BOTTOM);
            _controls.layout = new FlowLayout(FlowLayout.LEFT_TO_RIGHT);
            
            _add = new AddButton(_controls,add_text);
            _add.addEventListener(ComponentEvent.CLICK, on_click_create);
            _link = new LinkButton(_controls, link_text);
            _link.addEventListener(ComponentEvent.CLICK, on_click_browse);
            
            height = 115;
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
        
        override public function set value(v:Object):void
        {
            if (v==null)
                super.value = [];
            else
                super.value = [v];
        }
        
        override public function get value():Object
        {
            var v:Object = super.value;
            if (v==null || v.length==0)
                return null;
            else
                return v[0];
        }
        
        
    }
}