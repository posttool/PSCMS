package com.pagesociety.cms.component.button
{
    import com.pagesociety.ux.component.Component;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.text.Label;
    import com.pagesociety.ux.decorator.ShapeFactory;
    
    public class LinkButton extends Container
    {
        private var _icon:Component;
        private var _label:Label;
        public function LinkButton(parent:Container, s:String="BROWSE")
        {
            super(parent);
            _icon = new Component(this);
            ShapeFactory.chevron_right(_icon.decorator.midground.graphics, 1,5,3,6,8);
            _label = new Label(this);
            _label.text = s;
            _label.x = 10;
            backgroundVisible = true;
            backgroundAlpha = 0;
            add_mouse_over_default_behavior();
        }
        
        override public function render():void
        {
            decorator.color = _over ? 0 : 0x777777;
            super.render();
        }
        
        override public function get width():Number
        {
            return _label.x + _label.width + 15;
        }
        
    }
}