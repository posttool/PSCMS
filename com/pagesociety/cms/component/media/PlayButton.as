package com.pagesociety.cms.component.media
{
    import com.pagesociety.ux.component.Component;
    import com.pagesociety.ux.component.Container;
    
    public class PlayButton extends Component
    {
        public function PlayButton(parent:Container)
        {
            super(parent);
//          super(parent, new PlayIcon());
//          sprite.mouseChildren = false;
//          sprite.x = 4;
//          sprite.y = 2;
            backgroundVisible = true;
            backgroundAlpha = 0;
        }
    }
}