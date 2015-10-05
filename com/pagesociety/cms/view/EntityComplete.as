package com.pagesociety.cms.view
{
    import com.pagesociety.cms.Constants;
    import com.pagesociety.persistence.Entity;
    import com.pagesociety.persistence.FieldDefinition;
    import com.pagesociety.util.StringUtil;
    import com.pagesociety.ux.component.Component;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.container.ScrollingContainer;
    import com.pagesociety.ux.component.text.Label;
    import com.pagesociety.ux.layout.FlowLayout;
    import com.pagesociety.web.module.SiteManager;
    

    public class EntityComplete extends ScrollingContainer
    {
        public function EntityComplete(p:Container)
        {
            super(p);
            
            backgroundVisible           = true;
//          backgroundColor             = Constants.COLOR_LIGHT;
            backgroundAlpha             = 0;
//          backgroundShadowSize        = 14;
//          backgroundShadowStrength    = .25;
            
            layout              = new FlowLayout(FlowLayout.TOP_TO_BOTTOM);
            layout.margin.top   = 5;
            layout.margin.left  = 5;
            
            
            
        }
        
        public function set value(e:Entity):void
        {
            clear();
            setScrollVertical(0);
            if (e==null)
                return;
            var title:Label = new Label(this);
            title.fontStyle = "black_big";
            title.text = e.type+" "+e.id.longValue;
            var c:Component = new Component(this);
            c.height = 9;
            for (var i:uint=1; i<e.definition.fields.length; i++)
            {
                var f:FieldDefinition = e.definition.fields[i];
                if (StringUtil.startsWith(f.name,"_"))
                    continue;
                if (VV.SYS_FIELDS.indexOf(f.name)!=-1)
                    continue;
                if (SiteManager.MetaInfo && SiteManager.MetaInfo.isSecondaryMultilingualField(e.type,f.name))
                    continue;
                if (e.attributes[f.name]==null || e.attributes[f.name].toString()=="")
                    continue;
                var label:Label = new Label(this);
                label.widthDelta = -20;
                label.text = f.name.toUpperCase();
                label.fontStyle = "black_small";
                var value:Label = new Label(this);
                value.text = e.attributes[f.name];
                value.multiline = true;
                value.widthDelta = -20;
                c = new Component(this);
                c.height = 9;
            }

        }
        
    }
}