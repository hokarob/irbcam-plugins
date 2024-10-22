import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick3D

// Import HOKAROB theme
import HokarobQml.Theme
// Import HOKAROB Controls library
import HokarobQml.Controls


// Import IRBCAM public interface
import IRBCAM.InterfacePublic

GridLayout {
    id: root
    columns: 2
    columnSpacing: 20
    layoutDirection: Qt.LeftToRight
    flow: GridView.FlowLeftToRight

    property vector3d eulerAngles: Qt.vector3d(0,0,0) // deg
    property int rotationSequence: cbSequence.currentValue
    property int precision: 4
    property bool readOnly: false

    signal inputUpdated(vector3d value)

    Label {
        text: "Euler Angles"
    }

    // Tait-Bryan sequence selection
    // ComboBox to select Tait-Bryan rotation sequence.
    ComboBox {
        id: cbSequence
        Layout.fillWidth:  true
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

    Label {
        id: eulerFirstLabel
        text: (cbSequence.currentValue === IrbcamInterfacePublic.Zyz) ? "RZ1 (deg)" : "RX (deg)"
    }

    TextField {
        Layout.fillWidth: true
        readOnly: root.readOnly

        text: root.eulerAngles.x.toFixed(root.precision)
        validator: DoubleValidator {
            decimals: root.precision
            locale: "en_us"
        }
        onActiveFocusChanged: {
            if (activeFocus)
                selectAll()
        }
        onEditingFinished: {
            let temp = root.eulerAngles
            temp.x = text
            inputUpdated(temp)
        }
    }

    Label {
        id: eulerSecondLabel
        text: "RY (deg)"
    }

    TextField {
        Layout.fillWidth: true
        readOnly: root.readOnly

        text: root.eulerAngles.y.toFixed(root.precision)
        validator: DoubleValidator {
            decimals: root.precision
            locale: "en_us"
        }
        onActiveFocusChanged: {
            if (activeFocus)
                selectAll()
        }
        onEditingFinished: {
            let temp = root.eulerAngles
            temp.y = text
            inputUpdated(temp)
        }
    }

    Label {
        id: eulerThirdLabel
        text: (cbSequence.currentValue === IrbcamInterfacePublic.Zyz) ? "RZ2 (deg)" : "RZ (deg)"
    }

    TextField {
        Layout.fillWidth: true
        readOnly: root.readOnly
        text: root.eulerAngles.z.toFixed(root.precision)
        validator: DoubleValidator {
            decimals: root.precision
            locale: "en_us"
        }
        onActiveFocusChanged: {
            if (activeFocus)
                selectAll()
        }
        onEditingFinished: {
            let temp = root.eulerAngles
            temp.z = text
            inputUpdated(temp)
        }
    }   
}
