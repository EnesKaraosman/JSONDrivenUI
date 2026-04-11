//
//  NavigationSample.swift
//  Example
//

import Foundation

let navigationSample = """
{
    "type": "NavigationStack",
    "subviews": [
        {
            "type": "VStack",
            "properties": { "spacing": 12, "padding": 16, "horizontalAlignment": "leading" },
            "subviews": [
                {
                    "type": "Text",
                    "properties": { "font": "largeTitle", "fontWeight": "bold" },
                    "values": { "text": "Navigation" }
                },
                {
                    "type": "NavigationLink",
                    "values": { "text": "Detail Page" },
                    "subviews": [
                        {
                            "type": "VStack",
                            "properties": { "spacing": 16, "padding": 20 },
                            "subviews": [
                                {
                                    "type": "Image",
                                    "values": { "systemIconName": "doc.text.fill" },
                                    "properties": { "width": 60, "height": 60, "foregroundColor": "#007AFF" }
                                },
                                {
                                    "type": "Text",
                                    "properties": { "font": "title", "fontWeight": "bold" },
                                    "values": { "text": "Detail View" }
                                },
                                {
                                    "type": "Text",
                                    "properties": { "foregroundColor": "#666666" },
                                    "values": { "text": "This page was navigated to from a NavigationLink defined in JSON." }
                                }
                            ]
                        }
                    ]
                },
                {
                    "type": "NavigationLink",
                    "values": { "text": "Settings Page" },
                    "subviews": [
                        {
                            "type": "VStack",
                            "properties": { "spacing": 12, "padding": 20, "horizontalAlignment": "leading" },
                            "subviews": [
                                {
                                    "type": "Text",
                                    "properties": { "font": "title", "fontWeight": "bold" },
                                    "values": { "text": "Settings" }
                                },
                                {
                                    "type": "Toggle",
                                    "values": { "text": "Push Notifications", "isOn": true, "actionId": "push_toggle" }
                                },
                                {
                                    "type": "Toggle",
                                    "values": { "text": "Sound Effects", "isOn": false, "actionId": "sound_toggle" }
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
