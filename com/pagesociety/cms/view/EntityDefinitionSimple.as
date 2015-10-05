package com.pagesociety.cms.view
{
    import com.pagesociety.cms.CmsEvent;
    import com.pagesociety.cms.Constants;
    import com.pagesociety.ux.container.SelectableContainer;
    import com.pagesociety.cms.component.button.AddButton;
    import com.pagesociety.cms.component.button.LinkButton;
    import com.pagesociety.cms.config.CmsConfigEntity;
    import com.pagesociety.persistence.EntityDefinition;
    import com.pagesociety.ux.component.Component;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.dim.Guide;
    import com.pagesociety.ux.component.text.Label;
    import com.pagesociety.ux.decorator.ShapeFactory;
    import com.pagesociety.ux.event.ComponentEvent;
    import com.pagesociety.ux.layout.FlowLayout;

    public class EntityDefinitionSimple extends Container
    {
        private var l:Label;
        private var _create:AddButton;
        private var _browse:LinkButton;
        
        public function EntityDefinitionSimple(parent:Container, e:EntityDefinition)
        {
            super(parent);
            
            userObject = e;
            
            backgroundVisible           = true; 
            backgroundColor             = Constants.COLOR_WHITE;
            backgroundAlpha             = .8;
        
            l           = new Label(this);
            l.text      = e.name;
            l.x         = 3;
            l.y         = 6;
            l.widthDelta = -10;
            l.height    = 20;
            l.multiline = true;
            l.fontStyle = "black_medium";
            
            var c:Container = new Container(this);
            c.layout = new FlowLayout(FlowLayout.LEFT_TO_RIGHT);
            c.height = 20;
            c.x = 3;
            c.alignY(Guide.BOTTOM);
            _create = new AddButton(c,"CREATE");
            _create.addEventListener(ComponentEvent.CLICK, on_click_create);
            _browse = new LinkButton(c, "BROWSE");
            _browse.addEventListener(ComponentEvent.CLICK, on_click_browse);
            
            add_mouse_over_default_behavior();
        }
        
        override public function render():void
        {
            _create.visible = _over;
            _browse.visible = _over;
            super.render();
        }
        
        private function on_click_create(e:*):void
        {
            dispatchComponentEvent(CmsEvent.CREATE_ENTITY, this, userObject);
        }
        
        private function on_click_browse(e:*):void
        {
            dispatchComponentEvent(CmsEvent.BROWSE_ENTITY_TYPE, this, userObject);
        }
        
    }
}