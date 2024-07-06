/*
    This plugin uses functions eulerToQuaternion, quaternionToEuler, quaternionToMatrix, and matrixToQuaternion from IRBCAM public interface to convert from one rotation representation (Tait-Bryan angles, Quaterion and Rotation Matrix) to another.
*/

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

import "./resources"
/*
    Plugins are loaded within a QML popup. Pack your content into a single component to get proper sizing.
    See https://doc.qt.io/qt-6/qml-qtquick-controls-popup.html#popup-sizing
*/
GridLayout {
    id: root
    columns: 2
    columnSpacing: 20
    layoutDirection: Qt.LeftToRight
    flow: GridView.FlowLeftToRight

    function eul2Quat(eulerAngles, rotationSequence) {
        let quat = IrbcamInterfacePublic.eulerToQuaternion(IrbcamInterfacePublic.degToRad(eulerAngles.x), //eulerFirst
                                                           IrbcamInterfacePublic.degToRad(eulerAngles.y), //eulerSecond
                                                           IrbcamInterfacePublic.degToRad(eulerAngles.z), //eulerThird
                                                           rotationSequence);
        return quat;
    }

    function quat2Eul(quat, rotationSequence) {
        let euler = IrbcamInterfacePublic.quaternionToEuler(quat, rotationSequence);
        return Qt.vector3d(IrbcamInterfacePublic.radToDeg(euler.x),
                           IrbcamInterfacePublic.radToDeg(euler.y),
                           IrbcamInterfacePublic.radToDeg(euler.z));
    }

    function quat2Mat(quat) {
        let mat = IrbcamInterfacePublic.quaternionToMatrix(quat);
        return mat;
    }

    function mat2Quat(mat) {
        let quat = IrbcamInterfacePublic.matrixToQuaternion(mat);
        return quat;
    }

    ColumnLayout {

        SeparatorLabel {
            text: "Input"
        }

        EulerAngle {
            id: inEul
            onRotationSequenceChanged: {
                convertFromEuler(inEul.eulerAngles);
            }
            onInputUpdated: function(value) {
                convertFromEuler(value)
            }
            function convertFromEuler(eulerAngles) {
                inQuat.quat = eul2Quat(eulerAngles, inEul.rotationSequence)
                inRotMat.rotMat = quat2Mat(inQuat.quat)
            }
        }

        Separator {
            Layout.fillWidth: true
        }

        Quaternion {
            id: inQuat
            onInputUpdated: function(value) {
                inEul.eulerAngles = quat2Eul(value.normalized(), inEul.rotationSequence)
                inRotMat.rotMat = quat2Mat(value.normalized())
            }
            onQuatChanged: {
                outQuat.quat = inQuat.quat.normalized()
            }
        }

        Separator {
            Layout.fillWidth: true
        }

        RotationMatrix {
            id: inRotMat
            onInputUpdated: function(value) {
                inQuat.quat = mat2Quat(value)
                inEul.eulerAngles = quat2Eul(inQuat.quat, inEul.rotationSequence)
            }
        }
    }

    ColumnLayout {

        SeparatorLabel {
            text: "Output"
        }

        EulerAngle {
            id: outEul
            readOnly: true
            onRotationSequenceChanged: {
                outEul.eulerAngles = quat2Eul(outQuat.quat, outEul.rotationSequence)
            }
        }

        Separator {
            Layout.fillWidth: true
        }

        Quaternion {
            id: outQuat
            readOnly: true
            onQuatChanged: {
                outEul.eulerAngles = quat2Eul(outQuat.quat, outEul.rotationSequence)
                outRotMat.rotMat = quat2Mat(outQuat.quat)
            }
        }

        Separator {
            Layout.fillWidth: true
        }

        RotationMatrix {
            id: outRotMat
            readOnly: true
        }
    }

    // Close button
    Button {
        Layout.topMargin: 50
        Layout.columnSpan: 2
        Layout.alignment: Qt.AlignRight
        text: "Close"
        onClicked: pluginWindow.close()
    }
}
