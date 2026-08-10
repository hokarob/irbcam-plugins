/*
    Motoman and Fanuc have different definitions of the tool frame compared to ABB and KUKA.
    For Motoman and Fanuc robots, the tool frame is rotated 180 degrees about the Z axis compared to ABB and KUKA.
    IRBCAM has chosen to use the same tool frame definition as ABB and KUKA.
    Hence, this plugin (tool data/frame converter) can be used when Motoman and Fabuc robot users want to transfer tooldata from their teach pendants to the IRBCAM app.

    IRBCAM: ZYX Euler Angles (with respect to moving frame, the sequence of rotation is RZ, RY, RX).
    X - Translation along X-axis
    Y - Translation along Y-axis
    Z - Translation along Z-axis
    RX - Rotation around X-axis of the moving frame
    RY - Rotation aroung Y-axis of the moving frame
    RZ - Rotation around Z-axis of the moving frame

    MOTOMAN/FANUC: ZYX Euler Angles (with respect to moving frame, the sequence of rotation is RZ, RY, RX).
    X - Translation along X-axis
    Y - Translation along Y-axis
    Z - Translation along Z-axis
    RX - Rotation around X-axis of the moving frame
    RY - Rotation aroung Y-axis of the moving frame
    RZ - Rotation around Z-axis of the moving frame
*/

import QtQuick
import QtQuick.Layouts
import QtQuick3D

// Import HOKAROB Controls library
import HokarobQml.Controls



import "./resources/functions.js" as Functions

/*
    Plugins are loaded within a QML popup. Pack your content into a single component to get proper sizing.
    See https://doc.qt.io/qt-6/qml-qtquick-controls-popup.html#popup-sizing
*/
GridLayout {
    id: root
    columns: 4
    columnSpacing: 20
    layoutDirection: Qt.LeftToRight
    flow: GridView.FlowLeftToRight

    property int precision: 4

    function motomanFanucToIrbcam() {
        irbcamTx.value = -fanucMotoTx.value;
        irbcamTy.value = -fanucMotoTy.value;
        irbcamTz.value = fanucMotoTz.value;

        irbcamRx.value = fanucMotoRx.value; 
        irbcamRy.value = fanucMotoRy.value; 
        irbcamRz.value = Functions.limitAngle(fanucMotoRz.value - 180.0); 
    }

    function irbcamToMotmanFanuc() {
        fanucMotoTx.value = -irbcamTx.value;
        fanucMotoTy.value = -irbcamTy.value;
        fanucMotoTz.value = irbcamTz.value;

        fanucMotoRx.value = irbcamRx.value; 
        fanucMotoRy.value = irbcamRy.value; 
        fanucMotoRz.value = Functions.limitAngle(irbcamRz.value - 180.0); 
    }

    component MyComponent : RowLayout {
        property alias value: tf.value
        property string labelText
        Label {
            text: labelText
            Layout.rightMargin: 7  // Spacing between label and text field
            Layout.preferredWidth: 70
        }
        TextField {
            id: tf
            property double value: 0.0
            text: value.toFixed(root.precision)
            validator: DoubleValidator {
                decimals: root.precision
                locale: "en_us"
            }
            onActiveFocusChanged: {
                if (activeFocus)
                    selectAll()
            }
            onEditingFinished: {
                value = text
            }
            onAccepted: {
                if (acceptableInput)
                    nextItemInFocusChain().forceActiveFocus();
            }
        }
    }



    // IRBCAM Tool data
    ColumnLayout {
        Label {
            text: "IRBCAM:"
            horizontalAlignment: Text.AlignHCenter
        }

        MyComponent {
            id: irbcamTx
            labelText: "X (mm)"
        }

        MyComponent {
            id: irbcamTy
            labelText: "Y (mm)"
        }

        MyComponent {
            id: irbcamTz
            labelText: "Z (mm)"
        }

        MyComponent {
            id: irbcamRx
            labelText: "RX (deg)"
        }

        MyComponent {
            id: irbcamRy
            labelText: "RY (deg)"
        }

        MyComponent {
            id: irbcamRz
            labelText: "RZ (deg)"
        }
    }

    ColumnLayout {
        RowLayout {
            Button {
                id: btnleft
                Layout.preferredWidth: 70
                text: ">"
                onClicked: {
                    root.irbcamToMotmanFanuc()
                }
            }

            Button {
                id: btnright
                Layout.preferredWidth: 70
                text: "<"
                onClicked: {
                    root.motomanFanucToIrbcam()
                }
            }
        }
    }

    // Fanuc/Motoman Tool data
    ColumnLayout {
        Label {
            text: "FANUC/MOTOMAN:"
            horizontalAlignment: Text.AlignHCenter
        }
        MyComponent {
            id: fanucMotoTx
            labelText: "X (mm)"
        }

        MyComponent {
            id: fanucMotoTy
            labelText: "Y (mm)"
        }

        MyComponent {
            id: fanucMotoTz
            labelText: "Z (mm)"
        }

        MyComponent {
            id: fanucMotoRx
            labelText: "RX (deg)"
        }

        MyComponent {
            id: fanucMotoRy
            labelText: "RY (deg)"
        }

        MyComponent {
            id: fanucMotoRz
            labelText: "RZ (deg)"
        }

        Component.onCompleted: {
            root.irbcamToMotmanFanuc()
        }

    }

    // Close button
    Button {
        Layout.topMargin: 50
        Layout.columnSpan: 4
        Layout.alignment: Qt.AlignRight
        text: "Close"
        onClicked: pluginWindow.close()
    }
}
