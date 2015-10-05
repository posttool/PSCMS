package com.pagesociety.cms.component.text
{
    import com.pagesociety.ux.IEditor;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.text.Input;
    import com.pagesociety.ux.event.ComponentEvent;
    
    public class StringEditor extends Input implements IEditor
    {
        public function StringEditor(parent:Container)
        {
            super(parent);
        }
        
    }
}