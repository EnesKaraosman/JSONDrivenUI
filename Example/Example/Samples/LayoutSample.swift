//
//  LayoutSample.swift
//  Example
//

import Foundation

let layoutSample = """
{
    "type": "ScrollView",
    "properties": { "axis": "vertical" },
    "subviews": [
        {
            "type": "VStack",
            "properties": { "spacing": 20, "padding": 16 },
            "subviews": [
                {
                    "type": "Text",
                    "properties": { "font": "title", "fontWeight": "bold" },
                    "values": { "text": "Layout Examples" }
                },
                {
                    "type": "Text",
                    "properties": { "font": "headline" },
                    "values": { "text": "HStack" }
                },
                {
                    "type": "HStack",
                    "properties": { "spacing": 8 },
                    "subviews": [
                        {
                            "type": "Rectangle",
                            "properties": { "width": 60, "height": 60, "foregroundColor": "#FF6B6B", "cornerRadius": 8 }
                        },
                        {
                            "type": "Rectangle",
                            "properties": { "width": 60, "height": 60, "foregroundColor": "#4ECDC4", "cornerRadius": 8 }
                        },
                        {
                            "type": "Rectangle",
                            "properties": { "width": 60, "height": 60, "foregroundColor": "#45B7D1", "cornerRadius": 8 }
                        }
                    ]
                },
                {
                    "type": "Text",
                    "properties": { "font": "headline" },
                    "values": { "text": "ZStack" }
                },
                {
                    "type": "ZStack",
                    "subviews": [
                        {
                            "type": "Circle",
                            "properties": { "width": 100, "height": 100, "foregroundColor": "#FF6B6B", "opacity": 0.5 }
                        },
                        {
                            "type": "Circle",
                            "properties": { "width": 70, "height": 70, "foregroundColor": "#4ECDC4", "opacity": 0.5 }
                        },
                        {
                            "type": "Circle",
                            "properties": { "width": 40, "height": 40, "foregroundColor": "#45B7D1" }
                        }
                    ]
                },
                {
                    "type": "Text",
                    "properties": { "font": "headline" },
                    "values": { "text": "Grid" }
                },
                {
                    "type": "Grid",
                    "properties": { "spacing": 8 },
                    "subviews": [
                        {
                            "type": "GridRow",
                            "subviews": [
                                { "type": "Rectangle", "properties": { "height": 50, "foregroundColor": "#FF6B6B", "cornerRadius": 8 } },
                                { "type": "Rectangle", "properties": { "height": 50, "foregroundColor": "#4ECDC4", "cornerRadius": 8 } }
                            ]
                        },
                        {
                            "type": "GridRow",
                            "subviews": [
                                { "type": "Rectangle", "properties": { "height": 50, "foregroundColor": "#45B7D1", "cornerRadius": 8 } },
                                { "type": "Rectangle", "properties": { "height": 50, "foregroundColor": "#FFD93D", "cornerRadius": 8 } }
                            ]
                        }
                    ]
                },
                {
                    "type": "Text",
                    "properties": { "font": "headline" },
                    "values": { "text": "LazyVStack in ScrollView" }
                },
                {
                    "type": "LazyVStack",
                    "properties": { "spacing": 8, "horizontalAlignment": "leading" },
                    "subviews": [
                        { "type": "Text", "values": { "text": "Lazy Item 1" }, "properties": { "padding": 12, "backgroundColor": "#F0F0F0", "cornerRadius": 8 } },
                        { "type": "Text", "values": { "text": "Lazy Item 2" }, "properties": { "padding": 12, "backgroundColor": "#F0F0F0", "cornerRadius": 8 } },
                        { "type": "Text", "values": { "text": "Lazy Item 3" }, "properties": { "padding": 12, "backgroundColor": "#F0F0F0", "cornerRadius": 8 } }
                    ]
                }
            ]
        }
    ]
}
"""
