package com.pagesociety.cms.form
{
    import com.pagesociety.persistence.FieldDefinition;
    import com.pagesociety.ux.Margin;
    import com.pagesociety.ux.component.Component;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.container.Browser;
    import com.pagesociety.ux.component.form.FieldEditor;
    import com.pagesociety.ux.component.text.Label;
    import com.pagesociety.ux.component.text.Link;
    import com.pagesociety.ux.event.BrowserEvent;
    import com.pagesociety.ux.event.ComponentEvent;
    
    [Event(type="com.pagesociety.ux.event.ComponentEvent",      name="change_value")]
    [Event(type="com.pagesociety.ux.event.BrowserEvent",        name="double_click")]
    [Event(type="com.pagesociety.cms.form.LinkableReferenceEditor",     name="click_add")]
    [Event(type="com.pagesociety.cms.form.LinkableReferenceEditor",     name="click_link")]
    
    public class LinkableReferenceEditor extends FieldEditor
    {
        public static var CLICK_ADD:String = "ref_editor_click_add";
        public static var CLICK_LINK:String = "ref_editor_click_link";
        
        public var add:Link;
        public var link:Link;
        public var browser:Browser;
        
        public function LinkableReferenceEditor(parent:Container,f:FieldDefinition)
        {
            super(parent,f);

            add = new Link(this);
            add.fontStyle = "black_small";
            add.text = "+ CREATE";
            add.align = Label.ALIGN_RIGHT;
            add.x = -60;
            add.addEventListener(ComponentEvent.CLICK, on_click_add);
        
            link = new Link(this);
            link.fontStyle = "black_small";
            link.text = "> LINK";
            link.align = Label.ALIGN_RIGHT;
            link.x = -5;
            link.addEventListener(ComponentEvent.CLICK, on_click_link);
        }
        
        override public function createEditorComponent():Component
        {
            var b:Boolean = field.referenceType=="Image";
            browser = new Browser(this);
            browser.id = field.name;
            browser.height = b?190:57;
            browser.reorderable = true;
            browser.deletable = true;
            browser.allowsDuplicates = false;
            browser.addDropTargetForChildren(browser);
            browser.addEventListener(ComponentEvent.CHANGE_VALUE, onBubbleEvent);
            browser.addEventListener(BrowserEvent.DOUBLE_CLICK, onBubbleEvent);
            
            return browser;
        }
        
        private function on_click_add(e:ComponentEvent):void
        {
            dispatchEvent(new ComponentEvent(CLICK_ADD, this));
        }
        
        private function on_click_link(e:ComponentEvent):void
        {
            dispatchEvent(new ComponentEvent(CLICK_LINK, this));
        }
    }
}