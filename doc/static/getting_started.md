# Getting Started
[TOC]

If you're new to plugin development for IRBCAM, this guide will walk you through the basics to get you started on the right track. Learn the structure of a plugin and how to use the [IRBCAM interface][apiclass]. By the end of this section, you'll have a clear understanding of the initial steps in creating plugins for IRBCAM.


## Basics

Plugins in IRBCAM are dynamically loaded QML files, meaning that a plugin in its simplest form is a single QML file. We recommend placing your QML components within a component from the [Layout Module](https://doc.qt.io/qt-6/qtquick-layouts-qmlmodule.html). The following example shows a basic plugin, where a a button click changes the text of a label.


@note Notice that we have not imported *QtQuick.Controls* in our examples. This is because *IrbcamQml.UiStyle* implicitly imports controls.

```qml
// Import QtQuick modules
import QtQuick
import QtQuick.Layouts

// Import IRBCAM theme
import IrbcamQml.Theme
import IrbcamQml.UiStyle

ColumnLayout {
    id: root

    Button {
        text: "Click me"
        onClicked: myLabel.text = "Button has been clicked"
    }

    Label {
        id: myLabel
        text: "Button has not been clicked"
    }
}
```


## Loading Your Plugin

Let's start by loading this simple plugin. Open a text editor or IDE, paste the example code and save your file as `SimplePlugin.qml`. This QML file is your plugin, and we want to load it into IRBCAM to check if it is working. Log in to [IRBCAM](https://irbcam.com/app) and go to **Plugins > Plugin Settings**. Select **Add** and upload your file. Select a name and add your plugin.


## Using the API interface

Plugins are most useful when interfaced with IRBCAM. By importing `IRBCAM.InterfacePublic` in your QML file, you will get access to the plugin interface IrbcamInterfacePublic. Let's expand on the previous example.


```qml
// Import QtQuick modules
import QtQuick
import QtQuick.Layouts

// Import IRBCAM theme
import IrbcamQml.Theme
import IrbcamQml.UiStyle

// Import IRBCAM public interface
import IRBCAM.InterfacePublic

ColumnLayout {
    id: root

    Button {
        text: "Convert"
        onClicked: {
            var angleDeg = parseFloat(textFieldAngle.text);
            var angleRad = IrbcamInterfacePublic.degToRad(angleDeg);
            myLabel.text = textFieldAngle.text + " degrees is " + angleRad.toFixed(3) + " radians"
        }
    }

    TextField {
        id: textFieldAngle
        text: "0"
    }

    Label {
        id: myLabel
        text: "Click button to convert"
    }
}
```

In this example, we imported the IrbcamInterfacePublic and used IrbcamInterfacePublic::degToRad to convert degrees to radians when clicking the button.

## Further Reading

These are the basics to getting started with plugin development for IRBCAM. For further reading we recommend:

- [Our Forum](https://forum.hokarob.com/)
- [Reading up on QML](https://doc.qt.io/qt-6/qmlfirststeps.html)
- [API Reference][apiclass]
- [Development Environment Setup](environment_setup.md)

[apiclass]: @ref IrbcamInterfacePublic "IRBCAM Interface Public"