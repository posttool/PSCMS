package com.pagesociety.cms.component.reference
{
    import com.pagesociety.cms.config.CmsConfigEntityElement;
    import com.pagesociety.persistence.Entity;
    import com.pagesociety.ux.IEditor;
    import com.pagesociety.ux.component.Component;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.container.Browser;
    import com.pagesociety.ux.component.text.Link;
    import com.pagesociety.ux.event.BrowserEvent;
    import com.pagesociety.ux.event.ComponentEvent;

    [Event(type="com.pagesociety.ux.component.form.ReferenceEditor", name="create_reference")]
    [Event(type="com.pagesociety.ux.component.form.ReferenceEditor", name="link_reference")]
    [Event(type="com.pagesociety.ux.event.BrowserEvent", name="dragging")]
    [Event(type="com.pagesociety.ux.event.BrowserEvent", name="double_click")]
    [Event(type="com.pagesociety.ux.event.BrowserEvent", name="add")]
    [Event(type="com.pagesociety.ux.event.BrowserEvent", name="remove")]
    public class ReferenceArrayEditor extends ReferenceEditor
    {
        
        public function ReferenceArrayEditor(parent:Container)
        {
            super(parent);
        }
        
        override public function set value(o:Object):void
        {
            if (o==null)
                _browser.value = [];
            else
                _browser.value = o;
            if (variableHeight)
                dispatchComponentEvent(ComponentEvent.CHANGE_SIZE, this);
        }
        
        override public function get value():Object
        {
            var v:Array = _browser.value as Array;
            if (v==null || v.length==0)
                return null;
            else
                return v;
        }
        
        public function get lastChildIndex():uint
        {
            return _browser.children.length;
        }
        
        public function like(o:Array, p:Array):Boolean
        {
            if (o==null && p==null)
                return true;
            if (o==null && p!=null)
                return false;
            if (o!=null && p==null)
                return false;
            if (o.length!=p.length)
                return false;
            for (var i:uint=0; i<o.length; i++)
            {
                if (o[i] is Entity)
                {
                    if (o[i].id.longValue != p[i].id.longValue)
                        return false;
                }
                else if (o[i] != p[i]) 
                {
                    return false;
                }
            }
            return true;
        }
        
    }
}