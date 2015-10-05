package com.pagesociety.cms.component.button
{
    import com.pagesociety.ux.component.Component;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.text.Label;
    import com.pagesociety.ux.decorator.ShapeFactory;
    
    public class AddButton extends Container
    {
        private var _icon:Component;
        private var _label:Label;
        public function AddButton(parent:Container, s:String="CREATE")
        {
            super(parent);
            _icon = new Component(this);
            ShapeFactory.plus(_icon.decorator.midground.graphics, 6,9,3,0,1,2);
            _label = new Label(this);
            _label.text = s;
            _label.x = 14;
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
        
        override public function get height():Number
        {
            return _label.y*2 + _label.height +2;
        }
    }
}