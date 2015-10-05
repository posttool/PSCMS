package com.pagesociety.web.module
{
    import com.pagesociety.persistence.Entity;
    import com.pagesociety.web.ModuleConnection;
    import com.pagesociety.web.amf.AmfLong;
    
    public class SiteManager extends ModuleConnection
    {
        public static var MODULE_NAME:String = "SiteManager";
        
        public static const KEY_SITEMANAGER_METAINFO_ENTITY_DEFINITIONS             :String = "entity_definitions";
        public static const KEY_SITEMANAGER_METAINFO_ENTITY_INDICES                 :String = "entity_indices";
        public static const KEY_SITEMANAGER_METAINFO_ADDITIONAL_LANGUAGES           :String = "additional_languages";
        public static const KEY_SITEMANAGER_METAINFO_MULTILINGUAL_ENTITIES          :String = "multilingual_entities";
        public static const KEY_SITEMANAGER_METAINFO_MULTILINGUAL_ENTITY_FIELD_MAP  :String = "multilingual_entity_field_map";
        public static const KEY_SITEMANAGER_METAINFO_PUBLISHABLE_ENTITIES           :String = "publishable_entities";
        public static const KEY_SITEMANAGER_METAINFO_PAGE_TYPE_ENTITIES             :String = "page_type_entities";


        public static const PUBLISHABLE_ENTITY_PUBLICATION_STATUS_FIELD_NAME        :String = "_publication_status";
        public static const SITE_MANAGER_STATUS_UNPUBLISHED                         :uint   = 0x00;
        public static const SITE_MANAGER_STATUS_PUBLISHED                           :uint   = 0x01;
        
        
        public static var METHOD_GETPAGETYPEDEFINITIONS:String = MODULE_NAME+"/CreatePageInstance";
        public static function CreatePageInstance(id:AmfLong, type:String, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_GETPAGETYPEDEFINITIONS, [id,type], on_complete, on_error);      
        }
        
        public static var METHOD_DELETEPAGEINSTANCE:String = MODULE_NAME+"/DeletePageInstance";
        public static function DeletePageInstance(id:AmfLong, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_DELETEPAGEINSTANCE, [id], on_complete, on_error);       
        }
        
        public static var METHOD_GETSITEMANAGERMETAINFO:String = MODULE_NAME+"/GetSiteManagerMetaInfo";
        public static function GetSiteManagerMetaInfo(on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_GETSITEMANAGERMETAINFO, [], on_complete, on_error);     
        }
        
        public static var METHOD_GETSITEMENU:String = MODULE_NAME+"/GetSiteMenu";
        public static function GetSiteMenu(on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_GETSITEMENU, [], on_complete, on_error);        
        }
        
        public static var METHOD_GETSITEROOT:String = MODULE_NAME+"/GetSiteRoot";
        public static function GetSiteRoot(on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_GETSITEROOT, [], on_complete, on_error);        
        }
        
        public static var METHOD_REPARENTPAGEINSTANCE:String = MODULE_NAME+"/ReparentPageInstance";
        public static function ReparentPageInstance(pid:AmfLong, id:AmfLong, child_index:int, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_REPARENTPAGEINSTANCE, [pid, id, child_index], on_complete, on_error);       
        }
        
        private static var META_INFO:SiteManagerMetaInfo;
        public static function SetSiteManagerMetaInfo(info:Object):void
        {
            META_INFO = new SiteManagerMetaInfo(info);

        }
        
        public static function get MetaInfo():SiteManagerMetaInfo
        {
            return META_INFO;
        }
        
    }
}