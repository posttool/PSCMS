package com.pagesociety.cms.config
{
    import com.pagesociety.cms.component.CheckboxEditor;
    import com.pagesociety.cms.component.DateEditor;
    import com.pagesociety.cms.component.DoubleEditor;
    import com.pagesociety.cms.component.FloatEditor;
    import com.pagesociety.cms.component.IntEditor;
    import com.pagesociety.cms.component.IntsEditor;
    import com.pagesociety.cms.component.LongEditor;
    import com.pagesociety.cms.component.PopUpMenuEditor;
    import com.pagesociety.cms.component.RadioGroupEditor;
    import com.pagesociety.cms.component.reference.XRefArrayEditor;
    import com.pagesociety.cms.component.reference.XRefEditor;
    import com.pagesociety.cms.component.reference.XResArrayEditor;
    import com.pagesociety.cms.component.reference.XResEditor;
    import com.pagesociety.cms.component.text.ReadOnlyEditor;
    import com.pagesociety.cms.component.text.SimpleRichTextEditor;
    import com.pagesociety.cms.component.text.StringArrayEditor;
    import com.pagesociety.cms.component.text.StringEditor;
    import com.pagesociety.cms.form.EntityForm;
    import com.pagesociety.cms.form.ResourceForm;

    public class CmsComponents
    {
        public static const STD_IMPORTS:Object = 
        {
            "Checkbox"              : CheckboxEditor,
            "BooleanEditor"         : CheckboxEditor,
            "RadioGroup"            : RadioGroupEditor,
            "IntEditor"             : IntEditor,
            "IntsEditor"            : IntsEditor,
            "LongEditor"            : LongEditor,
            "DoubleEditor"          : DoubleEditor,
            "FloatEditor"           : FloatEditor,
            "ReadOnly"              : ReadOnlyEditor,
            "PopUpEditor"           : PopUpMenuEditor,
            "StringEditor"          : StringEditor,
            "StringArrayEditor"     : StringArrayEditor,
            "RichTextEditor"        : SimpleRichTextEditor,
            "DateEditor"            : DateEditor,
            "ReferenceEditor"       : XRefEditor,
            "ReferenceArrayEditor"  : XRefArrayEditor,
            "ResourceEditor"        : XResEditor,
            "ResourceArrayEditor"   : XResArrayEditor,
            "DefaultEditor"         : EntityForm,
            "ResourceForm"          : ResourceForm
            
        }
    }
}