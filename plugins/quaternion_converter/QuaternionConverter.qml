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
    layoutDirection: Qt.LeftToRight
    flow: GridView.FlowLeftToRight
    Component.onCompleted: angles2quat()


    component MyComponent : RowLayout {
        property alias value: tf.value
        property string labelText
        property alias precision: tf.precision
        Label {
            text: labelText
            Layout.rightMargin: 7  // Spacing between label and text field
            Layout.preferredWidth: 70
        }
        TextField {
            id: tf
            property double value: 0.0
            property int precision: 7
            text: value.toFixed(precision)
            validator: DoubleValidator {
                decimals: precision
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

    // Convert Tait-bryan angles to Quaternion using rotation sequence from cbSequence. Updates values stored in repeater "quaternions"
    function angles2quat() {
        var quat = IrbcamInterfacePublic.eulerToQuaternion(IrbcamInterfacePublic.degToRad(eulerFirst.value),
                                                           IrbcamInterfacePublic.degToRad(eulerSecond.value),
                                                           IrbcamInterfacePublic.degToRad(eulerThird.value),
                                                           cbSequence.currentValue);
        quatw.value = quat.scalar;
        quatx.value = quat.x;
        quaty.value = quat.y;
        quatz.value = quat.z;
    }

    // Convert Quaternion to Tait-bryan angles  using rotation sequence from cbSequence. Updates values stored in repeater "eulerRots"
    function quat2angles() {
        var euler = IrbcamInterfacePublic.quaternionToEuler(Qt.quaternion(quatw.value,
                                                                          quatx.value,
                                                                          quaty.value,
                                                                          quatz.value),
                                                            cbSequence.currentValue);
        eulerFirst.value = IrbcamInterfacePublic.radToDeg(euler.x);
        eulerSecond.value = IrbcamInterfacePublic.radToDeg(euler.y);
        eulerThird.value = IrbcamInterfacePublic.radToDeg(euler.z);
    }


    // Tait-Bryan text fields
    ColumnLayout {
        MyComponent {
            id: eulerFirst
            labelText: "RX (deg)"
            precision: 4
        }
        MyComponent {
            id: eulerSecond
            labelText: "RY (deg)"
            precision: 4
        }
        MyComponent {
            id: eulerThird
            labelText: "RZ (deg)"
            precision: 4
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
                onClicked: quat2angles()
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
                onCurrentValueChanged: {
                    switch(currentValue) {
                        case IrbcamInterfacePublic.Xyz:
                            eulerFirst.labelText = "RX (deg)"
                            eulerSecond.labelText = "RY (deg)"
                            eulerThird.labelText = "RZ (deg)"
                            break;
                        case IrbcamInterfacePublic.Xzy:
                            eulerFirst.labelText = "RX (deg)"
                            eulerSecond.labelText = "RZ (deg)"
                            eulerThird.labelText = "RY (deg)"
                            break;
                        case IrbcamInterfacePublic.Yxz:
                            eulerFirst.labelText = "RY (deg)"
                            eulerSecond.labelText = "RX (deg)"
                            eulerThird.labelText = "RZ (deg)"
                            break;
                        case IrbcamInterfacePublic.Yzx:
                            eulerFirst.labelText = "RY (deg)"
                            eulerSecond.labelText = "RZ (deg)"
                            eulerThird.labelText = "RX (deg)"
                            break;
                        case IrbcamInterfacePublic.Zxy:
                            eulerFirst.labelText = "RZ (deg)"
                            eulerSecond.labelText = "RX (deg)"
                            eulerThird.labelText = "RY (deg)"
                            break;
                        case IrbcamInterfacePublic.Zyx:
                            eulerFirst.labelText = "RZ (deg)"
                            eulerSecond.labelText = "RY (deg)"
                            eulerThird.labelText = "RX (deg)"
                            break;
                        case IrbcamInterfacePublic.Zyz:
                            eulerFirst.labelText = "RZ (deg)"
                            eulerSecond.labelText = "RY (deg)"
                            eulerThird.labelText = "RZ (deg)"
                            break;
                    }
                }
            }
        }
    }

    // Quaternion text fields
    ColumnLayout {
        MyComponent {
            id: quatw
            labelText: "w"
            precision: 7
        }
        MyComponent {
            id: quatx
            labelText: "x"
            precision: 7
        }
        MyComponent {
            id: quaty
            labelText: "y"
            precision: 7
        }
        MyComponent {
            id: quatz
            labelText: "z"
            precision: 7
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
