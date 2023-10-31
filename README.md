# Official Plugins for IRBCAM

Welcome to the official plugin repository for IRBCAM. This repository contains a collection of officially supported plugins that extend the functionality of IRBCAM. These plugins serve as examples for external plugin developers and demonstrate how to extend the functionality of IRBCAM.
Table of Contents


## Developing Your Own Plugins

If you want to develop you own plugins for IRBCAM, we recommend taking a look at our [documentation](https://hokarob.github.io/irbcam-plugins) for developers.

## Available Official Plugins

We have created the following official plugins to demonstrate best practices and provide useful extensions for IRBCAM. You can find each plugin in its respective directory within this repository:

1. **Statistics** A plugin to show statistics for the currently loaded path.
2. **Quaternion Converter** A plugin to convert between Tait-Bryan and Quaternions.

Feel free to explore these plugins to understand how they work and use them as references for your own development.

<!-- ## Plugin Development Guidelines

Before creating your own plugins, it's essential to follow our best practices and guidelines to ensure that your plugins are of high quality and compatible with IRBCAM. Here are some key principles to consider:

- **Security**: Always follow security best practices to prevent vulnerabilities and protect user data.
- **Performance**: Optimize your code for efficiency to ensure that your plugins don't slow down the application.
- **Compatibility**: Ensure your plugins are compatible with the latest versions of IRBCAM.
- **Documentation**: Document your code, including usage instructions and examples, for better usability. -->
<!-- 
## Packing Your Plugin
IRBCAM expects plugins to be a single file. If your plugin is a single QML-file, IRBCAM can load it directly. If your plugin consists of multiple files (such as external JS-files), you will need to add the files to a ZIP archive.

### File Structure
Your archive should include:
- A single QML file
- A single SVG/PNG icon (optional)
- Other resources (not QML or SVG/PNG)

You may add more QML or SVG/PNG files to a subdirectory. Example:

```bash
plugin.zip/
├── MyPlugin.qml
├── Icon.svg
└── resources
    ├── AnotherQmlFile.qml
    └── MyFunctions.js
``` -->

## Contributing

We welcome contributions from the community to improve these official plugins and add more examples for plugin developers. If you have a plugin that you believe would benefit the IRBCAM community, please follow our Contribution Guidelines.

## License

All official plugins in this repository are licensed under the MIT license. Please review the LICENSE file for details.

IRBCAM and these official plugins are trademarks of [Hokarob AS](https://hokarob.com).