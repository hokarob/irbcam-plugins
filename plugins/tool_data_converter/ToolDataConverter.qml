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

    MOTOMAN/FANUC: RPY (with respect to fixed frame)
    X - Translation along X-axis
    Y - Translation along Y-axis
    Z - Translation along Z-axis
    R - Roll (Rotation around X-axis of the fixed frame)
    P - Pitch (Rotation around Y-axis of the fixed frame)
    Y - Yaw (Rotation around Z-axis of the fixed frame)
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

                    // irbcam tool rotation
                    var irbcamToolQuat = IrbcamInterfacePublic.eulerToQuaternion(IrbcamInterfacePublic.degToRad(irbcamRx.value), //gamma(rx)
                                                                                 IrbcamInterfacePublic.degToRad(irbcamRy.value), //beta(ry)
                                                                                 IrbcamInterfacePublic.degToRad(irbcamRz.value), //alpha(rz)
                                                                                 IrbcamInterfacePublic.Zyx); //ZYX(alpha, beta, gamma) // Rotation sequence alpha(rz), beta(ry), gamma(rx)
                    // prerotate 180 deg about z-axis because the sequence is ZYX
                    var newRot = Transform.rotZ(IrbcamInterfacePublic.degToRad(180)).times(Transform.quat2rotm(irbcamToolQuat));
                    var newQuat = Transform.rotm2Quat(newRot);

                    // RPY(gamma, beta, alpha) <=> ZYX(alpha, beta, gamma)
                    var fanucMotoToolEuler = IrbcamInterfacePublic.quaternionToEuler(newQuat, IrbcamInterfacePublic.Zyx); // gamma, beta, alpha // Returning sequence gamma(rx) beta(ry) alpha(rz)
                    var fanucMotoToolRpy = IrbcamInterfacePublic.quaternionToRpy(newQuat); // Returning sequence roll(rx), pitch(ry), yaw(rz)

                    // prerotate 180 deg about z-axis because the sequence is ZYX
                    var newRotH = Transform.rotZ(IrbcamInterfacePublic.degToRad(180)).times(IrbcamInterfacePublic.quaternionToMatrix(irbcamToolQuat));
                    var newQuatH = IrbcamInterfacePublic.matrixToQuaternion(newRotH);

                    // RPY(gamma, beta, alpha) <=> ZYX(alpha, beta, gamma)
                    var fanucMotoToolEulerH = IrbcamInterfacePublic.quaternionToEuler(newQuatH, IrbcamInterfacePublic.Zyx); // gamma, beta, alpha // Returning sequence gamma(rx) beta(ry) alpha(rz)
                    var fanucMotoToolRpyH = IrbcamInterfacePublic.quaternionToRpy(newQuatH); // Returning sequence roll(rx), pitch(ry), yaw(rz)


                    fanucMotoTx.value = -irbcamTx.value;
                    fanucMotoTy.value = -irbcamTy.value;
                    fanucMotoTz.value = irbcamTz.value;

                    fanucMotoRr.value = IrbcamInterfacePublic.radToDeg(fanucMotoToolRpyH.x); // fanucMotoToolEulerH.z  // fanucMotoToolEuler.z // fanucMotoToolRpyH.x  // fanucMotoToolRpy.x // alpha(rz) // roll(rx)
                    fanucMotoRp.value = IrbcamInterfacePublic.radToDeg(fanucMotoToolRpyH.y); // fanucMotoToolEulerH.y  // fanucMotoToolEuler.y // fanucMotoToolRpyH.y  // fanucMotoToolRpy.y // beta(ry) // pitch(ry)
                    fanucMotoRy.value = IrbcamInterfacePublic.radToDeg(fanucMotoToolRpyH.z); // fanucMotoToolEulerH.x  // fanucMotoToolEuler.x // fanucMotoToolRpyH.z  // fanucMotoToolRpy.z // gamma(rx) // yaw(rz)
                }
            }

            Button {
                id: btnright
                Layout.preferredWidth: 70
                text: "<"
                onClicked: {

                    var fanucMotoToolQuat = IrbcamInterfacePublic.eulerToQuaternion(IrbcamInterfacePublic.degToRad(fanucMotoRr.value), // roll(rx)
                                                                                    IrbcamInterfacePublic.degToRad(fanucMotoRp.value), // pitch(ry)
                                                                                    IrbcamInterfacePublic.degToRad(fanucMotoRy.value), // yaw(rz)
                                                                                    IrbcamInterfacePublic.Zyx); //ZYX(alpha, beta, gamma) // Rotation sequence alpha(rz), beta(ry), gamma(rx)

                    // prerotate -180 deg about z-axis because the sequence is ZYX
                    var newRot = Transform.rotZ(IrbcamInterfacePublic.degToRad(-180)).times(Transform.quat2rotm(fanucMotoToolQuat));
                    var newQuat = Transform.rotm2Quat(newRot);

                    // RPY(gamma, beta, alpha) <=> ZYX(alpha, beta, gamma)
                    var irbcamToolEuler = IrbcamInterfacePublic.quaternionToEuler(newQuat, IrbcamInterfacePublic.Zyx); // gamma, beta, alpha // Returning sequence gamma(rx) beta(ry) alpha(rz)
                    var irbcamToolRpy = IrbcamInterfacePublic.quaternionToRpy(newQuat); // Returning sequence roll(rx), pitch(ry), yaw(rz)

                    // prerotate 180 deg about z-axis because the sequence is ZYX
                    var newRotH = Transform.rotZ(IrbcamInterfacePublic.degToRad(-180)).times(IrbcamInterfacePublic.quaternionToMatrix(fanucMotoToolQuat));
                    var newQuatH = IrbcamInterfacePublic.matrixToQuaternion(newRotH);

                    // RPY(gamma, beta, alpha) <=> ZYX(alpha, beta, gamma)
                    var irbcamToolEulerH = IrbcamInterfacePublic.quaternionToEuler(newQuatH, IrbcamInterfacePublic.Zyx); // gamma, beta, alpha // Returning sequence gamma(rx) beta(ry) alpha(rz)
                    var irbcamToolRpyH = IrbcamInterfacePublic.quaternionToRpy(newQuatH); // Returning sequence roll(rx), pitch(ry), yaw(rz)


                    irbcamTx.value = -fanucMotoTx.value;
                    irbcamTy.value = -fanucMotoTy.value;
                    irbcamTz.value = fanucMotoTz.value;

                    irbcamRx.value = IrbcamInterfacePublic.radToDeg(irbcamToolRpyH.z); //irbcamToolEulerH.x //irbcamToolEuler.x // irbcamToolRpyH.z // irbcamToolRpy.z // gamma(rx) // yaw(rz)
                    irbcamRy.value = IrbcamInterfacePublic.radToDeg(irbcamToolRpyH.y); //irbcamToolEulerH.y //irbcamToolEuler.y // irbcamToolRpyH.y // irbcamToolRpy.y // beta(ry) // pitch(ry)
                    irbcamRz.value = IrbcamInterfacePublic.radToDeg(irbcamToolRpyH.x); //irbcamToolEulerH.z //irbcamToolEuler.z // irbcamToolRpyH.x // irbcamToolRpy.x // alpha(rz) // roll(rx)

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
            id: fanucMotoRr
            labelText: "R (deg)"
        }

        MyComponent {
            id: fanucMotoRp
            labelText: "P (deg)"
        }

        MyComponent {
            id: fanucMotoRy
            labelText: "Y (deg)"
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
