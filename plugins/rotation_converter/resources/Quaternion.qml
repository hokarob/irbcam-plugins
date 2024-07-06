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


    property quaternion quat: Qt.quaternion(1,0,0,0)
    property int precision: 7
    property bool readOnly: false

    signal inputUpdated(quaternion value)


    Label {
        text: "Quaternions"
        Layout.columnSpan: 2
        Layout.fillWidth: true
    }

    Label {
        text: "w"
    }

    TextField {
        Layout.fillWidth: true
        readOnly: root.readOnly
        text: root.quat.scalar.toFixed(root.precision)
        validator: DoubleValidator {
            decimals: root.precision
            locale: "en_us"
        }
        onActiveFocusChanged: {
            if (activeFocus)
                selectAll()
        }
        onEditingFinished: {
            //            root.quat.scalar = text
            let temp = root.quat
            temp.scalar = text
            inputUpdated(temp)
        }
        onAccepted: {
            if (acceptableInput)
                nextItemInFocusChain().forceActiveFocus();
        }
    }

    Label {
        text: "x"
    }

    TextField {
        Layout.fillWidth: true
        readOnly: root.readOnly
        text: root.quat.x.toFixed(root.precision)
        validator: DoubleValidator {
            decimals: root.precision
            locale: "en_us"
        }
        onActiveFocusChanged: {
            if (activeFocus)
                selectAll()
        }
        onEditingFinished: {
            //            root.quat.x = text
            let temp = root.quat
            temp.x = text
            inputUpdated(temp)
        }
        onAccepted: {
            if (acceptableInput)
                nextItemInFocusChain().forceActiveFocus();
        }
    }

    Label {
        text: "y"
    }

    TextField {
        Layout.fillWidth: true
        readOnly: root.readOnly
        text: root.quat.y.toFixed(root.precision)
        validator: DoubleValidator {
            decimals: root.precision
            locale: "en_us"
        }
        onActiveFocusChanged: {
            if (activeFocus)
                selectAll()
        }
        onEditingFinished: {
            //            root.quat.y = text
            let temp = root.quat
            temp.y = text
            inputUpdated(temp)
        }
        onAccepted: {
            if (acceptableInput)
                nextItemInFocusChain().forceActiveFocus();
        }
    }


    Label {
        text: "z"
    }

    TextField {
        Layout.fillWidth: true
        readOnly: root.readOnly
        text:root.quat.z.toFixed(root.precision)
        validator: DoubleValidator {
            decimals: root.precision
            locale: "en_us"
        }
        onActiveFocusChanged: {
            if (activeFocus)
                selectAll()
        }
        onEditingFinished: {
            //            root.quat.z = text
            let temp = root.quat
            temp.z = text
            inputUpdated(temp)
        }
        onAccepted: {
            if (acceptableInput)
                nextItemInFocusChain().forceActiveFocus();
        }
    }
}
