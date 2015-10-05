package com.pagesociety.cms.component
{
    import com.pagesociety.cms.config.CmsConfigEntityElement;
    import com.pagesociety.ux.IEditor;
    import com.pagesociety.ux.component.Component;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.Gap;
    import com.pagesociety.ux.component.text.Input;
    import com.pagesociety.ux.event.ComponentEvent;
    import com.pagesociety.ux.layout.FlowLayout;

    public class IntsEditor extends Container implements IEditor
    {
        private var _ints:Array;
        
        public function IntsEditor(parent:Container)
        {
            super(parent);
            layout = new FlowLayout(FlowLayout.LEFT_TO_RIGHT);
            height = 30;
        }
        
        public function set value(o:Object):void
        {
            // test that o is an array on ints
            _ints = o as Array;
            update_ui();
        }
        
        private function update_ui():void
        {
            clear();
            if (_ints==null)
                return;
            for (var i:uint=0; i<_ints.length; i++)
            {
                var p:Input = new Input(this);
                p.restrict = "0-9";
                p.value = _ints[i];
                p.addEventListener(ComponentEvent.CHANGE_VALUE, onBubbleEvent);
                if (i!=_ints.length-1)
                    new Gap(this, 8);
            }
        }
        
        public function get value():Object
        {
            var c:uint=0;
            for (var i:uint=0; i<children.length; i++)
            {
                if (children[i] is IEditor)
                {
                    _ints[c] = parseInt(children[i].value);
                    c++;
                }
            }
            return _ints;
        }
        
        public function get dirty():Boolean
        {
            for (var i:uint=0; i<children.length; i++)
                if (children[i] is IEditor && children[i].dirty)
                    return true;
            return false;
        }
        
        public function set dirty(b:Boolean):void
        {
            for (var i:uint=0; i<children.length; i++)
                if (children[i] is IEditor)
                    children[i].dirty = b;
        }
        
        
    }
}