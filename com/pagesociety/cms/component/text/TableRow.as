package com.pagesociety.cms.component.text
{
    import com.pagesociety.ux.component.Component;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.button.DeleteButton;
    import com.pagesociety.ux.component.text.Input;
    import com.pagesociety.ux.event.ComponentEvent;
    import com.pagesociety.ux.layout.FlowLayout;
    
    import flash.display.Graphics;
    import flash.display.Sprite;
    
    [Event(type="com.pagesociety.cms.component.text.TableRow", name="delete_row")]
    public class TableRow extends Container
    {
        public static const DELETE_ROW:String = "delete_row";   
        private var _widths:Array;
        private var _fs:String;
        
        public function TableRow(parent:Container)
        {
            super(parent);
            layout = new FlowLayout(FlowLayout.LEFT_TO_RIGHT);
            height = 22;
            
//          decorator.addChild(decorator.dragArea);
//          var g:Graphics = decorator.dragArea.graphics;
//          g.beginFill(0,0);
//          g.drawRect(0,0,20,20);
//          g.endFill();
        }
        
        public function set widths(w:Array):void
        {
            _widths = w;
        }
        
        public function set inputStyle(fs:String):void
        {
            _fs = fs;
        }
        
        public function set value(o:Object):void
        {
            clear();
            var p:Component = new Component(this);
            p.width = 10;
            p.backgroundVisible = true;
            p.backgroundColor = 0x999999;
            p.alpha = .3;
            decorator.dragArea = p.decorator;
            for (var i:uint=0; i<o.length; i++)
            {
                var t:Input = new Input(this);
                t.value = o[i];
                t.styleName = _fs;
                t.height = 22;
                if (_widths[i]!=null)
                    t.width = _widths[i];
            }
            var d:DeleteButton = new DeleteButton(this);
            //d.showCircle = false;
            //d.xColorNormal = PosteraColor.GRAY_3;
            //d.xColorOver = PosteraColor.BRIGHT;
            d.addEventListener(ComponentEvent.CLICK, on_click_delete);
        }
        
        private function on_click_delete(e:ComponentEvent):void
        {
            dispatchComponentEvent(DELETE_ROW, this);
        }           
        
        public function get value():Object
        {
            var a:Array = [];
            for (var i:uint=0; i<children.length; i++)
            {
                if (children[i].hasOwnProperty("value"))
                    a.push( children[i].value );
            }
            return a;
        }
    }
}