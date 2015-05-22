{
	"backgroundColor"	: "ff00ff",
	"entities" :
	[
		{
			"entity" : "*",
			"editor" : "DefaultEditor",
			"toplevel" : false,
			"buckets" :
			{
				"system" :
				[
					{"editor":"ReadOnly", "field":"creator"},
					{"editor":"ReadOnly", "field":"last_modified"},
					{"editor":"ReadOnly", "field":"date_created"}
				]
			}
		},

		{
			"entity"		: "Artist",
			"name"			: "Artist",
			"toplevel"		: true,
			"buckets":
			{
				"left":
				[
					{"editor":"StringEditor", "field": "first_name", "name":"first name"},
					{"editor":"StringEditor", "field": "last_name", "name":"last"},
					{"editor":"RichTextEditor", "field": "description"}
				],
				"right":
				[
					{"editor":"ReferenceArrayEditor", "field": "work"}
				]
			}
		},
		{
			"entity"		: "Inventory",
			"name"			: "Inventory",
			"toplevel"		: true,
			"buckets":
			{
				"left":
				[
					{"editor":"StringEditor", "field": "title"},
					{"editor":"StringEditor", "field": "code"},
					{"editor":"RichTextEditor", "field": "description", "props":{"height":100}},
					{"editor":"StringEditor", "field": "materials"},
					{"editor":"StringEditor", "field": "dimensions"},
					{"editor":"StringEditor", "field": "year"}
				],
				"right":
				[
					{"editor":"ResourceArrayEditor", "field": "resource", "props":{"cellHeight": 200, "cellWidth":200}},
					{"editor":"PopUpEditor", "field": "use", "props":{"options":[["normal",null],["just for homepage","just for homepage"],["not for homepage","not for homepage"]]}},
					{"editor":"PopUpEditor", "field": "alignment", "props":{"options":[["center",null],["crop top","crop top"],["crop bottom","crop bottom"],["crop left","crop left"],["crop right","crop right"]]}}
				]
			}
		},
		{
			"entity"		: "News",
			"name"			: "News",
			"toplevel"		: true,
			"buckets":
			{
				"left":
				[
					{"editor":"StringEditor", "field": "title"},
					{"editor":"RichTextEditor", "field": "above_nav", "name":"above menu"},
					{"editor":"RichTextEditor", "field": "below_nav", "name":"below menu"}
				]
			}
		},
		{
			"entity"		: "Page",
			"name"			: "Page",
			"toplevel"		: true,
			"buckets":
			{
				"left":
				[
					{"editor":"StringEditor", "field": "title"},
					{"editor":"RichTextEditor", "field": "description"}
				]
			}
		},
		{
			"entity"		: "Contact",
			"name"			: "Contact",
			"toplevel"	: false,
			"buckets":
			{
				"left":
				[
					{"editor":"StringEditor", "field": "title"},
					{"editor":"StringEditor", "field": "overview"},
					{"editor":"StringEditor", "field": "directions"},
					{"editor":"StringEditor", "field": "address_line_1"},
					{"editor":"StringEditor", "field": "address_line_2"},
					{"editor":"StringEditor", "field": "city"},
					{"editor":"StringEditor", "field": "state"},
					{"editor":"StringEditor", "field": "zip"},
					{"editor":"StringEditor", "field": "email"},
					{"editor":"StringEditor", "field": "phone"},
					{"editor":"StringEditor", "field": "mobile"}
				]
			}
		},
		{
			"entity"		: "ExhibitionHome",
			"name"			: "Exhibit Home",
			"toplevel"		: true,
			"buckets":
			{
				"left":
				[
					{"editor":"ResourceArrayEditor", "field": "image", "props":{"cellHeight": 200, "cellWidth":200}}
				]
			}
		},
		{
			"entity"		: "Exhibition",
			"name"			: "Exhibitions",
			"toplevel"		: true,
			"buckets":
			{
				"left":
				[
					{"editor":"StringEditor", "field": "title"},
					{"editor":"StringEditor","field": "subtitle"},
					[
					{"editor":"DateEditor", "field": "start_date"},
					{"editor":"DateEditor", "field": "end_date"}
					]
					
				],
				"right":
				[
					{"editor":"ReferenceArrayEditor", "field": "images"},
					{"editor":"ReferenceArrayEditor", "field": "essay"},
					{"editor":"ReferenceEditor", "field": "catalog"}
				]
			}
		},
		{
			"entity"		: "Essay",
			"name"			: "Essay",
			"toplevel"		: false,
			"buckets":
			{
				"left":
				[
					{"editor":"StringEditor", "field": "author"},
					{"editor":"StringEditor", "field": "title1"},
          {"editor":"RichTextEditor", "field": "body"},
          {"editor":"StringEditor", "field": "author_bio", "props":{"multiline":true, "height": 100}}
				]
			}
		},
		{
			"entity"		: "Catalog",
			"name"			: "Catalog",
			"toplevel"		: false,
			"buckets":
			{
				"left":
				[
					{"editor":"StringEditor", "field": "title"},
					{"editor":"StringEditor", "field": "caption"},
					{"editor":"FloatEditor", "field": "price"},
					{"editor":"ResourceArrayEditor", "field": "images"}
				]
			}
		}
	]
}