# Code Snippets for IRBCAM Plugins

This document provides code snippets and templates to help you get started with plugin development for IRBCAM.

## Plugin Boilerplate

To kickstart your plugin development, here's a basic boilerplate for a IRBCAM QML plugin:

```qml
// Import QtQuick modules
import QtQuick
import QtQuick.Layouts

// Import Hokarob theme
import HokarobQml.Theme
// Import Hokarob Controls library
import HokarobQml.Controls

// Import IRBCAM public interface
import IRBCAM.InterfacePublic

ColumnLayout {
    id: root

    // Your content goes here

    // Example: Add a button
    Button {
        text: "Click Me"
        onClicked: {
            // Handle button click event
        }
    }
}
```

In this template:

- We import the necessary QtQuick modules for QML development.
- The Hokarob theme and UI style modules are imported to maintain a consistent look and feel.
- The IRBCAM public interface module, named [IRBCAM.InterfacePublic][apiclass], is included for accessing IRBCAM's functionality.

You can use this template as a starting point for your plugin, adding your QML components, functionality, and UI elements within the ColumnLayout. The example provided adds a button, demonstrating how to integrate QML components into your plugin.

Feel free to customize and expand upon this template to meet the specific requirements of your plugin.

[apiclass]: @ref IrbcamInterfacePublic "IRBCAM Interface Public"