package com.pagesociety.cms.component.media
{
    import com.pagesociety.ux.IEditor;
    import com.pagesociety.ux.component.Component;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.Image;
    import com.pagesociety.ux.component.Progress;
    import com.pagesociety.ux.component.dim.Guide;
    import com.pagesociety.ux.component.text.Label;
    import com.pagesociety.ux.event.ResourceEvent;
    
    public class BufferIndicator extends Container 
    {
        private var _label:Label;
        private var _progress:Progress;
        
        public function BufferIndicator(parent:Container, index:int=-1)
        {
            super(parent, index);

            _progress = new Progress(this);
            _progress.color = 0xffffff;//uint(application.style.getStyleValue("small", "color"));
            _progress.alpha = .8;

            _label = new Label(this);
            _label.text = "BUFFERING";
            _label.fontStyle = "small";
            _label.alignX(Guide.CENTER);
            _label.alignY(Guide.CENTER);

        }
        
        public function set percent(p:Number):void
        {
            _progress.progress = p;
        }
        
        
    }
}