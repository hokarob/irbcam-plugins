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

    property vector3d eulerAngles: Qt.vector3d(0,0,0) // eulerFirst, eulerSecond, eulerThird in deg
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
        onCurrentValueChanged: {
            switch(currentValue) {
                case IrbcamInterfacePublic.Xyz:
                    eulerFirstLabel.text = "RX (deg)"
                    eulerSecondLabel.text = "RY (deg)"
                    eulerThirdLabel.text = "RZ (deg)"
                    break;
                case IrbcamInterfacePublic.Xzy:
                    eulerFirstLabel.text = "RX (deg)"
                    eulerSecondLabel.text = "RZ (deg)"
                    eulerThirdLabel.text = "RY (deg)"
                    break;
                case IrbcamInterfacePublic.Yxz:
                    eulerFirstLabel.text = "RY (deg)"
                    eulerSecondLabel.text = "RX (deg)"
                    eulerThirdLabel.text = "RZ (deg)"
                    break;
                case IrbcamInterfacePublic.Yzx:
                    eulerFirstLabel.text = "RY (deg)"
                    eulerSecondLabel.text = "RZ (deg)"
                    eulerThirdLabel.text = "RX (deg)"
                    break;
                case IrbcamInterfacePublic.Zxy:
                    eulerFirstLabel.text = "RZ (deg)"
                    eulerSecondLabel.text = "RX (deg)"
                    eulerThirdLabel.text = "RY (deg)"
                    break;
                case IrbcamInterfacePublic.Zyx:
                    eulerFirstLabel.text = "RZ (deg)"
                    eulerSecondLabel.text = "RY (deg)"
                    eulerThirdLabel.text = "RX (deg)"
                    break;
                case IrbcamInterfacePublic.Zyz:
                    eulerFirstLabel.text = "RZ (deg)"
                    eulerSecondLabel.text = "RY (deg)"
                    eulerThirdLabel.text = "RZ (deg)"
                    break;
            }
        }
    }

    Label {
        id: eulerFirstLabel
        text: "RX (deg)"
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
//            root.eulerAngles.x = text
            let temp = root.eulerAngles
            temp.x = text
            inputUpdated(temp)
        }
        onAccepted: {
            if (acceptableInput)
                nextItemInFocusChain().forceActiveFocus();
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
//            root.eulerAngles.y = text
            let temp = root.eulerAngles
            temp.y = text
            inputUpdated(temp)
        }
        onAccepted: {
            if (acceptableInput)
                nextItemInFocusChain().forceActiveFocus();
        }
    }

    Label {
        id: eulerThirdLabel
        text: "RZ (deg)"
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
//            root.eulerAngles.z = text
            let temp = root.eulerAngles
            temp.z = text
            inputUpdated(temp)
        }
        onAccepted: {
            if (acceptableInput)
                nextItemInFocusChain().forceActiveFocus();
        }
    }   
}
