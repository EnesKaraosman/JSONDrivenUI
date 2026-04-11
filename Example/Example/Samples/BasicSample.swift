//
//  BasicSample.swift
//  Example
//

import Foundation

let basicSample = """
{
    "type": "VStack",
    "properties": {
        "spacing": 16,
        "horizontalAlignment": "center",
        "padding": 20
    },
    "subviews": [
        {
            "type": "Text",
            "properties": {
                "font": "largeTitle",
                "fontWeight": "bold"
            },
            "values": {
                "text": "Welcome!"
            }
        },
        {
            "type": "Text",
            "properties": {
                "font": "body",
                "foregroundColor": "#666666"
            },
            "values": {
                "text": "This is a basic example showing Text, Image, and layout."
            }
        },
        {
            "type": "Image",
            "values": {
                "systemIconName": "star.fill"
            },
            "properties": {
                "height": 60,
                "width": 60,
                "foregroundColor": "#FFD700"
            }
        },
        {
            "type": "Divider"
        },
        {
            "type": "HStack",
            "properties": {
                "spacing": 12
            },
            "subviews": [
                {
                    "type": "Image",
                    "values": { "systemIconName": "person.circle.fill" },
                    "properties": { "height": 40, "width": 40, "foregroundColor": "#007AFF" }
                },
                {
                    "type": "VStack",
                    "properties": { "horizontalAlignment": "leading", "spacing": 2 },
                    "subviews": [
                        {
                            "type": "Text",
                            "properties": { "fontWeight": "semibold" },
                            "values": { "text": "JSON Driven UI" }
                        },
                        {
                            "type": "Text",
                            "properties": { "font": "caption", "foregroundColor": "#999999" },
                            "values": { "text": "Build UIs from JSON" }
                        }
                    ]
                }
            ]
        }
    ]
}
"""
