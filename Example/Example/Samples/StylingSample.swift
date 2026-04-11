//
//  StylingSample.swift
//  Example
//

import Foundation

let stylingSample = """
{
    "type": "ScrollView",
    "subviews": [
        {
            "type": "VStack",
            "properties": { "spacing": 24, "padding": 20 },
            "subviews": [
                {
                    "type": "Text",
                    "properties": { "font": "title", "fontWeight": "bold" },
                    "values": { "text": "Styling Examples" }
                },
                {
                    "type": "Text",
                    "values": { "text": "Rounded Card with Shadow" },
                    "properties": {
                        "padding": 20,
                        "backgroundColor": "#FFFFFF",
                        "cornerRadius": 16,
                        "shadowRadius": 8,
                        "shadowColor": "#00000033",
                        "shadowY": 4
                    }
                },
                {
                    "type": "HStack",
                    "properties": { "spacing": 12 },
                    "subviews": [
                        {
                            "type": "Circle",
                            "properties": { "width": 60, "height": 60, "foregroundColor": "#FF6B6B" }
                        },
                        {
                            "type": "Rectangle",
                            "properties": { "width": 60, "height": 60, "foregroundColor": "#4ECDC4", "cornerRadius": 12 }
                        },
                        {
                            "type": "Rectangle",
                            "properties": { "width": 60, "height": 60, "foregroundColor": "#45B7D1", "clipShape": "capsule" }
                        }
                    ]
                },
                {
                    "type": "Text",
                    "values": { "text": "50% Opacity" },
                    "properties": {
                        "font": "headline",
                        "padding": 16,
                        "backgroundColor": "#007AFF",
                        "foregroundColor": "#FFFFFF",
                        "cornerRadius": 8,
                        "opacity": 0.5
                    }
                },
                {
                    "type": "Text",
                    "values": { "text": "Rotated 15 degrees" },
                    "properties": {
                        "font": "headline",
                        "padding": 16,
                        "backgroundColor": "#FF6B6B",
                        "foregroundColor": "#FFFFFF",
                        "cornerRadius": 8,
                        "rotation": 15
                    }
                },
                {
                    "type": "Image",
                    "values": { "systemIconName": "photo.fill" },
                    "properties": {
                        "width": 100,
                        "height": 100,
                        "foregroundColor": "#999999",
                        "blur": 3
                    }
                },
                {
                    "type": "Text",
                    "values": { "text": "Grayscale Text" },
                    "properties": {
                        "font": "title",
                        "fontWeight": "bold",
                        "foregroundColor": "#FF6B6B",
                        "grayscale": 1.0
                    }
                },
                {
                    "type": "Text",
                    "values": { "text": "Bordered & Colored" },
                    "properties": {
                        "padding": 16,
                        "borderColor": "#007AFF",
                        "borderWidth": 2,
                        "foregroundColor": "#007AFF",
                        "fontWeight": "semibold"
                    }
                }
            ]
        }
    ]
}
"""
