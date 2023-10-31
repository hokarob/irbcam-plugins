# API Overview

Welcome to the API overview for IRBCAM's exposed functionality. This document will provide you with an understanding of how to interface with `IRBCAM`'s API.

## The C++ Exposed API

The exposed API of IRBCAM is written in C++ and defined in the class IrbcamInterfacePublic. Through the exposed API, you gain access to a wide range of features and capabilities, such that you can customize and enhance IRBCAM to suit your specific needs.

## Accessing the API via QML

As a QML developer, you can seamlessly interface with IRBCAM's exposed API by importing it as a QML module. The module you'll use for this purpose is `IRBCAM.InterfacePublic`. Once you've imported this module, you can access the API's functionality directly from your QML code.

Here's an example of how to import the `IRBCAM.InterfacePublic` module:

```
import IRBCAM.InterfacePublic
```

Once you've imported the module, you can use its components, properties, and methods within your QML code, making it easy to integrate your QML plugins and extensions with IRBCAM.

## Type Conversion: Bridging C++ and QML

When working with the exposed C++ API in a QML environment, Qt provides type conversion between C++ and QML data types. This conversion mechanism ensures that you can work with C++ data types and objects in your QML code.

For a more in-depth understanding of how Qt handles data type conversion in the context of C++ and QML integration, we recommend reading the article on [Qt's Data Type Conversion](https://doc.qt.io/qt-6/qtqml-cppintegration-data.html).

## Conclusion

The exposed API of IRBCAM offers a set of features written in C++. By importing the `IRBCAM.InterfacePublic` module in your QML projects, you can access and utilize this API. The type conversion provided by Qt ensures that working with C++ types in QML is a straightforward experience.

Get started with the API and explore the endless possibilities of customizing and extending IRBCAM to suit your unique needs.