package com.pagesociety.cms.sitemap
{
    import com.pagesociety.persistence.Entity;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.TreeNode;
    import com.pagesociety.ux.component.button.DeleteButton;
    import com.pagesociety.ux.event.ComponentEvent;
    
    import flash.display.Graphics;
    
    [Event(type="com.postera.cms.components.PosteraTreeNode",name="delete_node")]
    public class CmsTreeNode extends TreeNode
    {
        public static const DELETE_NODE:String = "delete_node";
        
        private var _del:DeleteButton;
        public function CmsTreeNode(parent:Container, e:Entity)
        {
            super(parent);
            
            userObject = e;
            
            backgroundShadowSize = 6;
            backgroundShadowStrength = .2;
            
            _label.fontStyle = "black_label";
            
            _del = new DeleteButton(this);
            _del.x = -2;
            _del.y = -16;
            _del.visible = false;
            _del.addEventListener(ComponentEvent.CLICK, translateEvent(DELETE_NODE));
            add_mouse_over_default_behavior();
        }
        
        override public function set dragging(b:Boolean):void
        {
            super.dragging = b;
            alpha = b ? .3:1;
        }
        
        override public function acceptsChild(t:TreeNode):Boolean
        {
//          if (userObject.$.data.type==PosteraUserCMS.LANDINGPAGE_ENTITY && userObject.id.longValue != t.userObject.id.longValue)  
                    //&& t.entity_node.data.type==childNodes[0].entity_node.data.type
                return true;
//          else
//              return false;
        }
        
        override public function render():void
        {
            // size?
//          var sml:String = (width>150) ? "medium" : (width>80) ? "small" : "small";
//          _label.fontStyle = "."+sml+"_body";
//          if (_tnd.type==PosteraUserCMS.LANDINGPAGE_ENTITY)
//              _label.decorator.color = PosteraColor.BLACK;
//          else
//              _label.decorator.color = PosteraColor.WHITE;
            _label.x        = width*.05;
            _label.y        = height*.03;
            _label.width    = width*.85;
            _label.text     = userObject.$.data.$.menu_name;
            
            if (parentNode!=null)
                _del.visible = _over;
                
            var g:Graphics = decorator.graphics;
            g.clear();
            g.beginFill(0xff0000,0);
            g.drawRect(0,-17,width,height+17);
            g.beginFill(0xffffff,.8);
            g.drawRect(0,0,width,height);
            super.render();
        }

    }
}