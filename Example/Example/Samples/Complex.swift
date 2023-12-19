//
//  Complex.swift
//  Example
//
//  Created by Enes Karaosman on 19.12.2023.
//

import Foundation

let complexSample = """
{
    "type": "VStack",
    "subviews": [
        {
            "type": "Text",
            "properties": {
                "font": "title"
            },
            "values": {
                "text": "LARGE TITLE TEXT"
            }
        },
        {
            "type": "Image",
            "values": {
                "imageUrl": "http://picsum.photos/400/200"
            },
            "properties": {
                "padding": 16,
                "height": 200
            }
        },
        {
            "type": "Text",
            "properties": {
                "padding": 16,
                "font": "title",
                "fontWeight": "semibold"
            },
            "values": {
                "text": "Semibold Title"
            }
        },
        {
            "type": "List",
            "properties": {
                "horizontalAlignment": "leading",
                "spacing": 16,
                "padding": 8
            },
            "subviews": [
                {
                    "type": "HStack",
                    "properties": {
                        "foregroundColor": "#001238",
                        "spacing": 8
                    },
                    "subviews": [
                        {
                            "type": "Image",
                            "properties": {
                                "height": 70
                            },
                            "values": {
                                "imageUrl": "http://picsum.photos/70/70"
                            }
                        },
                        {
                            "type": "VStack",
                            "properties": {
                                "spacing": 4,
                                "horizontalAlignment": "leading"
                            },
                            "subviews": [
                                {
                                    "type": "Text",
                                    "values": { "text" : "Item.1 Title" }
                                },
                                {
                                    "type": "Text",
                                    "properties": {
                                        "foregroundColor": "#828282"
                                    },
                                    "values": { "text" : "Here is multiline description text in VStack which is inside HStack" }
                                }
                            ]
                        }
                    ]
                },
                {
                    "type": "HStack",
                    "properties": {
                        "foregroundColor": "#001238",
                        "spacing": 8
                    },
                    "subviews": [
                        {
                            "type": "Image",
                            "properties": {
                                "height": 70
                            },
                            "values": {
                                "imageUrl": "http://picsum.photos/70/70"
                            }
                        },
                        {
                            "type": "VStack",
                            "properties": {
                                "spacing": 4,
                                "horizontalAlignment": "leading"
                            },
                            "subviews": [
                                {
                                    "type": "Text",
                                    "values": { "text" : "Item.2 Title" }
                                },
                                {
                                    "type": "Text",
                                    "properties": {
                                        "foregroundColor": "#828282"
                                    },
                                    "values": { "text" : "Here is second multiline description text in VStack which is inside HStack" }
                                }
                            ]
                        }
                    ]
                }
            ]
        }
    ]
}
"""
