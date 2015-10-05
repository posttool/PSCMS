package com.pagesociety.cms.browser
{
    import com.pagesociety.cms.CmsEvent;
    import com.pagesociety.cms.view.EntityView2;
    import com.pagesociety.cms.view.VV;
    import com.pagesociety.persistence.Entity;
    import com.pagesociety.persistence.EntityDefinition;
    import com.pagesociety.persistence.EntityIndex;
    import com.pagesociety.persistence.Query;
    import com.pagesociety.ux.Margin;
    import com.pagesociety.ux.component.Component;
    import com.pagesociety.ux.component.Container;
    import com.pagesociety.ux.component.dim.Guide;
    import com.pagesociety.ux.component.text.Input;
    import com.pagesociety.ux.component.text.Label;
    import com.pagesociety.ux.component.text.Link;
    import com.pagesociety.ux.container.List;
    import com.pagesociety.ux.container.Pager;
    import com.pagesociety.ux.container.PagingList;
    import com.pagesociety.ux.container.PopUpStyled;
    import com.pagesociety.ux.event.ComponentEvent;
    import com.pagesociety.ux.event.InputEvent;
    import com.pagesociety.ux.layout.FlowLayout;
    import com.pagesociety.ux.layout.GridLayout;
    import com.pagesociety.web.module.CmsModule;
    
    import flash.net.SharedObject;

    public class EntityBrowserOrderedPaged extends List
    {
        private var _def:EntityDefinition;
        private var _ft_index:EntityIndex;
        private var _results:Array;
        private var _fill_deep:Boolean = false;
        
        private var _grid:GridLayout;
        private var _title:Label;
        private var _pager:Pager;
        private var _order_by:PopUpStyled;
        private var _asc_desc:Link;
        private var _free_text:Input;
        private var _search_label:Label;
        
        private var _ascending_text:String = "ascending";
        private var _descending_text:String = "descending"; 
        
        private var _browser_prefs:SharedObject;

        public function EntityBrowserOrderedPaged(parent:Container, cell_width:Number = 350, cell_height:Number = 20, show_title:Boolean = true)
        {
            super(parent, PagingList.LEFT_RIGHT);
            _browser_prefs = SharedObject.getLocal("browser_prefs");

            _title = new Label(this);
            _title.fontStyle = "black_title";
            _title.x = 10;
            _title.y = 0;
            _title.visible = show_title;
            
            _mid.layout = _grid = new GridLayout(GridLayout.GROW_VERTICALLY, { cellWidth: cell_width, cellHeight: cell_height, margin: new Margin(0,5,8,0)});
            _mid.x = 12;
            _mid.widthDelta = -24;
            _mid.y = show_title ? 40: 8;
            _mid.heightDelta = -_mid.y - 50;
            
            //addEventListener(ComponentEvent.DOUBLE_CLICK, on_dbl_click);
            addEventListener(CmsEvent.DELETE_ENTITY, on_delete);
            
            cellRenderer =  view_entity_in_browser;
            
            _pagers.x = 10;
            _pagers.height = 35;
            _pagers.alignY(Guide.BOTTOM);
            
            _pager = new Pager(_pagers);
            _pager.addEventListener(ComponentEvent.CHANGE_VALUE, on_click_page);

            _controls.x = 10;
            _controls.alignY(Guide.BOTTOM,-10);
            _controls.height = 25;
            _controls.layout = new FlowLayout(FlowLayout.LEFT_TO_RIGHT, {margin: new Margin(0,10,0,0)});

            _search_label = new Label(_controls);
            _search_label.text = "search";
            
            _free_text = new Input(_controls);
            _free_text.addEventListener(InputEvent.PRESS_ENTER_KEY, on_submit_free_text);
            _free_text.visible = false;
            _free_text.width = 150;
            _free_text.height = 18;
            _free_text.fontStyle = "black_label";

            var order_by_label:Label = new Label(_controls);
            order_by_label.text = "     order by";

            _order_by = new PopUpStyled(_controls);
            _order_by.visible = false;
            _order_by.addEventListener(ComponentEvent.CHANGE_VALUE, select_entities);
            _order_by.width = 150;
            
            _asc_desc = new Link(_controls);
            _asc_desc.text = _ascending_text;
            _asc_desc.addEventListener(ComponentEvent.CLICK, toggle_asc_desc);
            _asc_desc.visible = false;
            
        }
        
        public function set cellHeight(h:Number):void
        {
            _grid.cellHeight = h;
        }
        public function set cellWidth(w:Number):void
        {
            _grid.cellWidth = w;
        }
        
        public function set title(s:String):void
        {
            _title.text = s;
        }
        
        public function set fillDeep(b:Boolean):void
        {
            _fill_deep = b;
        }
        
        private function on_dbl_click(e:ComponentEvent):void
        {
            dispatchEvent(new CmsEvent(CmsEvent.EDIT_ENTITY, this, selected));
        }
        
        private function on_click_page(e:ComponentEvent):void
        {
            page = _pager.page;
            selectEntities(null);
        }
        
        private function on_delete(e:ComponentEvent):void
        {
            delete_entity(e.data);
        }
        
        override public function render():void
        {
            super.render();         
        }
        
        override protected function update_ui():void
        {
            super.update_ui();
            if(totalCount<itemsPerPage)
            {
                _pager.visible      = false;
            }
            else
            {
                _pager.visible      = true;
                _pager.pageSize     = itemsPerPage;
                _pager.totalCount   = totalCount;
                _pager.label = totalCount+" total, page";
                //how many columns in layout
                _grid.layout();
                _pager.render();
                var cw:Number = _grid.cellWidth+_grid.margin.left+_grid.margin.right;
                var ci:uint = _grid.columns;
                while (cw*ci+_pager.width>width)
                    ci--;
                _pager.x = cw*ci;
            }
        }
        
        private function toggle_asc_desc(e:ComponentEvent):void
        {
            var b:Boolean = _asc_desc.text == _ascending_text;
            if (b)
                _asc_desc.text = _descending_text;
            else
                _asc_desc.text = _ascending_text;
            _asc_desc.render();
            select_entities(e);
        }
        
        private function on_submit_free_text(e:ComponentEvent):void
        {
            page = 0;
            _pager.page = 0;
            select_entities(e);
        }
        
        private function select_entities(e:ComponentEvent):void
        {
            page = 0;
            _pager.page = 0;
            selectEntities(e.component.userObject as EntityDefinition);
        }
        
        private function set_def(def:EntityDefinition):void
        {
            _def = def;
            _ft_index = get_ft_index(_def);
            _order_by.clear();
            for (var i:uint=0; i<_def.fields.length; i++)
                _order_by.addOption(_def.fields[i].name);
            var def_pref:Array = _browser_prefs.data[_def.name];
            if (def_pref!=null)
            {
                _order_by.selectedIndex = def_pref[0];
                page = def_pref[2];
                _pager.page = def_pref[2];
            }
            else
            {
                _order_by.selectedIndex = 2;
                page = 0;
                _pager.page = 0;
            }
            
            _free_text.value = "";
            _free_text.visible = has_ft_index;
            _search_label.visible = has_ft_index;
        }
        
        public function selectEntities(def:EntityDefinition):void
        {
            if (_def != null)
            {
                var b:Boolean = _asc_desc.text == _ascending_text;
                _browser_prefs.data[_def.name] = [_order_by.selectedIndex, b, page, itemsPerPage ];
                _browser_prefs.flush();
            }
            
            if (def!=null)
                set_def(def);
            
            clear();
            _controls.visible = false;
            render();
            
            if (_def==null)
                return;
            
            var ind_obj:Array = null;
            if (has_ft_index && _free_text.value != "")
            {
                ind_obj  = new Array();
                ind_obj.push(_ft_index.name);
                ind_obj.push(Query.FREETEXT_CONTAINS_PHRASE);
                ind_obj.push(_free_text.value);

            }
            do_browse(_def.name, ind_obj, _order_by.value as String, b, offset, itemsPerPage, _fill_deep, on_results, application.error);

        }
        
        protected function do_browse(defname:String, query_list:Array, order_by:String, b:Boolean, offset:uint, itemsPerPage:uint, fill_deep:Boolean, on_results:Function, on_error:Function):void
        {
            if(query_list != null)
                CmsModule.BrowseEntities0(defname, query_list, order_by, b, offset, itemsPerPage, fill_deep, on_results, application.error);
            else
                CmsModule.BrowseEntities1(defname, order_by, b, offset, itemsPerPage, fill_deep, on_results, application.error);
        }
        
        
        private function get has_ft_index():Boolean
        {
            return _ft_index != null;
        }
        
        private function get_ft_index(def:EntityDefinition):EntityIndex
        {
            for (var i:uint=0; i<def.indices.length; i++)
            { 
                var ind:EntityIndex = def.indices[i];
                if (ind.type==EntityIndex.TYPE_FREETEXT_INDEX || ind.type==EntityIndex.TYPE_MULTI_FIELD_FREETEXT_INDEX)
                    return ind;
            }
            return null;
        }
        
        protected function on_results(pqr:Object):void
        {
            _controls.visible = true;
            var vis:Boolean = pqr.totalCount!=0;
            _order_by.visible = vis;
            _asc_desc.visible = vis;
            results = pqr;
            render();
            dispatchEvent(new ComponentEvent(ComponentEvent.CHANGE_VALUE, this));
        } 
    
        
        
        // VIEW FOR BROWSER
        private function view_entity_in_browser(p:Container,e:Entity):Component
        {
            var es:EntityView2 = new EntityView2(p, e);
            es.height = _grid.cellHeight;
            es.showImage();
            return es;
        }
        
        override protected function create_cell(v:Object):Component/*IListItem*/
        {
            var c:Component = super.create_cell(v);
            c.addEventListener(CmsEvent.DELETE_ENTITY, onBubbleEvent);
            c.addEventListener(ComponentEvent.DOUBLE_CLICK, on_dbl_click);
            return c;
        }
        
        public function get entityDefintion():EntityDefinition
        {
            return _def;
        }
        
        
        
        // delete
        
        private var _to_delete:Entity;
        private function delete_entity(e:Entity):void
        {
            _to_delete = e;
            var c:Container = VV.confirm(this,"Do you really want to delete this record?",
                ["yes, i do", "no, i do not"],
                [confirm_delete_entity, cancel_delete_entity]);
            
            application.pushTakeOver(c, cancel_delete_entity);
        }
        
        private function confirm_delete_entity(c:ComponentEvent):void
        { 
            do_delete(_to_delete,on_delete_entity_complete,application.error);
        }
        
        protected function do_delete(_to_delete:Entity,on_delete_complete:Function,on_error:Function):void
        {
    
            CmsModule.DeleteEntity(_to_delete,on_delete_complete, on_error);            
        }
        
        private function on_delete_entity_complete(e:Entity):void
        {
            application.hideTakeOver(); 
            selectEntities(null);       
        }
        
        private function cancel_delete_entity(c:ComponentEvent):void
        {
            application.hideTakeOver();
            selected = [];
            render();       
        }

        
        
    }
}