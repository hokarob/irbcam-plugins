/*
    Motoman and Fanuc have different definitions of the tool frame compared to ABB and KUKA.
    For Motoman and Fanuc robots, the tool frame is rotated 180 degrees about the Z axis compared to ABB and KUKA.
    IRBCAM has chosen to use the same tool frame definition as ABB and KUKA.
    Hence, this plugin (tool data/frame converter) can be used when Motoman and Fabuc robot users want to transfer tooldata from their teach pendants to the IRBCAM app.
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

import "./resources/transformations.js" as Transform

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


    // IRBCAM Tool data
    ColumnLayout {
        Label {
            text: "IRBCAM:"
            horizontalAlignment: Text.AlignHCenter
        }

        Repeater {
            id: irbcamTool
            model: ["X (mm)", "Y (mm)", "Z (mm)", "RX (deg)", "RY (deg)", "RZ (deg)"]
            delegate: componentField
        }
    }

    ColumnLayout {
        RowLayout {
            Button {
                id: btnleft
                Layout.preferredWidth: 70
                text: ">"
                onClicked: {
                    //irbcam tool translation
                    var irbcamToolTran = Qt.vector3d(parseFloat(irbcamTool.itemAt(0).text),
                                                     parseFloat(irbcamTool.itemAt(1).text),
                                                     parseFloat(irbcamTool.itemAt(2).text));
                    // irbcam tool rotation
                    var irbcamToolQuat = IrbcamInterfacePublic.eulerToQuaternion(IrbcamInterfacePublic.degToRad(parseFloat(irbcamTool.itemAt(3).text)),
                                                                                 IrbcamInterfacePublic.degToRad(parseFloat(irbcamTool.itemAt(4).text)),
                                                                                 IrbcamInterfacePublic.degToRad(parseFloat(irbcamTool.itemAt(5).text)),
                                                                                 IrbcamInterfacePublic.Xyz);


                    // rotate 180 deg about z-axis
                    var newRot = Transform.quat2rotm(irbcamToolQuat).times(Transform.rotZ(IrbcamInterfacePublic.degToRad(180)));
                    // RPY(gamma, beta, alpha) <=> ZYX(alpha, beta, gamma)
                    var fanucMotoToolEuler = IrbcamInterfacePublic.quaternionToEuler(Transform.rotm2Quat(newRot), IrbcamInterfacePublic.Xyz);


                    var fanucMotoToolTran = Qt.vector3d(0,0,0);
                    fanucMotoToolTran.x = -irbcamToolTran.x;
                    fanucMotoToolTran.y = -irbcamToolTran.y;
                    fanucMotoToolTran.z = irbcamToolTran.z;


                    fanucMotoTool.itemAt(0).text = fanucMotoToolTran.x.toFixed(root.precision);
                    fanucMotoTool.itemAt(1).text = fanucMotoToolTran.y.toFixed(root.precision);
                    fanucMotoTool.itemAt(2).text = fanucMotoToolTran.z.toFixed(root.precision);
                    fanucMotoTool.itemAt(3).text = IrbcamInterfacePublic.radToDeg(fanucMotoToolEuler.x).toFixed(root.precision);
                    fanucMotoTool.itemAt(4).text = IrbcamInterfacePublic.radToDeg(fanucMotoToolEuler.y).toFixed(root.precision);
                    fanucMotoTool.itemAt(5).text = IrbcamInterfacePublic.radToDeg(fanucMotoToolEuler.z).toFixed(root.precision);
                }
            }

            Button {
                id: btnright
                Layout.preferredWidth: 70
                text: "<"
                onClicked: {
                    //fanuc/motoman tool translation
                    var fanucMotoToolTran = Qt.vector3d(parseFloat(fanucMotoTool.itemAt(0).text),
                                                        parseFloat(fanucMotoTool.itemAt(1).text),
                                                        parseFloat(fanucMotoTool.itemAt(2).text));
                    // irbcam tool rotation
                    var fanucMotoToolQuat = IrbcamInterfacePublic.eulerToQuaternion(IrbcamInterfacePublic.degToRad(parseFloat(fanucMotoTool.itemAt(3).text)),
                                                                                    IrbcamInterfacePublic.degToRad(parseFloat(fanucMotoTool.itemAt(4).text)),
                                                                                    IrbcamInterfacePublic.degToRad(parseFloat(fanucMotoTool.itemAt(5).text)),
                                                                                    IrbcamInterfacePublic.Xyz);


                    // rotate 180 deg about z-axis
                    var newRot = Transform.quat2rotm(fanucMotoToolQuat).times(Transform.rotZ(IrbcamInterfacePublic.degToRad(180)));
                    var irbcamToolEuler = IrbcamInterfacePublic.quaternionToEuler(Transform.rotm2Quat(newRot), IrbcamInterfacePublic.Zyx);

                    var irbcamToolTran = Qt.vector3d(0,0,0);
                    irbcamToolTran.x = -fanucMotoToolTran.x;
                    irbcamToolTran.y = -fanucMotoToolTran.y;
                    irbcamToolTran.z = fanucMotoToolTran.z;


                    irbcamTool.itemAt(0).text = irbcamToolTran.x.toFixed(root.precision);
                    irbcamTool.itemAt(1).text = irbcamToolTran.y.toFixed(root.precision);
                    irbcamTool.itemAt(2).text = irbcamToolTran.z.toFixed(root.precision);
                    irbcamTool.itemAt(3).text = IrbcamInterfacePublic.radToDeg(irbcamToolEuler.x).toFixed(root.precision);
                    irbcamTool.itemAt(4).text = IrbcamInterfacePublic.radToDeg(irbcamToolEuler.y).toFixed(root.precision);
                    irbcamTool.itemAt(5).text = IrbcamInterfacePublic.radToDeg(irbcamToolEuler.z).toFixed(root.precision);
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
        Repeater {
            id: fanucMotoTool
            model: ["X (mm)", "Y (mm)", "Z (mm)", "Y (deg)", "P (deg)", "R (deg)"]
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
    }
}
