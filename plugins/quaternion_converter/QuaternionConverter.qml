/*
    This is a simple example plugin to get started. 
    It uses functions eulerToQuaternion and quaternionToEuler from IRBCAM public interface to convert between Tait-Bryan angles and Quaterion. 
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick3D

// Import IRBCAM theme
import IrbcamQml.Theme
import IrbcamQml.UiStyle

// Import IRBCAM public interface
import IRBCAM.InterfacePublic

/*
    Plugins are loaded within a QML popup. Pack your content into a single component to get proper sizing. 
    See https://doc.qt.io/qt-6/qml-qtquick-controls-popup.html#popup-sizing
*/
GridLayout {
    id: root
    columns: 4
    columnSpacing: 20
    Component.onCompleted: angles2quat()
    layoutDirection: Qt.LeftToRight
    flow: GridView.FlowLeftToRight

    // Convert Tait-bryan angles to Quaternion using rotation sequence from cbSequence. Updates values stored in repeater "quaternions"
    function angles2quat() {
        var quat = IrbcamInterfacePublic.eulerToQuaternion(IrbcamInterfacePublic.degToRad(parseFloat(eulerRots.itemAt(0).text)), IrbcamInterfacePublic.degToRad(parseFloat(eulerRots.itemAt(1).text)), IrbcamInterfacePublic.degToRad(parseFloat(eulerRots.itemAt(2).text)), cbSequence.currentValue);
        quaternions.itemAt(0).text = quat.scalar.toFixed(9);
        quaternions.itemAt(1).text = quat.x.toFixed(9);
        quaternions.itemAt(2).text = quat.y.toFixed(9);
        quaternions.itemAt(3).text = quat.z.toFixed(9);
    }

    // Tait-Bryan text fields
    ColumnLayout {
        Repeater {
            id: eulerRots
            model: ["RX (deg)", "RY (deg)", "RZ (deg)"]
            delegate: componentField
        }
    }

    ColumnLayout {
        RowLayout {
            Button {
                id: btnleft
                text: ">"
                Layout.preferredWidth: cbSequence.width
                onClicked: angles2quat()
            }

            Button {
                id: btnright
                Layout.preferredWidth: cbSequence.width
                text: "<"
                property var euler: Qt.vector3d(0,0,0)
                onClicked: {
                    euler = IrbcamInterfacePublic.quaternionToEuler(Qt.quaternion(parseFloat(quaternions.itemAt(0).text),
                                                                                  parseFloat(quaternions.itemAt(1).text),
                                                                                  parseFloat(quaternions.itemAt(2).text),
                                                                                  parseFloat(quaternions.itemAt(3).text)),
                                                                                  cbSequence.currentValue);
                    eulerRots.itemAt(0).text = IrbcamInterfacePublic.radToDeg(euler.x).toFixed(3);
                    eulerRots.itemAt(1).text = IrbcamInterfacePublic.radToDeg(euler.y).toFixed(3);
                    eulerRots.itemAt(2).text = IrbcamInterfacePublic.radToDeg(euler.z).toFixed(3);
                }
            }
        }

        // Tait-Bryan sequence selection
        RowLayout {
            Label {
                text: "Sequence"
                horizontalAlignment: Text.AlignHCenter
                Layout.preferredWidth: cbSequence.width
            }

            // ComboBox to select Tait-Bryan rotation sequence.
            ComboBox {
                id: cbSequence
                Layout.preferredWidth: 200
                textRole: "sequence"
                valueRole: "value"
                model: ListModel {
                    id: listModel
                    ListElement {
                        sequence: "xyz"
                        value: IrbcamInterfacePublic.Xyz
                    }
                    ListElement {
                        sequence: "xzy"
                        value: IrbcamInterfacePublic.Xzy
                    }
                    ListElement {
                        sequence: "yxz"
                        value: IrbcamInterfacePublic.Yxz
                    }
                    ListElement {
                        sequence: "yzx"
                        value: IrbcamInterfacePublic.Yzx
                    }
                    ListElement {
                        sequence: "zxy"
                        value: IrbcamInterfacePublic.Zxy
                    }
                    ListElement {
                        sequence: "zyx"
                        value: IrbcamInterfacePublic.Zyx
                    }
                    ListElement {
                        sequence: "zyz"
                        value: IrbcamInterfacePublic.Zyz
                    }
                }
            }
        }
    }

    // Quaternion text fields
    ColumnLayout {
        Repeater {
            id: quaternions
            model: ["w", "x", "y", "z"]
            delegate: componentField
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

    // Text fields
    Component {
        id: componentField
        RowLayout {
            property alias text: tf.text
            Label {
                text: modelData
                Layout.rightMargin: 7  // Spacing between label and text field
            }
            TextField {
                id: tf
                text: "0.0"
                validator: DoubleValidator{ decimals: 7 }
            }
        }
    }
}
