package com.pagesociety.cms.component.text
{
    import com.pagesociety.cms.component.MultiEditor;
    import com.pagesociety.cms.config.CmsConfigEntityElement;
    import com.pagesociety.ux.IEditor;
    import com.pagesociety.ux.component.Component;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.Gap;
    import com.pagesociety.ux.component.text.Input;
    import com.pagesociety.ux.event.ComponentEvent;
    import com.pagesociety.ux.layout.FlowLayout;

    public class StringsEditor extends MultiEditor implements IEditor
    {
        private var _strings:Array;
        private var _bindings:Array;
        
        public function StringsEditor(parent:Container)
        {
            super(parent);
            layout = new FlowLayout(FlowLayout.LEFT_TO_RIGHT);
            height = 30;
        }
        
        override public function set value(o:Object):void
        {
            // test that o is an array on ints
            _strings = o as Array;
            update_ui();
        }
        
        private function update_ui():void
        {
            _bindings = new Array();
            clear();
            if (_strings==null)
                return;
            for (var i:uint=0; i<_strings.length; i++)
            {
                var p:Input = new Input(this);
                p.value = _strings[i];
                p.addEventListener(ComponentEvent.CHANGE_VALUE, onBubbleEvent);
                _bindings.push(p);
                if (i!=_strings.length-1)
                    new Gap(this, 8);
            }
        }
        
        override public function get bindings():Array
        {
            return _bindings;
        }
        
    }
}