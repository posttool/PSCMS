package com.pagesociety.cms.browser
{
    import com.pagesociety.cms.CmsEvent;
    import com.pagesociety.cms.config.CmsConfigEntity;
    import com.pagesociety.persistence.EntityDefinition;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.container.Browser;
    import com.pagesociety.ux.event.BrowserEvent;
    import com.pagesociety.ux.event.SelectionEvent;
    import com.pagesociety.ux.layout.GridLayout;
    import com.pagesociety.cms.view.EntityDefinitionSimple;
    

    [Event(type="com.pagesociety.ux.event.SelectionEvent",name="select")]
    public class EntityDefinitions extends Container
    {
        private var _create_defs:Browser;
        public function EntityDefinitions(parent:Container, top_level_entities:Array)
        {
            super(parent);
            
            _create_defs                    = new Browser(this);
            _create_defs.cellRenderer       = get_cell_renderer; 
            _create_defs.value              = top_level_entities;
            _create_defs.focusable          = false;
            _create_defs.backgroundColor    = 0xFFFFFF;
            _create_defs.willAutoUnfocusSelections = false;
//          _create_defs.addEventListener(BrowserEvent.DOUBLE_CLICK, on_single_click);
            styleProps = { top: 10, left: 10, width: 180, height: 100 };
        }
        
        private function get_cell_renderer(parent:Container, def:EntityDefinition):EntityDefinitionSimple
        {
            var eds:EntityDefinitionSimple = new EntityDefinitionSimple(parent, def);
            eds.addEventListener(CmsEvent.CREATE_ENTITY, onBubbleEvent);
            eds.addEventListener(CmsEvent.BROWSE_ENTITY_TYPE, onBubbleEvent);
            return eds;
        }
        
        
//      private function on_single_click(e:BrowserEvent):void
//      {
//          dispatchEvent(new SelectionEvent(SelectionEvent.SELECT, _create_defs.selectionComponent, _create_defs.selectionComponent.userObject));
//      }
        
        public function set styleProps(props:Object):void
        {
            _create_defs.layout.margin.top      = vor(0,props.top);
            _create_defs.layout.margin.right    = vor(0,props.right);
            _create_defs.layout.margin.bottom   = vor(0,props.bottom);
            _create_defs.layout.margin.left     = vor(0,props.left);
            GridLayout(_create_defs.layout).cellWidth       = vor(0,props.width);
            GridLayout(_create_defs.layout).cellHeight      = vor(0,props.height);
        }
        
        private function vor(o:*,x:*):*
        {
            if (x==null)
                return o;
            else
                return x;
        }
        
        
    }
}