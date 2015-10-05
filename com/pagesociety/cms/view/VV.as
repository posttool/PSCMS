package com.pagesociety.cms.view
{
    import com.pagesociety.persistence.Entity;
    import com.pagesociety.persistence.EntityDefinition;
    import com.pagesociety.persistence.FieldDefinition;
    import com.pagesociety.persistence.Types;
    import com.pagesociety.ux.Margin;
    import com.pagesociety.ux.component.Button;
    import com.pagesociety.ux.component.Component;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.text.Label;
    import com.pagesociety.ux.event.ComponentEvent;
    import com.pagesociety.ux.layout.FlowLayout;
    
    public class VV
    {
        
        

        public static function simple0(p:Container, e:Entity):Component
        {
            return new EntityView0(p, e);
        }
//      
//      public static function simple1(parent:Container, e:Entity, masked_fields:Array=null):Component
//      {
//          if (e==null)
//              return null;
//              
//          return new EntitySimple1(parent,e);
//      }
        
        public static var SYS_FIELDS:Array = [ "date_created", "reverse_date_created", "last_modified", "reverse_last_modified", "creator", "id" ];
        public static function describe(e:Entity, show_id:Boolean=true, masked_fields:Array=null):String
        {
            var s:String = show_id?e.id.stringValue+"\n":"";
            var p:String;
            var f:FieldDefinition;
            var o:Object;
            if (e.definition!=null)
            {
                for (var i:uint=0; i<e.definition.fields.length; i++)
                {
                    f = e.definition.fields[i];
                    if (f.baseType==Types.TYPE_REFERENCE)
                        continue;
                    p = f.name;
                    if (masked_fields!=null && masked_fields.indexOf(p)!=-1)
                        continue;
                    o = e.attributes[p];
                    if (o == null)
                        continue;
                    if (o is String )
                    {
                        if (o == "" || o.indexOf("<")!=-1)
                            continue;
                        s+= o+"\n";
                        continue; 
                    }
                    if (o is Number || o is int)
                    {
                        s+= o+"\n";
                        continue; 
                    }
                    if (o is Date)
                    {
    //                  var d:Date =  o as Date;
    //                  if (isNaN(d.fullYear))
    //                      continue;
    //                  s += d.month+"-"+d.day+"-"+d.fullYear+"\n";;
                        continue;
                    }
                    if (o is Entity)
                        continue;
                    if (o is Array)
                        continue;
                }
            }
            else
            {
                for (p in e.attributes)
                {
                    s += e.attributes[p]+"\n";
                }
            }
            
            if (s=="")
            {
                trace("s is empty");
            }
            
            return s;
        }
        
        
        
        
        
        

        
        
        public static function confirm(parent:Container, msg:String, options:Array, actions:Array):Container
        {
            var c:Container = new Container(parent);
            
            c.backgroundVisible = true;
            c.backgroundColor = 0xFFFFFF;
            c.backgroundAlpha = .9;
            c.width = 500;
            c.height = 200;
            c.backgroundShadowSize = 11;
            c.backgroundShadowStrength = .6;
            
            var l:Label = new Label(c);
            l.text = msg;
            l.fontStyle = "black_big";
            l.multiline = true;
            l.x = 10;
            l.y = 10;
            l.height = 60;
            
            var h:Container = new Container(c);
            h.layout = new FlowLayout(FlowLayout.LEFT_TO_RIGHT, {margin:new Margin(0,15,0,0)});
            h.x = 15;
            h.y = 160;
            h.decorator.background.visible = false;
            
            for (var i:uint=0; i<options.length; i++)
            {
                var b:Button = new Button(h);
                b.backgroundBorderThickness = 2;
                b.cornerRadius = 0;
                b.label = options[i];
                b.fontStyle = "black_big";
                b.addEventListener(ComponentEvent.CLICK, actions[i]);
            }
            return c;
        }
        

    }
    
    
}