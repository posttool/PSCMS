package com.pagesociety.cms.component.text
{
    import com.pagesociety.util.BootstrapImpl;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.container.PageContainer;
    import com.pagesociety.ux.component.container.SingleSelectionContainer;
    import com.pagesociety.ux.component.text.Glyphs;
    import com.pagesociety.ux.component.text.Link;
    import com.pagesociety.ux.event.ComponentEvent;
    import com.pagesociety.ux.layout.FlowLayout;
    
    import flash.text.Font;

    [Event(type="com.postera.cms.components.GlyphDialog",name="select_glyph")]
    public class GlyphDialog extends Container
    {
        public static const SELECT_GLYPH:String = "select_glyph";
        private var _glyphs:PageContainer;
        private var _tabs:SingleSelectionContainer;
        private var _cancel:Link;
        private static const _labels:Array = ["symbol","currency","latin","greek","math"]
        
        public function GlyphDialog(parent:Container)
        {
            super(parent);
            width = 580;
            height = 350;
            cornerRadius = 25;
            backgroundVisible = true;
            backgroundColor = 0xeeeeee;//PosteraColor.GRAY_0;
            
            _cancel = add_link("CANCEL");
            _cancel.addEventListener(ComponentEvent.CLICK, on_cancel);
            _cancel.x = width - 70;
            _cancel.y = height - 30;
            
            _glyphs = new PageContainer(this);
            _glyphs.x = 10;
            _glyphs.y = 24;
            _glyphs.widthDelta = -10;
            _glyphs.heightDelta = -60;
            
            _tabs = new SingleSelectionContainer(this);
            _tabs.layout = new FlowLayout(FlowLayout.LEFT_TO_RIGHT);
            _tabs.layout.margin.right = 7;
            _tabs.x = 10;
            _tabs.y = 12;
            _tabs.addEventListener(ComponentEvent.CHANGE_VALUE, on_click_page);
            
            var font:Font = application.bootstrap.getFont("univers");
            for (var i:uint=0; i<Glyphs.XTRA_GLYPHS.length; i++)
            {
                    
                var p:GlyphPage = new GlyphPage(_glyphs,font);
                p.value = Glyphs.XTRA_GLYPHS[i];
                p.addEventListener(GlyphDialog.SELECT_GLYPH, onBubbleEvent);
                
                var pp:Link = new Link(_tabs);
//              pp.fontStyle = PosteraFont.SMALL_NAV;
                pp.text = _labels[i].toUpperCase();
                pp.userObject = i;
            }
        }
        
        
        private function on_cancel(e:ComponentEvent):void
        {
            application.hideTakeOver();
        }
        
        private function on_click_page(e:ComponentEvent):void
        {
            _glyphs.showPage(_tabs.selected.userObject);
            _glyphs.render();
        }
        
    }
}