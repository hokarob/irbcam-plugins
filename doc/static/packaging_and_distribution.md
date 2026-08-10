# Packaging and Distribution

Once you've created your plugin, the next step is packaging and distributing it to other IRBCAM users. This document explains the process of packaging your plugin for easy distribution and sharing.


## Packaging

IRBCAM loads plugins as an individual file. If your plugin is a single QML file, IRBCAM can load it directly. If your plugin consists of multiple files (such as external JS-files), you will need to add the files to a ZIP archive.

### File Structure

Your archive should include:
- A single QML file
- A single SVG/PNG icon (optional)
- Other resources (optional, not QML or SVG/PNG)

@note You may add more than one QML or SVG/PNG file, however these must be put in a subdirectory.

```bash
plugin.zip/
├── MyPlugin.qml
├── Icon.svg
└── resources
    ├── AnotherQmlFile.qml
    └── MyFunctions.js
```
## Distribution

### Local Distribution

Local distribution is suitable for testing and sharing plugins within a controlled environment. To distribute your plugin locally, you can follow these steps:

1. **Prepare the Archive**: Ensure your plugin files are organized as described in the previous section. Save the file on your computer.

2. **Enable the Plugin**: In IRBCAM, navigate to **File > Settings > Plugins** and add your plugin.

@note When adding plugins to IRBCAM from your local device, the plugin will not be stored between sessions. You will have to add the plugin every time you start IRBCAM.

### Web Distribution

For wider distribution, consider hosting your plugin online. This approach allows other users to easily access and install your plugin. We recommend the following steps:

1. **Host Your Plugin**: Host your plugin archive and related files on a web server or a code hosting platform like GitHub.

2. **Publish Plugin Details**: Provide clear documentation, including a description, usage instructions, and any dependencies, on the web page where your plugin is hosted.

3. **Share the URL**: Share the URL to your plugin with the community or potential users.

## Conclusion

Packaging and distributing your QML plugins for IRBCAM can bring your custom functionalities to a broader user base. Whether you choose local or web distribution, clear documentation and effective sharing strategies can make your plugin easily accessible to others. By following the recommended file structure and guidelines, you can ensure that your plugins are ready for seamless integration and use in IRBCAM.

Happy coding and sharing your IRBCAM plugins!
