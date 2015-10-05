package com.pagesociety.cms
{
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.dim.Guide;
    
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    public class NetworkIndicator extends Container
    {
        private var _t:Timer;
        private var _a:Number;
        private var _d:Number;
        public function NetworkIndicator(parent:Container, index:int=-1)
        {
            super(parent, index);
            _t = new Timer(30);
            _t.addEventListener(TimerEvent.TIMER, on_tick);
            _a = 0;
            _d = .03;

            backgroundVisible = true;
            backgroundColor = Constants.COLOR_WHITE;
            
        
//          alignX(Guide.RIGHT, -15);
//          y = 15;
        }
        
        private function on_tick(e:TimerEvent):void
        {
            _a+=_d;
            if (_a>.5 || _a<0)
                _d = -_d;
            render();
        }
        
        override public function set visible(b:Boolean):void
        {
            if (b)
            {
                cancel_execute_late("xxx");
                _t.start();
            }
            else
            {
                execute_later("xxx",on_stop, 300);
            }
        }
        private function on_stop():void
        {
            _a=0;
            _t.stop();
            render();
        }
        
        override public function render():void
        {
            backgroundAlpha = _a;
            backgroundVisible = (_a!=0);
            super.render();
        }
        

        
    }
}