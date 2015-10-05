package com.pagesociety.cms.component
{
    import com.pagesociety.ux.IEditor;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.text.Input;
    import com.pagesociety.web.amf.AmfDouble;

    public class DoubleEditor extends Input implements IEditor
    {
        
        public function DoubleEditor(parent:Container)
        {
            super(parent);
            restrict = "0-9.";
        }
        
        override public function get value():Object
        {
            return new AmfDouble(parseFloat(super.value as String));
        }
        
    }
}