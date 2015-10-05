package com.pagesociety.ux.container
{
    import com.pagesociety.ux.component.Component;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.decorator.ShapeFactory;
    import com.pagesociety.ux.event.ComponentEvent;
    
    import flash.display.Graphics;
    
    public class FadingButton extends Container
    {
        private var _a:Component;
        private var _b:Component;
        private var _c:Component;
        private var _a_paint:Function;
        private var _b_paint:Function;
        
        public function FadingButton(parent:Container, a_paint:Function=null, b_paint:Function=null)
        {
            super(parent);
            _a = new Component(this);
            _b = new Component(this);
            _b.alpha = 0;
            _b.visible = false;
            _a_paint = a_paint;
            _b_paint = b_paint;
            _c = new Component(this);
            _c.backgroundVisible = true;
            _c.backgroundAlpha = 0;
            _c.addEventListener(ComponentEvent.MOUSE_OVER, on_over);
            _c.addEventListener(ComponentEvent.MOUSE_OUT, on_out);
        }
        
        private function on_over(e:ComponentEvent):void
        {
            cancel_execute_laters();
            _b.visible = true;
            _b.alphaTo(1, 200);
            _a.alphaTo(0, 200, on_hide_a);
        }
        
        private function on_hide_a():void
        {
            _a.visible = false;
            render();
        }
        
        private function on_out(e:ComponentEvent):void
        {
            execute_later("fadeout", 
                function():void { 
                    _b.alphaTo(0, 300, on_hide_b);
                    _a.visible = true;
                    _a.alphaTo(1, 300);
                }, 777);
        }


        private function on_hide_b():void
        {
            _b.visible = false;
            render();
        }

        override public function render():void
        {
            super.render();
            
            var g:Graphics;
            
            g = _a.decorator.graphics;
            if (_a_paint!=null)
                _a_paint(g);
            
            
            g = _b.decorator.graphics;
            if (_b_paint!=null)
                _b_paint(g);
            else
                default_b_paint(g);
            
        }
        
        private function default_b_paint(g:Graphics):void
        {
            var s:Number = Math.max(20,width*.3);
            var s0:Number = height*.5;
            g.clear();
            g.beginFill(0xffffff, .5);
            g.drawRect(width-s*2, s0-s, s*2, s*2);
            g.endFill();
            ShapeFactory.chevron_right(g, width-s*1.5, s0-s, 4, s,s*2, 0, 1);
        }
    }
}