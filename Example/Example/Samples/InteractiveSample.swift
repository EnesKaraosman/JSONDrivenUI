//
//  InteractiveSample.swift
//  Example
//

import Foundation

let interactiveSample = """
{
    "type": "VStack",
    "properties": { "spacing": 20, "padding": 20, "horizontalAlignment": "leading" },
    "subviews": [
        {
            "type": "Text",
            "properties": { "font": "title", "fontWeight": "bold" },
            "values": { "text": "Interactive Elements" }
        },
        {
            "type": "Button",
            "values": { "actionId": "primary_button" },
            "subviews": [
                {
                    "type": "HStack",
                    "properties": { "spacing": 8, "padding": 12, "backgroundColor": "#007AFF", "cornerRadius": 10 },
                    "subviews": [
                        {
                            "type": "Image",
                            "values": { "systemIconName": "hand.tap.fill" },
                            "properties": { "width": 20, "height": 20, "foregroundColor": "#FFFFFF" }
                        },
                        {
                            "type": "Text",
                            "properties": { "foregroundColor": "#FFFFFF", "fontWeight": "semibold" },
                            "values": { "text": "Tap Me" }
                        }
                    ]
                }
            ]
        },
        {
            "type": "Divider"
        },
        {
            "type": "Toggle",
            "values": { "text": "Enable Notifications", "isOn": true, "actionId": "notifications_toggle" }
        },
        {
            "type": "Toggle",
            "values": { "text": "Dark Mode", "isOn": false, "actionId": "dark_mode_toggle" }
        },
        {
            "type": "Divider"
        },
        {
            "type": "TextField",
            "values": { "placeholder": "Enter your name...", "actionId": "name_field" },
            "properties": { "padding": 12, "backgroundColor": "#F5F5F5", "cornerRadius": 8 }
        },
        {
            "type": "TextField",
            "values": { "placeholder": "Enter your email...", "actionId": "email_field" },
            "properties": { "padding": 12, "backgroundColor": "#F5F5F5", "cornerRadius": 8 }
        },
        {
            "type": "Spacer"
        }
    ]
}
"""
