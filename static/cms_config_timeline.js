{
    "backgroundcolor": "ffffff",
    "entities": [
        {
            "buckets": {
                "system": [
                    {
                        "field": "creator",
                        "editor": "ReadOnly"
                    },
                    {
                        "field": "last_modified",
                        "editor": "ReadOnly"
                    },
                    {
                        "field": "date_created",
                        "editor": "ReadOnly"
                    }
                ]
            },
            "editor": "DefaultEditor",
            "entity": "*",
            "toplevel": false
        },
        
        {
            "buckets": {
                "left": [
                    {
                        "field": "long_name",
                        "editor": "StringEditor",
                        "props": { "styleName": "BigInput" }
                    },
                    [
	                    {
	                        "field": "short_name",
	                        "editor": "StringEditor"
	                    },
	                    {
	                        "field": "alternate_names",
	                        "editor": "StringArrayEditor"
	                    }
                    ],
                    {
                        "field": "description",
                        "editor": "RichTextEditor"
                    },
                    [
	                    {
	                        "field": "start",
	                        "editor": "IntEditor"
	                    },
	                    {
	                        "field": "end",
	                        "editor": "IntEditor"
	                    }
                    ],
                    [
	                    {
	                        "field": "location",
	                        "editor": "ReferenceArrayEditor",
	                        "props": { "showAdd": false }
	                    },
	                    {
	                        "field": "category",
	                        "editor": "ReferenceArrayEditor",
	                        "props": { "showAdd": false }
	                    }
	                 ]
                ],
                "right": [

					{
					    "field": "images",
					    "editor": "ReferenceArrayEditor",
					    "props": { "height": 300 }
					},
                    {
                        "field": "architects",
                        "editor": "ReferenceArrayEditor",
                        "props": { "showAdd": false }
                    },
                    {
                        "field": "contributors",
                        "editor": "ReferenceArrayEditor",
                        "props": { "showAdd": false }
                    },
                    {
                        "field": "references",
                        "editor": "ReferenceArrayEditor"
                    }
                ]
            },
            "entity": "Event",
            "toplevel": true,
            "name": "Event"
        },
        
        {
            "buckets": {
                "left": [
                    {
                        "field": "name",
                        "editor": "StringEditor"
                    },
                    {
                        "field": "description",
                        "editor": "RichTextEditor"
                    }
                ],
                "right": []
            },
            "entity": "Category",
            "toplevel": true,
            "name": "Category"
        },
        
        {
            "buckets": {
                "left": [
                    {
                        "field": "name",
                        "editor": "StringEditor"
                    },
                    {
                        "field": "description",
                        "editor": "StringEditor"
                    },
                    {
                        "field": "caption",
                        "editor": "StringEditor"
                    },
                    {
                        "field": "copyright",
                        "editor": "StringEditor"
                    }
                ],
                "right": [
                    {
                        "field": "resource",
                        "editor": "ResourceEditor"
                    }
                ]
            },
            "entity": "Image",
            "toplevel": true,
            "name": "Image"
        },
       
      
        {
            "buckets": {
                "left": [
                    {
                        "field": "name",
                        "editor": "StringEditor"
                    },
                    {
                        "field": "bio",
                        "editor": "RichTextEditor"
                    }
                ],
                "right": [
                    {
                        "field": "references",
                        "editor": "ReferenceArrayEditor"
                    }
                ]
            },
            "entity": "Person",
            "toplevel": true,
            "name": "Person"
        },
        
        {
            "buckets": {
                "left": [
                    {
                        "field": "city",
                        "editor": "StringEditor"
                    },
                    {
                        "field": "state",
                        "editor": "StringEditor"
                    },
                    {
                        "field": "country",
                        "editor": "StringEditor"
                    },
                    {
                        "field": "address_1",
                        "editor": "StringEditor"
                    },
                    {
                        "field": "address_2",
                        "editor": "StringEditor"
                    },
                    {
                        "field": "longitude",
                        "editor": "DoubleEditor"
                    },
                    {
                        "field": "latitude",
                        "editor": "DoubleEditor"
                    },
                    {
                        "field": "zoom",
                        "editor": "DoubleEditor"
                    }
                ],
                "right": []
            },
            "entity": "Place",
            "toplevel": true,
            "name": "Place"
        },
        
        {
            "buckets": {
                "left": [
                    {
                        "field": "title",
                        "editor": "StringEditor"
                    },
                    {
                        "field": "description",
                        "editor": "RichTextEditor"
                    },
                    {
                        "field": "url",
                        "editor": "StringEditor"
                    },
                    {
                        "field": "url_title",
                        "editor": "StringEditor"
                    }
                ],
                "right": []
            },
            "entity": "Reference",
            "toplevel": true,
            "name": "Reference"
        },
        
        {
            "editor": "ResourceForm",
            "entity": "Resource",
            "toplevel": false,
            "name": "Resource"
        },
       
        
        {
            "buckets": {
                "left": [
                    { "field": "name", "editor": "StringEditor" },
                    [
                      { "field": "start",  "editor": "IntEditor" },
                      { "field": "end",    "editor": "IntEditor" }
                    ],
                    { "field": "note", "editor": "RichTextEditor" }
                ],
                "right": []
            },
            "entity": "WorldEvent",
            "toplevel": true,
            "name": "World Event"
        },
        
        {
            "buckets": {
                "left": [
                    { "field": "name", "editor": "StringEditor" },
                    { "field": "year", "editor": "IntEditor" },
                    { "field": "note", "editor": "RichTextEditor" }
                ],
                "right": []
            },
            "entity": "MajorPublication",
            "toplevel": true,
            "name": "Major Publication"
        }
    ]
}