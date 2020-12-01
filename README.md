# JSONDrivenUI

Convert your json into native `View`s

Simply construct `JSONDataView(json: Data)` view to setup UI.

OK JSON but how? 

* Specify your view's `type` ([ViewType](../main/Sources/JSONDrivenUI/ViewType.swift))
* `properties` of it ([ViewProperties](../main/Sources/JSONDrivenUI/ViewProperties.swift) )
* `values` (like text, imageUrl, systemIconName, localImageName) ([Values](../main/Sources/JSONDrivenUI/Values.swift) )
* `subviews` (for stacks, list & scrollView)


### Supported View Types
<details>
  <summary>Image</summary>
  
- For images we have 3 options. (Order is also like below in case more than 1 set)
    * systemIconName
    * localImageName
    * imageUrl
     
```json
{
  "type": "Image",
  "values": {
      "systemIconName": "person.crop.circle"
  },
  "properties": {
    "width": 60,
    "height": 60
  }
}
```

`resizable()` & `scaledToFit()` modifiers applied by default.

</details>

<details>
    <summary>Text</summary>

    * font (largeTitle, title, headline, subheadline, body, callout, footnote, caption)
    * fontWeight (ultraLight, thin, light, regular, medium, semibold, bold, heavy, black)

```json
{
    "type": "Text",
    "values": {
        "text": "Enes Karaosman"
    },
    "properties": {
        "fontWeight": "semibold",
        "font": "bold"
    }
}
```

</details>

<details>
    <summary>VStack</summary>

    * spacing: Int
    * horizontalAlignment: (leading, center, trailing) // default is center

```json
{
    "type": "VStack",
    "properties": {
        "spacing": 8,
        "horizontalAlignment": "leading",
        ..
    },
    "subviews": [
        ...
    ]
}
```

</details>


<details>
    <summary>HStack</summary>

    * spacing: Int
    * verticalAlignment: (top, bottom, center, firstTextBaseline, lastTextBaseline) // default is center

```json
{
    "type": "HStack",
    "properties": {
        "spacing": 8,
        "verticalAlignment": "top",
        ..
    },
    "subviews": [
        ...
    ]
}
```

</details>

<details>
    <summary>ZStack</summary>


```json
{
  "type": "ZStack",
  "subviews": [
    {
      "type": "Circle",
      "properties": {
        "foregroundColor": "#ff0000",
        "width": 200
      }
    },
    {
      "type": "Circle",
      "properties": {
        "foregroundColor": "#00ff00",
        "width": 150
      }
    },
    {
      "type": "Circle",
      "properties": {
        "foregroundColor": "#0000ff",
        "width": 100
      }
    }
  ]
}
```

</details>

<details>
    <summary>List</summary>


```json
{
  "type": "List",
  "subviews": [
    { ... },
    { ... },
    { ... }
  ]
}
```

</details>

<details>
    <summary>ScrollView</summary>

Scroll view content (subviews) automatically placed in Stack according to given axis.
<br>
If axis is vertical placed in VStack, otherwise in HStack.

```json
{
  "type": "ScrollView",
  "properties": {
    "axis": "vertical",
    "showsIndicators": true
  }
  "subviews": [
    { ... },
    { ... },
    { ... }
  ]
}
```

</details>

* Spacer (`minLenght: Int?`)
* Rectangle
* Circle
* Divider

#### Examples

<details>
  <summary>Profile Row</summary>
  
  <img src="../main/Sources/JSONDrivenUI/Preview/profile_row.png" width="240"/>
    
```json
{
  "type": "HStack",
  "properties": {
    "height": 100,
    "padding": 16,
    "spacing": 16
  },
  "subviews": [
    {
      "type": "Image",
      "values": {
          "systemIconName": "person.crop.circle"
      },
      "properties": {
        "width": 60,
        "height": 60
      }
    },
    {
      "type": "VStack",
      "properties": {
        "foregroundColor": "#f0f00f",
        "spacing": 8,
        "horizontalAlignment": "leading"
      },
      "subviews": [
        {
          "type": "Text",
          "values": {
            "text": "Enes Karaosman"
          },
          "properties": {
            "fontWeight": "semibold",
            "foregroundColor": "#000000"
          }
        },
        {
          "type": "Text",
          "values": {
            "text": "Here is a bit description like text"
          },
          "properties": {
              "foregroundColor": "#070707"
          }
        }
      ]
    }
  ]
}
```

</details>

<details>
  <summary>Complex Page</summary>
  
  <img src="../main/Sources/JSONDrivenUI/Preview/complex.png" width="240"/>
    
```json
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
```

</details>
