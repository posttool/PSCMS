package 
{
    import com.pagesociety.util.BootstrapImpl;
    import com.pagesociety.util.ClassLoaderEvent;
    
    import flash.text.TextField;
    
    [SWF(backgroundColor=0xffffff, frameRate=30)]
    public class Bootstrap extends BootstrapImpl
    {
        public static const VERSION:uint = 2525;   
        
    
//      protected var _tf:TextField;
        public function Bootstrap()
        {
            super();


            
//          _tf = Logger.getTextField("_sans",7,1,0);
//          _tf.text = "";
//          _tf.x = 10;
//          _progress.addChild(_tf);
//          _progress.alpha = .7;

//          var d:DisplayObject = new LOGO();
//          d.x = 10;
//          d.y = 20;
//          _progress.addChild(d);
        }
        
        override protected function on_load_progress(e:ClassLoaderEvent):void
        {
            var pc:Number = e.loader.loadProgress;
            var w:Number = 150;
            var h:Number = 3;
            var c:uint = 0x333333;
            _progress.graphics.clear();
            _progress.graphics.beginFill(0,.3);
            _progress.graphics.drawRect(10,16,w,h);
            _progress.graphics.endFill();
            _progress.graphics.beginFill(c,1);
            _progress.graphics.drawRect(10,16,w*pc,h);
            _progress.graphics.endFill();
        }
//      
//      override public function loadText(url:String, on_complete:Function):void
//      {
//          set_tf( "Loading properties" );
//          super.loadText(url,on_complete);
//      }
//      
//      override public function loadFonts(f:Array, on_complete:Function, on_each:Function=null):void
//      {
//          set_tf( "Loading fonts" );
//          super.loadFonts(f,on_complete,on_each);
//      }
//      
//      override public function load(url:String, on_complete:Function=null):void
//      {
//          set_tf( "Load "+url );
//          super.load(url,on_complete);
//      }
//      
//      private function set_tf(s:String):void
//      {
//          if (_tf!=null && s!=null)
//              _tf.text = s.toUpperCase();
//      }

    }
}