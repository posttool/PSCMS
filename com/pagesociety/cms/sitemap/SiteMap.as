package com.pagesociety.cms.sitemap
{
    import com.pagesociety.cms.Constants;
    import com.pagesociety.cms.Dialog;
    import com.pagesociety.persistence.Entity;
    import com.pagesociety.ux.MovingValue;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.PSlider;
    import com.pagesociety.ux.component.Slider;
    import com.pagesociety.ux.component.TreeNode;
    import com.pagesociety.ux.component.container.ScrollingContainer;
    import com.pagesociety.ux.component.dim.Guide;
    import com.pagesociety.ux.component.text.Label;
    import com.pagesociety.ux.event.BrowserEvent;
    import com.pagesociety.ux.event.ComponentEvent;
    import com.pagesociety.ux.event.DragAndDropTreeNodeEvent;
    import com.pagesociety.ux.event.TreeEvent;
    import com.pagesociety.ux.system.TreeUtil;
    import com.pagesociety.web.ErrorMessage;
    import com.pagesociety.web.module.SiteManager;
    
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    [Event(type="com.pagesociety.cms.sitemap.SiteMap", name="site_map_ready")]
    public class SiteMap extends Container 
    {
        public static var SITE_MAP_READY:String = "site_map_ready";
        
        private var _site_root:Entity;
        
        private var _site_map_editor:Container;
        private var _tree:CmsTree;
        private var _scrolling_container:ScrollingContainer;
        private var _slider_label:Label;
        private var _slider:PSlider;
        private var _page_type_selector:PageTypeSelector;
        
        // zoom constants
        private static const MIN_NODE_SIZE:uint = 20;
        private static const MAX_NODE_SIZE:uint = 200;
        private static const START_NODE_SIZE:uint = 100;
        private static const SLIDER_VALUE_KEY:String = "slider_value_key";

        
        public function SiteMap(parent:Container)
        {
            super(parent);
            
            _site_map_editor = new Container(this);
            
            _scrolling_container = new ScrollingContainer(_site_map_editor);
            _tree = new CmsTree(_scrolling_container); 
            
            _scrolling_container.addEventListener(ComponentEvent.CHANGE_VALUE, on_scroll);
            
            _tree.addEventListener(ComponentEvent.CHANGE_VALUE, on_tree_change);
            _tree.addEventListener(DragAndDropTreeNodeEvent.DROP, on_tree_drop);
            _tree.addEventListener(CmsTreeNode.DELETE_NODE, on_delete_tree_node);
            
            _slider_label = new Label(_site_map_editor);
            _slider_label.text = "ZOOM";
            _slider_label.x = 10;
            _slider_label.alignY(Guide.BOTTOM, -10);
//          _slider_label.fontStyle = PosteraFont.TINY;
            
            _slider = new PSlider(_site_map_editor, PSlider.HORIZONTAL);
            //_slider.setRange(MIN_NODE_SIZE, MAX_NODE_SIZE);
            _slider.addEventListener(ComponentEvent.CHANGE_VALUE, on_change_slider);
            _slider.x = 70;
            _slider.alignY(Guide.BOTTOM, -11);
            _slider.width = 100;
            _slider.height = 10;
            _slider.value = .2;
            _slider.backgroundColor = 0xffffff;
            _node_size.reset(_slider.getValue(MIN_NODE_SIZE,MAX_NODE_SIZE));
            
            _page_type_selector = new PageTypeSelector(this);
            _page_type_selector.addEventListener(ComponentEvent.CHANGE_VALUE, on_select_page_type);
            _page_type_selector.visible = false;
            
        }
        
        public function getData():void
        {
            blur = 18;
            render();
            // get private taxonomy
            SiteManager.GetSiteRoot(on_get_edit_tree, application.error);
        }

        private function on_get_edit_tree(root:Entity):void
        {
            blur = 0;
            _site_root  = root;
            _tree.value = _site_root;
            _page_type_selector.pageTypes = SiteManager.MetaInfo.pageTypeEntities;
            render();
            dispatchComponentEvent(SITE_MAP_READY); 
        }   

        private function on_edit_node(e:/*TreeNode*/Entity):void
        {
            edit_node(e.$.data);
            render();
        }
        
        private function edit_node(node:Entity):void
        {
            var e:Entity = node.$.data;
            application.navigate("edit",[e.type,e.id]);
        }
        
        private function do_edit_node(e:/*TreeNode*/Entity):void
        {

            var entity:Entity = e.$.data as Entity;
            //synchronize selected tree node
            var tn:TreeNode = _tree.getNodeByEntity(entity);
            if (tn==null)
                tn = _tree.rootNode;
            _tree.selectNode(tn);
            edit_node(entity);
        }
    
        
        ////
        // UI EVENT HANDLERS ///////////////////////////////////////////////////////////////
        private var _adding_node:Boolean = false;
        public function requestAddNode():void
        {
            if (_adding_node)
                return;
            _adding_node            = true;
            var parent:TreeNode     = _tree.selectedNode.parentNode;
            var type:String         = _page_type_selector.selectedType;
            SiteManager.CreatePageInstance(parent.userObject.id, type, on_create_page, application.error);
        }
        
        private function on_create_page(node:Entity):void
        {
            //trace("add_node_ok "+e.type+" "+e.id.longValue);
            //_tree.selectNode(null);
            application.hideTakeOver();
            _tree.addNode(node);
            edit_node(node);
            render();
            _adding_node = false;
        }
    
        
        private var _drop_op:DragAndDropTreeNodeEvent;
        public function requestReorderNode(drop_op:DragAndDropTreeNodeEvent):void
        {
            _drop_op = drop_op;
            var dragging:TreeNode = _tree.selectedNode;
            var drop_node:TreeNode = drop_op.dropNode;
            var drop_index:uint = drop_op.dropIndex;
            if (drop_op.subtype==DragAndDropTreeNodeEvent.DROP_ON) 
                drop_index--; // account for the plus that site_map stuffs in the tree
            //trace("move "+dragging+" to "+drop_node+" at "+drop_index);
            SiteManager.ReparentPageInstance(dragging.userObject.id, drop_node.userObject.id, drop_index, on_reparent_tree_node, application.error);
        }
        
        private function on_reparent_tree_node(o:Object):void
        {
            var dragging:TreeNode = _tree.selectedNode;
            var drop_node:TreeNode = _drop_op.dropNode;
            var drop_index:uint = _drop_op.dropIndex;
            if (_drop_op.subtype==DragAndDropTreeNodeEvent.DROP_ON) 
                drop_index--; // account for the plus that site_map stuffs in the tree
            //
            drop_node.reParentNode(dragging, drop_index);
            _tree.render();
            getData();
        }

        
        private function on_tree_change(e:TreeEvent):void
        {
            switch(e.changeType)
            {
                case TreeEvent.SELECT:
                    if (_tree.selectedNode is CmsTreeNodeAdd)
                        add_node();
                    break;
                case TreeEvent.ACTION:
                    edit_node(_tree.selectedNode.userObject);
                    break;
            }
        }
        
        private function on_tree_drop(e:DragAndDropTreeNodeEvent):void
        {
            requestReorderNode(e);
        }
        
        private function on_delete_tree_node(e:ComponentEvent):void
        {
            var p:CmsTreeNode = e.component as CmsTreeNode;
            Dialog.confirm(this,
                "Do you really want to delete "+p.userObject.$.data.type+" "+p.userObject.$.data.$.title,
                function(ce:ComponentEvent):void {},
                function(ce:ComponentEvent):void 
                {
                    SiteManager.DeletePageInstance(p.userObject.id,
                    function(o:Object):void 
                    {
                        Logger.log("DELETED TREE NODE "+o);
                        getData();
                    }, 
                    application.error);
                }
            );
            render();
        }

        private function on_select_page_type(e:ComponentEvent):void
        {
            requestAddNode();
        }
        
        public function add_node():void
        {
            application.pushTakeOver(_page_type_selector, on_cancel_add_node, Constants.TAKE_OVER_COLOR, Constants.TAKE_OVER_ALPHA, true);
        }

        private function on_cancel_add_node(e:Event):void
        {
            application.hideTakeOver();
        }
        
        
        
        
        
        
        // DISPLAY
        override public function render():void
        {
            
            _tree.setNodeSize(_node_size.value, _node_size.value*.7);
            _tree.treeLayout.layout();
            
            _scrolling_container.y = 0;
            if ( _tree.width<_scrolling_container.width)
                _tree.x = (_scrolling_container.width-_tree.width)/2;
            else
                _tree.x = 0;
            
            if (_tree.height<_scrolling_container.height)
                _tree.y = (_scrolling_container.height-_tree.height)/2;
            else
                _tree.y = 0;
            
            super.render();
        }
        
        // ANIMATION / scrolling, zooming, panning
        private var D:uint = 500;
        private var _node_size:MovingValue = new MovingValue(START_NODE_SIZE);
        private var _sh:MovingValue = new MovingValue(0);
        private var _sv:MovingValue = new MovingValue(0);
        private var _archive_width:MovingValue = new MovingValue(50);
        private function on_change_slider(e:ComponentEvent):void
        {
            // if zoom & selected, go to where the selected component will be
//          do_center(_tree.selectedNode.x, _tree.selectedNode.y);
            _node_size.value = _slider.getValue(MIN_NODE_SIZE,MAX_NODE_SIZE);
            animate([_sh,_sv,_node_size], D);
//          set_shared_object(SLIDER_VALUE_KEY, _slider.value, false);
        }
        
//      public function center(x:Number,y:Number):void
//      {
//          do_center(x,y);
//          animate( [_sh,_sv], D);
//      }
//      private function do_center(x:Number,y:Number):void
//      {
//          _sh.value = x - _scrolling_container.width/2;
//          _sv.value = y - _scrolling_container.height/2;
//      }
//      public function center_add(x:Number,y:Number):void
//      {
//          _sh.value += x;
//          _sv.value += y;
//          animate( [_sh,_sv], D);
//      }
        private function on_scroll(e:ComponentEvent):void
        {
            _sh.reset(_scrolling_container.getScrollHorizontal());
            _sv.reset(_scrolling_container.getScrollVertical());
        }
        
        
        

        
        
        //
        //
        //
        
        
        // keyboard
        
//      public function onKeyPress(e:KeyboardEvent):void {}
//      public function onKeyRelease(e:KeyboardEvent):void
//      {
//          if (e.keyCode==Keyboard.DELETE || e.keyCode==Keyboard.BACKSPACE)
//          {
//              //dispatchEvent(new PosteraEvent(PosteraEvent.REMOVE_NODE,e));  
//              //requestRemoveNode();  
//          }
//      }
    }
}