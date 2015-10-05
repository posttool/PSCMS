package com.pagesociety.cms.component
{
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.PopUpMenu;
    
    public class BooleanEditor extends PopUpMenu
    {
        public function BooleanEditor(parent:Container)
        {
            super(parent, PopUpMenu.TYPE_SCROLL_BAR);
            button.label = "Choose...";
            addOption("yes");
            addOption("no");
        }
        
        override public function get value():Object
        {
            return selectedIndex == 0;
        }
        
        override public function set value(o:Object):void
        {
            if (o)
                selectedIndex = 0;
            else
                selectedIndex = 1;
        }
        
    }
}