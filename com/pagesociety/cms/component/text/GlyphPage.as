package com.pagesociety.cms.component.text
{
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.text.Link;
    import com.pagesociety.ux.event.ComponentEvent;
    import com.pagesociety.ux.layout.GridLayout;
    
    import flash.text.Font;

    [Event(type="com.postera.cms.components.GlyphDialog",name="select_glyph")]
    public class GlyphPage extends Container
    {
        private var _font:Font;
        public function GlyphPage(parent:Container,font:Font)
        {
            super(parent);
            _font =font;
            layout = new GridLayout(GridLayout.GROW_VERTICALLY, {
                cellWidth:38, 
                cellHeight:48
            });
            x = 20;
            y = 20;
            widthDelta = -30;
        }
        
        public function set value(s:String):void
        {
            clear();
            for (var i:uint=0; i<s.length; i++)
            {
                var c:String = s.charAt(i);
                if (_font!=null)
                {
                    if (!_font.hasGlyphs(c))
                        continue;
                }
                var l:Link = new Link(this);
                l.text = c;
                l.userObject = c;
//              l.fontStyle = PosteraFont.LARGE_TITLE;
                l.addEventListener(ComponentEvent.CLICK, on_click);
            }
        }
        
        private function on_click(e:ComponentEvent):void
        {
            dispatchComponentEvent(GlyphDialog.SELECT_GLYPH, this, e.component.userObject);
        }
        
    }
}