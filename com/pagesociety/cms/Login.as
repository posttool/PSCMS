package com.pagesociety.cms
{
    import com.adobe.crypto.MD5;
    import com.pagesociety.ux.component.Button;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.Gap;
    import com.pagesociety.ux.component.text.Input;
    import com.pagesociety.ux.component.text.Label;
    import com.pagesociety.ux.event.ComponentEvent;
    import com.pagesociety.ux.event.InputEvent;
    import com.pagesociety.ux.layout.FlowLayout;

    [Event(type="com.pagesociety.cms.Login", name="do_login")]
    public class Login extends Container
    {
        public static const DO_LOGIN:String = "do_login";
        
        private var _email:Input;
        private var _pass:Input;
        
        public function Login(parent:Container)
        {
            super(parent);
            layout = new FlowLayout(FlowLayout.TOP_TO_BOTTOM);
            styleName = "Login";
            
            var l:Label = new Label(this);
            l.text = "LOG IN";
            l.fontStyle = "black_big";
            
            new Gap(this,10);
            
            l = new Label(this);
            l.text = "NAME";
            l.fontStyle = "black_small";
            
            _email = new Input(this);
            _email.value = "";
            
            new Gap(this,5);

            l = new Label(this);
            l.text = "PASSWORD";
            l.fontStyle = "black_small";
            
            _pass = new Input(this);
            _pass.password = true;
            _pass.value = "";
            _pass.addEventListener(InputEvent.PRESS_ENTER_KEY, do_submit);
            
            new Gap(this,10);

            var b:Button = new Button(this);
            b.label = "SUBMIT";
            b.addEventListener(ComponentEvent.CLICK, do_submit);
        }
        
        private function do_submit(e:ComponentEvent):void
        {
            dispatchEvent(new ComponentEvent(ComponentEvent.CHANGE_VALUE, this));
            dispatchComponentEvent(DO_LOGIN,this);
        }
        
        public function get email():String
        {
            return _email.value as String;
        }
        
        public function set email(s:String):void
        {
             _email.value = s;
        }
        
        public function get password():String
        {
            return MD5.hash(_pass.value as String);
        }
        
        public function set password(s:String):void
        {
            _pass.value = s;
        }
    }
}