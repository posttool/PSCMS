package com.pagesociety.cms.component.text
{
    import com.pagesociety.util.StringUtil;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.container.SingleSelectionContainer;
    import com.pagesociety.ux.component.text.Input;
    import com.pagesociety.ux.component.text.Label;
    import com.pagesociety.ux.component.text.Link;
    import com.pagesociety.ux.event.ComponentEvent;
    import com.pagesociety.ux.event.InputEvent;
    import com.pagesociety.ux.layout.FlowLayout;

    [Event(type="com.pagesociety.ux.event.InputEvent",name="submit")]
    public class LinkDialog extends Container
    {
        private var _input:Input;
        private var _cancel:Link;
        private var _tabs:SingleSelectionContainer;
        private var _website:Link;
        private var _ftp:Link;
        private var _mail:Link;
        
        public function LinkDialog(parent:Container)
        {
            super(parent);
            width = 550;
            height = 95;
            cornerRadius = 8;
            backgroundVisible = true;
            backgroundColor = 0xeeeeee;//PosteraColor.GRAY_0;
            
            var label:Label = new Label(this);
            label.text = "LINK";
            label.x = 10;
            label.y = 10;
            
            _tabs = new SingleSelectionContainer(this);
            _tabs.layout = new FlowLayout(FlowLayout.LEFT_TO_RIGHT);
            _tabs.layout.margin.right = 7;
            _tabs.x = 401;
            _tabs.y = 10;
            _tabs.addEventListener(ComponentEvent.CHANGE_VALUE, on_click_page);
            
            _website = get_link_small(_tabs, "WEBSITE", "black_small");
            _ftp = get_link_small(_tabs, "FTP", "black_small");
            _mail = get_link_small(_tabs, "MAIL", "black_small");
            
            _tabs.select(_website);
            
            _input = new Input(this);
//          _input.styleName = PosteraStyle.LARGE_INPUT;
            _input.addEventListener(InputEvent.SUBMIT, onBubbleEvent);
            _input.x = 10;
            _input.y = 30;
            _input.widthDelta = -27;
            
            _cancel = get_link_small(this, "CLOSE");
            _cancel.addEventListener(ComponentEvent.CLICK, on_cancel);
            _cancel.x = width - 60;
            _cancel.y = height - 18;
        }
        
        
        
        private function get_link_small(p:Container, s:String, style:String=null):Link
        {
            var l:Link = new Link(p);
            l.text = s;
            if (style!=null)
                l.fontStyle = style;
            return l;
        }
        
        public function get value():String
        {
            return _input.value as String;
        }
        
        public function set value(s:String):void
        {
            _input.value = s;
            if (StringUtil.beginsWith(s, "http"))
                _tabs.select(_website);
            else if (StringUtil.beginsWith(s, "ftp"))
                _tabs.select(_ftp);
            else if (StringUtil.beginsWith(s, "mailto"))
                _tabs.select(_mail);
            else
                _input.value = "http://"+s;
        }
        
        public function focus():void
        {
            _input.focus();
        }
        
        private function on_cancel(e:ComponentEvent):void
        {
            application.hideTakeOver();
        }
        
        private function on_click_page(e:ComponentEvent):void
        {
            var link:Link = _tabs.selected as Link;
            switch (link.text)
            {
                case "WEBSITE":
                    update_value("http://");
                    break;
                case "FTP":
                    update_value("ftp://");
                    break;
                case "MAIL":
                    update_value("mailto:");
                    break;  
            } 
        }
        
        private function update_value(s:String):void
        {
            var iv:String = _input.value as String;
            iv = trim_if_starts_with(iv, "http://");
            iv = trim_if_starts_with(iv, "ftp://");
            iv = trim_if_starts_with(iv, "mailto:");
            _input.value = s+iv;
            _input.render();
        }
        
        private function trim_if_starts_with(s:String,b:String):String
        {
            var i:int = s.indexOf(b);
            if (i==0)
                return s.substring(b.length);
            else
                return s;
        }
        
    }
}