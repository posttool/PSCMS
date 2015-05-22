{"entities":
[{"buckets":
{"system":
	[{"editor":"ReadOnly","field":"creator"},
	{"editor":"ReadOnly","field":"last_modified"},
	{"editor":"ReadOnly","field":"date_created"}]},
	"editor":"DefaultEditor","entity":"*","toplevel":false},
{"buckets":
	{"left":[{"field":"title","editor":"StringEditor"},
	{"field":"description","editor":"RichTextEditor"}],
	"right":[{"field":"image","editor":"ReferenceEditor"}]},
	"name":"CollectionItem","entity":"CollectionItem","toplevel":true},
{"buckets":
	{"left":[{"field":"menu_name","editor":"StringEditor"},
	{"field":"in_nav","editor":"BooleanEditor"},
	{"field":"heading","editor":"StringEditor"},
	{"field":"intro_text","editor":"RichTextEditor"},
	{"field":"body_text","editor":"RichTextEditor"}],
	"right":[{"field":"collection_items","editor":"ReferenceArrayEditor"}]},
	"name":"CollectionPage","entity":"CollectionPage","toplevel":true},
{"buckets":{"left":[{"field":"menu_name","editor":"StringEditor"},
	{"field":"in_nav","editor":"BooleanEditor"},
	{"field":"heading","editor":"StringEditor"},
	{"field":"intro_text","editor":"RichTextEditor"},
	{"field":"body_text","editor":"RichTextEditor"},
	{"field":"layout","editor":"IntEditor"}],
	"right":[{"field":"images","editor":"ReferenceArrayEditor"}]},
	"name":"GenericPage","entity":"GenericPage","toplevel":true},
{"buckets":
	{"left":[{"field":"menu_name","editor":"StringEditor"},
	{"field":"in_nav","editor":"BooleanEditor"}],
	"right":[{"field":"news_items","editor":"ReferenceArrayEditor"}]},
	"name":"HomePage","entity":"HomePage","toplevel":true},
{"buckets":{"left":[{"field":"title","editor":"StringEditor"},
	{"field":"caption","editor":"RichTextEditor"},
	{"field":"credit","editor":"StringEditor"}],
	"right":[{"field":"resource","editor":"ResourceEditor"}]},
	"name":"Image","entity":"Image","toplevel":true},
{"buckets":{"left":[{"field":"title","editor":"StringEditor"},
	{"field":"body","editor":"RichTextEditor"},
	{"field":"link","editor":"StringEditor"}],
	"right":[{"field":"image","editor":"ReferenceEditor"}]},
	"name":"NewsItem","entity":"NewsItem","toplevel":true},
{"buckets":{"left":[{"field":"activation_token","editor":"StringEditor"},
	{"field":"activation_uid","editor":"LongEditor"}],
	"right":[]},
	"name":"OutstandingForgotPassword","entity":"OutstandingForgotPassword","toplevel":true},
	{"buckets":{"left":[{"field":"title","editor":"StringEditor"},
	{"field":"description","editor":"StringEditor"},
	{"field":"screenshot_filename","editor":"StringEditor"},
	{"field":"annotations","editor":"StringArrayEditor"}],
	"right":[]},
	"name":"PSBug","entity":"PSBug","toplevel":true},
{"buckets":{"left":[],"right":[]},"editor":"ResourceForm","name":"Resource","entity":"Resource","toplevel":true},
{"buckets":
	{"left":[{"field":"text","editor":"RichTextEditor"},
	{"field":"language","editor":"IntEditor"},
	{"field":"type","editor":"IntEditor"},
	{"field":"rank","editor":"DoubleEditor"}],
	"right":[{"field":"data","editor":"ReferenceEditor"}]},
	"name":"SMMSearchHandle","entity":"SMMSearchHandle","toplevel":true},
{"buckets":{"left":[{"field":"name","editor":"StringEditor"}],
	"right":[{"field":"root","editor":"ReferenceEditor"}]},
	"name":"Tree","entity":"Tree","toplevel":true},
{"buckets":{"left":[{"field":"node_id","editor":"StringEditor"},
	{"field":"node_class","editor":"StringEditor"},
	{"field":"metadata","editor":"StringEditor"}],
	"right":[{"field":"tree","editor":"ReferenceEditor"},
	{"field":"parent_node","editor":"ReferenceEditor"},
	{"field":"children","editor":"ReferenceArrayEditor"},
	{"field":"data","editor":"ReferenceEditor"}]},
	"name":"TreeNode","entity":"TreeNode","toplevel":true},
{"buckets":{"left":[{"field":"email","editor":"StringEditor"},
	{"field":"password","editor":"StringEditor"},
	{"field":"username","editor":"StringEditor"},
	{"field":"roles","editor":"IntsEditor"},
	{"field":"last_login","editor":"DateEditor"},
	{"field":"last_logout","editor":"DateEditor"},
	{"field":"lock","editor":"IntEditor"},
	{"field":"lock_code","editor":"IntEditor"},
	{"field":"lock_notes","editor":"StringEditor"}],
	"right":[{"field":"user_object","editor":"ReferenceEditor"}]},
	"name":"User","entity":"User","toplevel":true},
{"buckets":{"left":[{"field":"WebStoreModulePropKey","editor":"StringEditor"},
	{"field":"WebStoreModulePropValue","editor":"StringEditor"}],
	"right":[]},
	"name":"WebStoreModuleProp","entity":"WebStoreModuleProp","toplevel":true}],
"backgroundcolor":"ffffff"}
