package com.pagesociety.ux.container
{
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.decorator.ShapeFactory;
    
    import flash.display.Graphics;
    
    public class ArrowButton extends FadingButton
    {
        public static const LEFT:uint = 0;
        public static const RIGHT:uint = 1;
        public static const UP:uint = 2;
        public static const DOWN:uint = 3;
        public function ArrowButton(parent:Container, type:uint)
        {
            super(parent, null, 
                function (g:Graphics):void
                {
                    var d:Number = type==LEFT || type==RIGHT ? width : height;
                    var s:Number = d*.5;
                    var s0:Number = height*.5;
                    g.clear();
                    g.beginFill(0xffffff, .5);
                    g.drawRect(d-s*2, s0-s, s*2, s*2);
                    g.endFill();
                    switch (type)
                    {
                        case LEFT:
                            ShapeFactory.chevron_left(g, d-s*1.5, s0-s, 4, s,s*2, 0, 1);
                            break;
                        case RIGHT:
                            ShapeFactory.chevron_right(g, d-s*1.5, s0-s, 4, s,s*2, 0, 1);
                            break;
                        case UP:
                            ShapeFactory.chevron_up(g, d-s*1.5, s0-s, 4, s,s*2, 0, 1);
                            break;
                        case DOWN:
                            ShapeFactory.chevron_down(g, d-s*1.5, s0-s, 4, s,s*2, 0, 1);
                            break;
                    }
                });
        }
    }
}