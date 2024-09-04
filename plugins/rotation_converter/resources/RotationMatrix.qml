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
    columns: 3
    columnSpacing: 20
    layoutDirection: Qt.LeftToRight
    flow: GridView.FlowLeftToRight

    property matrix4x4 rotMat: Qt.matrix4x4()
    property int precision: 7
    property bool readOnly: false
    property bool validRot: Math.abs(root.rotMat.determinant() - 1) < 0.00001 && root.rotMat.times(root.rotMat.transposed()).fuzzyEquals(Qt.matrix4x4(), 0.00001)

    signal inputUpdated(matrix4x4 value)

    RowLayout {
        Layout.columnSpan: 3

        Label {
            text: "Rotation Matrix"
            Layout.fillWidth: true
        }

        Label {
            color: Colours.red
            text: validRot ? "" : "invalid"
        }
    }

    TextField {
        Layout.fillWidth: true
        readOnly: root.readOnly
        text: root.rotMat.m11.toFixed(root.precision)
        validator: DoubleValidator {
            decimals: precision
            locale: "en_us"
        }
        onActiveFocusChanged: {
            if (activeFocus)
                selectAll()
        }
        onEditingFinished: {
            //            root.rotMat.m11 = text
            let temp = root.rotMat
            temp.m11 = text
            inputUpdated(temp)
        }
    }

    TextField {
        Layout.fillWidth: true
        readOnly: root.readOnly
        text: root.rotMat.m12.toFixed(root.precision)
        validator: DoubleValidator {
            decimals: precision
            locale: "en_us"
        }
        onActiveFocusChanged: {
            if (activeFocus)
                selectAll()
        }
        onEditingFinished: {
            //            root.rotMat.m12 = text
            let temp = root.rotMat
            temp.m12 = text
            inputUpdated(temp)
        }
    }

    TextField {
        Layout.fillWidth: true
        readOnly: root.readOnly
        text: root.rotMat.m13.toFixed(root.precision)
        validator: DoubleValidator {
            decimals: precision
            locale: "en_us"
        }
        onActiveFocusChanged: {
            if (activeFocus)
                selectAll()
        }
        onEditingFinished: {
            //            root.rotMat.m13 = text
            let temp = root.rotMat
            temp.m13 = text
            inputUpdated(temp)
        }
    }

    TextField {
        Layout.fillWidth: true
        readOnly: root.readOnly
        text: root.rotMat.m21.toFixed(root.precision)
        validator: DoubleValidator {
            decimals: precision
            locale: "en_us"
        }
        onActiveFocusChanged: {
            if (activeFocus)
                selectAll()
        }
        onEditingFinished: {
            //            root.rotMat.m21 = text
            let temp = root.rotMat
            temp.m21 = text
            inputUpdated(temp)
        }
    }

    TextField {
        Layout.fillWidth: true
        readOnly: root.readOnly
        text: root.rotMat.m22.toFixed(root.precision)
        validator: DoubleValidator {
            decimals: precision
            locale: "en_us"
        }
        onActiveFocusChanged: {
            if (activeFocus)
                selectAll()
        }
        onEditingFinished: {
            //            root.rotMat.m22 = text
            let temp = root.rotMat
            temp.m22 = text
            inputUpdated(temp)
        }
    }

    TextField {
        Layout.fillWidth: true
        readOnly: root.readOnly
        text: root.rotMat.m23.toFixed(root.precision)
        validator: DoubleValidator {
            decimals: precision
            locale: "en_us"
        }
        onActiveFocusChanged: {
            if (activeFocus)
                selectAll()
        }
        onEditingFinished: {
            //            root.rotMat.m23 = text
            let temp = root.rotMat
            temp.m23 = text
            inputUpdated(temp)
        }
    }

    TextField {
        Layout.fillWidth: true
        readOnly: root.readOnly
        text: root.rotMat.m31.toFixed(root.precision)
        validator: DoubleValidator {
            decimals: precision
            locale: "en_us"
        }
        onActiveFocusChanged: {
            if (activeFocus)
                selectAll()
        }
        onEditingFinished: {
            //            root.rotMat.m31 = text
            let temp = root.rotMat
            temp.m31 = text
            inputUpdated(temp)
        }
    }

    TextField {
        Layout.fillWidth: true
        readOnly: root.readOnly
        text: root.rotMat.m32.toFixed(root.precision)
        validator: DoubleValidator {
            decimals: precision
            locale: "en_us"
        }
        onActiveFocusChanged: {
            if (activeFocus)
                selectAll()
        }
        onEditingFinished: {
            //            root.rotMat.m32 = text
            let temp = root.rotMat
            temp.m32 = text
            inputUpdated(temp)
        }
    }

    TextField {
        Layout.fillWidth: true
        readOnly: root.readOnly
        text: root.rotMat.m33.toFixed(root.precision)
        validator: DoubleValidator {
            decimals: precision
            locale: "en_us"
        }
        onActiveFocusChanged: {
            if (activeFocus)
                selectAll()
        }
        onEditingFinished: {
            //            root.rotMat.m33 = text
            let temp = root.rotMat
            temp.m33 = text
            inputUpdated(temp)
        }
    }
}
