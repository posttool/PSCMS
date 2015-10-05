package com.pagesociety.cms.component
{
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.layout.FlowLayout;
    
    public class Row extends Container
    {
        public function Row(parent:Container, index:int=-1)
        {
            super(parent, index);
            layout = new FlowLayout(FlowLayout.LEFT_TO_RIGHT);
            layout.margin.right = 10;
        }
        
        override public function get height():Number
        {
            var max:Number = 0;
            for (var i:uint=0; i<children.length; i++)
            {
                var h:Number = children[i].height;
                max = Math.max(h,max);
            }
            return max;
        }
        
        override public function render():void
        {
            widthDelta = layout.margin.right;
            super.render();
        }
        
//      override public function get width():Number
//      {
//          return layout.calculateWidth();
//      }
    }
}