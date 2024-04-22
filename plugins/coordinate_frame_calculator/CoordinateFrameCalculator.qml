/*
    This plugin is used to calculate coordinate frame from origin, and two target positions on axes or planes  all represented with respect to the global frame or robot base frame. The calculated frame can be directly copied into the station.

    Origin:
        X - x-position of the origin
        Y - y-position of the origin
        Z - z-position of the origin

    X-Axis:
        X - x-position of point on x-axis
        Y - y-position of point on x-axis
        Z - z-position of point on x-axis
    Y-Axis:
        X - x-position of point on y-axis
        Y - y-position of point on y-axis
        Z - z-position of point on y-axis
    Z-Axis:
        X - x-position of point on z-axis
        Y - y-position of point on z-axis
        Z - z-position of point on z-axis
    XY-Plane:
        X - x-position of point on XY-plane
        Y - y-position of point on XY-plane
        Z - z-position of point on XY-plane
    YZ-Plane:
        X - x-position of point on YZ-plane
        Y - y-position of point on YZ-plane
        Z - z-position of point on YZ-plane

    ZX-Plane:
        X - x-position of point on ZX-plane
        Y - y-position of point on ZX-plane
        Z - z-position of point on ZX-plane

*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick3D

// Import IRBCAM theme
import IrbcamQml.Theme
import IrbcamQml.UiStyle
import IrbcamQml.Controls


import IRBCAM.InterfacePublic

/*
    Plugins are loaded within a QML popup. Pack your content into a single component to get proper sizing.
    See https://doc.qt.io/qt-6/qml-qtquick-controls-popup.html#popup-sizing
*/
ColumnLayout {
    id: root

    property int precision: 4

    property var framePosition: Qt.vector3d(0,0,0)
    property var frameRotation: Qt.quaternion(1.0,0,0,0)
    property var frameEulerAngles: IrbcamInterfacePublic.quaternionToRpy(frameRotation)
    property bool validFrame: false
    property bool isComputed: false

    enum AxisEnum
    {
        XAxis = 0, // can be accessed as CoordinateFrameCalculator.XAxis
        YAxis,
        ZAxis,
        XYPlane,
        YZPlane,
        ZXPlane
    }

    function compute() {
        root.isComputed = true
        root.validFrame = false
        root.frameRotation = Qt.quaternion(1.0,0,0,0)
        root.framePosition = Qt.vector3d(0,0,0)

        var xaxisNormalized = Qt.vector3d(1.0,0,0)
        var yaxisNormalized = Qt.vector3d(0,1.0,0)
        var zaxisNormalized = Qt.vector3d(0,0,1.0)
        //X-Y
        if (cbaxis1.currentValue === CoordinateFrameCalculator.XAxis && cbaxis2.currentValue === CoordinateFrameCalculator.YAxis)
        {
            const xaxis = Qt.vector3d(target1Tx.value - originTx.value, target1Ty.value - originTy.value, target1Tz.value - originTz.value)
            const yaxis = Qt.vector3d(target2Tx.value - originTx.value, target2Ty.value - originTy.value, target2Tz.value - originTz.value)
            xaxisNormalized = xaxis.normalized()
            yaxisNormalized = yaxis.normalized()
            zaxisNormalized = xaxisNormalized.crossProduct(yaxisNormalized)
        }
        //Y-X
        else if (cbaxis1.currentValue === CoordinateFrameCalculator.YAxis && cbaxis2.currentValue === CoordinateFrameCalculator.XAxis)
        {
            const yaxis = Qt.vector3d(target1Tx.value - originTx.value, target1Ty.value - originTy.value, target1Tz.value - originTz.value)
            const xaxis = Qt.vector3d(target2Tx.value - originTx.value, target2Ty.value - originTy.value, target2Tz.value - originTz.value)
            xaxisNormalized = xaxis.normalized()
            yaxisNormalized = yaxis.normalized()
            zaxisNormalized = xaxisNormalized.crossProduct(yaxisNormalized)
        }
        //Y-Z
        else if (cbaxis1.currentValue === CoordinateFrameCalculator.YAxis && cbaxis2.currentValue === CoordinateFrameCalculator.ZAxis)
        {
            const yaxis = Qt.vector3d(target1Tx.value - originTx.value, target1Ty.value - originTy.value, target1Tz.value - originTz.value)
            const zaxis = Qt.vector3d(target2Tx.value - originTx.value, target2Ty.value - originTy.value, target2Tz.value - originTz.value)
            yaxisNormalized = yaxis.normalized()
            zaxisNormalized = zaxis.normalized()
            xaxisNormalized = yaxisNormalized.crossProduct(zaxisNormalized)
        }
        //Z-Y
        else if (cbaxis1.currentValue === CoordinateFrameCalculator.ZAxis && cbaxis2.currentValue === CoordinateFrameCalculator.YAxis)
        {
            const zaxis = Qt.vector3d(target1Tx.value - originTx.value, target1Ty.value - originTy.value, target1Tz.value - originTz.value)
            const yaxis = Qt.vector3d(target2Tx.value - originTx.value, target2Ty.value - originTy.value, target2Tz.value - originTz.value)
            yaxisNormalized = yaxis.normalized()
            zaxisNormalized = zaxis.normalized()
            xaxisNormalized = yaxisNormalized.crossProduct(zaxisNormalized)
        }
        //Z-X
        else if (cbaxis1.currentValue === CoordinateFrameCalculator.ZAxis && cbaxis2.currentValue === CoordinateFrameCalculator.XAxis)
        {
            const zaxis = Qt.vector3d(target1Tx.value - originTx.value, target1Ty.value - originTy.value, target1Tz.value - originTz.value)
            const xaxis = Qt.vector3d(target2Tx.value - originTx.value, target2Ty.value - originTy.value, target2Tz.value - originTz.value)
            xaxisNormalized = xaxis.normalized()
            zaxisNormalized = zaxis.normalized()
            yaxisNormalized = zaxisNormalized.crossProduct(xaxisNormalized)
        }
        //X-Z
        else if (cbaxis1.currentValue === CoordinateFrameCalculator.XAxis && cbaxis2.currentValue === CoordinateFrameCalculator.ZAxis)
        {
            const xaxis = Qt.vector3d(target1Tx.value - originTx.value, target1Ty.value - originTy.value, target1Tz.value - originTz.value)
            const zaxis = Qt.vector3d(target2Tx.value - originTx.value, target2Ty.value - originTy.value, target2Tz.value - originTz.value)
            xaxisNormalized = xaxis.normalized()
            zaxisNormalized = zaxis.normalized()
            yaxisNormalized = zaxisNormalized.crossProduct(xaxisNormalized)
        }
        //-------------------------------------------------------------------------------------------------------------------------------------
        //X-XY
        else if (cbaxis1.currentValue === CoordinateFrameCalculator.XAxis && cbaxis2.currentValue === CoordinateFrameCalculator.XYPlane)
        {
            const xaxis = Qt.vector3d(target1Tx.value - originTx.value, target1Ty.value - originTy.value, target1Tz.value - originTz.value)
            const xyplane = Qt.vector3d(target2Tx.value - originTx.value, target2Ty.value - originTy.value, target2Tz.value - originTz.value)
            xaxisNormalized = xaxis.normalized()
            const xyplaneNormalized = xyplane.normalized()
            const zaxis = xaxisNormalized.crossProduct(xyplaneNormalized)
            zaxisNormalized = zaxis.normalized()
            yaxisNormalized = zaxisNormalized.crossProduct(xaxisNormalized)
        }
        //XY-X
        else if (cbaxis1.currentValue === CoordinateFrameCalculator.XYPlane && cbaxis2.currentValue === CoordinateFrameCalculator.XAxis)
        {
            const xyplane = Qt.vector3d(target1Tx.value - originTx.value, target1Ty.value - originTy.value, target1Tz.value - originTz.value)
            const xaxis = Qt.vector3d(target2Tx.value - originTx.value, target2Ty.value - originTy.value, target2Tz.value - originTz.value)
            xaxisNormalized = xaxis.normalized()
            const xyplaneNormalized = xyplane.normalized()
            const zaxis = xaxisNormalized.crossProduct(xyplaneNormalized)
            zaxisNormalized = zaxis.normalized()
            yaxisNormalized = zaxisNormalized.crossProduct(xaxisNormalized)
        }
        //Y-XY
        else if (cbaxis1.currentValue === CoordinateFrameCalculator.YAxis && cbaxis2.currentValue === CoordinateFrameCalculator.XYPlane)
        {
            const yaxis = Qt.vector3d(target1Tx.value - originTx.value, target1Ty.value - originTy.value, target1Tz.value - originTz.value)
            const xyplane = Qt.vector3d(target2Tx.value - originTx.value, target2Ty.value - originTy.value, target2Tz.value - originTz.value)
            yaxisNormalized = yaxis.normalized()
            const xyplaneNormalized = xyplane.normalized()
            const zaxis = xyplaneNormalized.crossProduct(yaxisNormalized)
            zaxisNormalized = zaxis.normalized()
            xaxisNormalized = yaxisNormalized.crossProduct(zaxisNormalized)

        }
        //XY-Y
        else if (cbaxis1.currentValue === CoordinateFrameCalculator.XYPlane && cbaxis2.currentValue === CoordinateFrameCalculator.YAxis)
        {
            const xyplane = Qt.vector3d(target1Tx.value - originTx.value, target1Ty.value - originTy.value, target1Tz.value - originTz.value)
            const yaxis = Qt.vector3d(target2Tx.value - originTx.value, target2Ty.value - originTy.value, target2Tz.value - originTz.value)
            yaxisNormalized = yaxis.normalized()
            const xyplaneNormalized = xyplane.normalized()
            const zaxis = xyplaneNormalized.crossProduct(yaxisNormalized)
            zaxisNormalized = zaxis.normalized()
            xaxisNormalized = yaxisNormalized.crossProduct(zaxisNormalized)
        }
        //-------------------------------------------------------------------------------------------------------------------------------------
        //Y-YZ
        else if (cbaxis1.currentValue === CoordinateFrameCalculator.YAxis && cbaxis2.currentValue === CoordinateFrameCalculator.YZPlane)
        {
            const yaxis = Qt.vector3d(target1Tx.value - originTx.value, target1Ty.value - originTy.value, target1Tz.value - originTz.value)
            const yzplane = Qt.vector3d(target2Tx.value - originTx.value, target2Ty.value - originTy.value, target2Tz.value - originTz.value)
            yaxisNormalized = yaxis.normalized()
            const yzplaneNormalized = yzplane.normalized()
            const xaxis = yaxisNormalized.crossProduct(yzplaneNormalized)
            xaxisNormalized = xaxis.normalized()
            zaxisNormalized = xaxisNormalized.crossProduct(yaxisNormalized)
        }
        //YZ-Y
        else if (cbaxis1.currentValue === CoordinateFrameCalculator.YZPlane && cbaxis2.currentValue === CoordinateFrameCalculator.YAxis)
        {
            const yzplane = Qt.vector3d(target1Tx.value - originTx.value, target1Ty.value - originTy.value, target1Tz.value - originTz.value)
            const yaxis = Qt.vector3d(target2Tx.value - originTx.value, target2Ty.value - originTy.value, target2Tz.value - originTz.value)
            yaxisNormalized = yaxis.normalized()
            const yzplaneNormalized = yzplane.normalized()
            const xaxis = yaxisNormalized.crossProduct(yzplaneNormalized)
            xaxisNormalized = xaxis.normalized()
            zaxisNormalized = xaxisNormalized.crossProduct(yaxisNormalized)
        }
        //Z-YZ
        else if (cbaxis1.currentValue === CoordinateFrameCalculator.ZAxis && cbaxis2.currentValue === CoordinateFrameCalculator.YZPlane)
        {
            const zaxis = Qt.vector3d(target1Tx.value - originTx.value, target1Ty.value - originTy.value, target1Tz.value - originTz.value)
            const yzplane = Qt.vector3d(target2Tx.value - originTx.value, target2Ty.value - originTy.value, target2Tz.value - originTz.value)
            zaxisNormalized = zaxis.normalized()
            const yzplaneNormalized = yzplane.normalized()
            const xaxis = yzplaneNormalized.crossProduct(zaxisNormalized)
            xaxisNormalized = xaxis.normalized()
            yaxisNormalized = zaxisNormalized.crossProduct(xaxisNormalized)
        }
        //YZ-Z
        else if (cbaxis1.currentValue === CoordinateFrameCalculator.YZPlane && cbaxis2.currentValue === CoordinateFrameCalculator.ZAxis)
        {
            const yzplane = Qt.vector3d(target1Tx.value - originTx.value, target1Ty.value - originTy.value, target1Tz.value - originTz.value)
            const zaxis = Qt.vector3d(target2Tx.value - originTx.value, target2Ty.value - originTy.value, target2Tz.value - originTz.value)
            zaxisNormalized = zaxis.normalized()
            const yzplaneNormalized = yzplane.normalized()
            const xaxis = yzplaneNormalized.crossProduct(zaxisNormalized)
            xaxisNormalized = xaxis.normalized()
            yaxisNormalized = zaxisNormalized.crossProduct(xaxisNormalized)
        }
        //-------------------------------------------------------------------------------------------------------------------------------------
        //Z-ZX
        else if (cbaxis1.currentValue === CoordinateFrameCalculator.ZAxis && cbaxis2.currentValue === CoordinateFrameCalculator.ZXPlane)
        {
            const zaxis = Qt.vector3d(target1Tx.value - originTx.value, target1Ty.value - originTy.value, target1Tz.value - originTz.value)
            const zxplane = Qt.vector3d(target2Tx.value - originTx.value, target2Ty.value - originTy.value, target2Tz.value - originTz.value)
            zaxisNormalized = zaxis.normalized()
            const zxplaneNormalized = zxplane.normalized()
            const yaxis = zaxisNormalized.crossProduct(zxplaneNormalized)
            yaxisNormalized = yaxis.normalized()
            xaxisNormalized = yaxisNormalized.crossProduct(zaxisNormalized)
        }
        //ZX-Z
        else if (cbaxis1.currentValue === CoordinateFrameCalculator.ZXPlane && cbaxis2.currentValue === CoordinateFrameCalculator.ZAxis)
        {
            const zxplane = Qt.vector3d(target1Tx.value - originTx.value, target1Ty.value - originTy.value, target1Tz.value - originTz.value)
            const zaxis = Qt.vector3d(target2Tx.value - originTx.value, target2Ty.value - originTy.value, target2Tz.value - originTz.value)
            zaxisNormalized = zaxis.normalized()
            const zxplaneNormalized = zxplane.normalized()
            const yaxis = zaxisNormalized.crossProduct(zxplaneNormalized)
            yaxisNormalized = yaxis.normalized()
            xaxisNormalized = yaxisNormalized.crossProduct(zaxisNormalized)
        }
        //X-ZX
        else if (cbaxis1.currentValue === CoordinateFrameCalculator.XAxis && cbaxis2.currentValue === CoordinateFrameCalculator.ZXPlane)
        {
            const xaxis = Qt.vector3d(target1Tx.value - originTx.value, target1Ty.value - originTy.value, target1Tz.value - originTz.value)
            const zxplane = Qt.vector3d(target2Tx.value - originTx.value, target2Ty.value - originTy.value, target2Tz.value - originTz.value)
            xaxisNormalized = xaxis.normalized()
            const zxplaneNormalized = zxplane.normalized()
            const yaxis = zxplaneNormalized.crossProduct(xaxisNormalized)
            yaxisNormalized = yaxis.normalized()
            zaxisNormalized = xaxisNormalized.crossProduct(yaxisNormalized)
        }
        //ZX-X
        else if (cbaxis1.currentValue === CoordinateFrameCalculator.ZXPlane && cbaxis2.currentValue === CoordinateFrameCalculator.XAxis)
        {
            const zxplane = Qt.vector3d(target1Tx.value - originTx.value, target1Ty.value - originTy.value, target1Tz.value - originTz.value)
            const xaxis = Qt.vector3d(target2Tx.value - originTx.value, target2Ty.value - originTy.value, target2Tz.value - originTz.value)
            xaxisNormalized = xaxis.normalized()
            const zxplaneNormalized = zxplane.normalized()
            const yaxis = zxplaneNormalized.crossProduct(xaxisNormalized)
            yaxisNormalized = yaxis.normalized()
            zaxisNormalized = xaxisNormalized.crossProduct(yaxisNormalized)
        }
        //output
        if(xaxisNormalized.length() && yaxisNormalized.length() && zaxisNormalized.length()) {
            root.validFrame = true
            let TransM = Qt.matrix4x4(xaxisNormalized.x, yaxisNormalized.x, zaxisNormalized.x, originTx.value,
                                      xaxisNormalized.y, yaxisNormalized.y, zaxisNormalized.y, originTy.value,
                                      xaxisNormalized.z, yaxisNormalized.z, zaxisNormalized.z, originTz.value,
                                      0,0,0,1)
            root.frameRotation = IrbcamInterfacePublic.matrixToQuaternion(TransM);
            root.framePosition = Qt.vector3d(originTx.value,originTy.value,originTz.value)
        }
    }

    component MyComponent : RowLayout {
        id: comp
        property alias value: tf.value
        property string labelText
        property bool editable: true
        Label {
            text: labelText
            Layout.rightMargin: 7  // Spacing between label and text field
            Layout.preferredWidth: 70
        }
        Item {
            Layout.fillWidth: true
        }
        TextField {
            id: tf
            enabled: comp.editable
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

    RowLayout {
        ColumnLayout {
            SeparatorLabel {
                text: "Origin Target"
            }


            MyComponent {
                id: originTx
                labelText: "X (mm)"
            }

            MyComponent {
                id: originTy
                labelText: "Y (mm)"
            }

            MyComponent {
                id: originTz
                labelText: "Z (mm)"
            }


            Separator {
            }

            RowLayout {

                Label {
                    text: "Target on"
                }

                Item {
                    Layout.fillWidth: true
                }

                ComboBox {
                    id: cbaxis1
                    Layout.preferredWidth: 120
                    currentIndex: 0
                    textRole: "axis"
                    valueRole: "value"

                    model:  ListModel {
                        id: axisModel1
                        ListElement {
                            axis: "X-Axis"
                            value: CoordinateFrameCalculator.XAxis
                        }
                        ListElement {
                            axis: "Z-Axis"
                            value: CoordinateFrameCalculator.ZAxis
                        }

                        ListElement {
                            axis: "XY-Plane"
                            value: CoordinateFrameCalculator.XYPlane
                        }
                        ListElement {
                            axis: "YZ-Plane"
                            value: CoordinateFrameCalculator.YZPlane
                        }
                    }
                    onActivated: {
                        if(currentValue >= 0) {
                            const value = cbaxis2.currentValue
                            axisModel2.clear()
                            switch (cbaxis1.currentValue)
                            {
                            case CoordinateFrameCalculator.XAxis:
                                axisModel2.append({axis: "Y-Axis", value: CoordinateFrameCalculator.YAxis})
                                axisModel2.append({axis: "Z-Axis", value: CoordinateFrameCalculator.ZAxis})
                                axisModel2.append({axis: "XY-Plane", value: CoordinateFrameCalculator.XYPlane})
                                axisModel2.append({axis: "ZX-Plane", value: CoordinateFrameCalculator.ZXPlane})
                                break
                            case CoordinateFrameCalculator.YAxis:
                                axisModel2.append({axis: "X-Axis", value: CoordinateFrameCalculator.XAxis})
                                axisModel2.append({axis: "Z-Axis", value: CoordinateFrameCalculator.ZAxis})
                                axisModel2.append({axis: "XY-Plane", value: CoordinateFrameCalculator.XYPlane})
                                axisModel2.append({axis: "YZ-Plane", value: CoordinateFrameCalculator.YZPlane})
                                break
                            case CoordinateFrameCalculator.ZAxis:
                                axisModel2.append({axis: "X-Axis", value: CoordinateFrameCalculator.XAxis})
                                axisModel2.append({axis: "Y-Axis", value: CoordinateFrameCalculator.YAxis})
                                axisModel2.append({axis: "ZX-Plane", value: CoordinateFrameCalculator.ZXPlane})
                                axisModel2.append({axis: "YZ-Plane", value: CoordinateFrameCalculator.YZPlane})
                                break
                            case CoordinateFrameCalculator.XYPlane:
                                axisModel2.append({axis: "X-Axis", value: CoordinateFrameCalculator.XAxis})
                                axisModel2.append({axis: "Y-Axis", value: CoordinateFrameCalculator.YAxis})
                                break
                            case CoordinateFrameCalculator.YZPlane:
                                axisModel2.append({axis: "Y-Axis", value: CoordinateFrameCalculator.YAxis})
                                axisModel2.append({axis: "Z-Axis", value: CoordinateFrameCalculator.ZAxis})
                                break
                            case CoordinateFrameCalculator.ZXPlane:
                                axisModel2.append({axis: "Z-Axis", value: CoordinateFrameCalculator.ZAxis})
                                axisModel2.append({axis: "X-Axis", value: CoordinateFrameCalculator.XAxis})
                                break
                            default:
                                break
                            }
                            cbaxis2.currentIndex = cbaxis2.indexOfValue(value)
                        }
                    }
                }
            }



            MyComponent {
                id: target1Tx
                labelText: "X (mm)"
            }

            MyComponent {
                id: target1Ty
                labelText: "Y (mm)"
            }

            MyComponent {
                id: target1Tz
                labelText: "Z (mm)"
            }


            Separator {
            }

            RowLayout {

                Label {
                    text: "Target on"
                }

                Item {
                    Layout.fillWidth: true
                }

                ComboBox {
                    id: cbaxis2
                    Layout.preferredWidth: 120
                    currentIndex: 0
                    textRole: "axis"
                    valueRole: "value"
                    model:  ListModel {
                        id: axisModel2
                        ListElement {
                            axis: "Y-Axis"
                            value: CoordinateFrameCalculator.YAxis
                        }
                        ListElement {
                            axis: "Z-Axis"
                            value: CoordinateFrameCalculator.ZAxis
                        }
                        ListElement {
                            axis: "XY-Plane"
                            value: CoordinateFrameCalculator.XYPlane
                        }
                        ListElement {
                            axis: "ZX-Plane"
                            value: CoordinateFrameCalculator.ZXPlane
                        }
                    }
                    onActivated: {
                        if(currentValue >= 0) {
                            const value = cbaxis1.currentValue
                            axisModel1.clear()
                            switch (cbaxis2.currentValue)
                            {
                            case CoordinateFrameCalculator.XAxis:
                                axisModel1.append({axis: "Y-Axis", value: CoordinateFrameCalculator.YAxis})
                                axisModel1.append({axis: "Z-Axis", value: CoordinateFrameCalculator.ZAxis})
                                axisModel1.append({axis: "XY-Plane", value: CoordinateFrameCalculator.XYPlane})
                                axisModel1.append({axis: "ZX-Plane", value: CoordinateFrameCalculator.ZXPlane})
                                break
                            case CoordinateFrameCalculator.YAxis:
                                axisModel1.append({axis: "X-Axis", value: CoordinateFrameCalculator.XAxis})
                                axisModel1.append({axis: "Z-Axis", value: CoordinateFrameCalculator.ZAxis})
                                axisModel1.append({axis: "XY-Plane", value: CoordinateFrameCalculator.XYPlane})
                                axisModel1.append({axis: "YZ-Plane", value: CoordinateFrameCalculator.YZPlane})
                                break
                            case CoordinateFrameCalculator.ZAxis:
                                axisModel1.append({axis: "X-Axis", value: CoordinateFrameCalculator.XAxis})
                                axisModel1.append({axis: "Y-Axis", value: CoordinateFrameCalculator.YAxis})
                                axisModel1.append({axis: "ZX-Plane", value: CoordinateFrameCalculator.ZXPlane})
                                axisModel1.append({axis: "YZ-Plane", value: CoordinateFrameCalculator.YZPlane})
                                break
                            case CoordinateFrameCalculator.XYPlane:
                                axisModel1.append({axis: "X-Axis", value: CoordinateFrameCalculator.XAxis})
                                axisModel1.append({axis: "Y-Axis", value: CoordinateFrameCalculator.YAxis})
                                break
                            case CoordinateFrameCalculator.YZPlane:
                                axisModel1.append({axis: "Y-Axis", value: CoordinateFrameCalculator.YAxis})
                                axisModel1.append({axis: "Z-Axis", value: CoordinateFrameCalculator.ZAxis})
                                break
                            case CoordinateFrameCalculator.ZXPlane:
                                axisModel1.append({axis: "Z-Axis", value: CoordinateFrameCalculator.ZAxis})
                                axisModel1.append({axis: "X-Axis", value: CoordinateFrameCalculator.XAxis})
                                break
                            default:
                                break
                            }
                            cbaxis1.currentIndex = cbaxis1.indexOfValue(value)
                        }
                    }
                }

            }

            MyComponent {
                id: target2Tx
                labelText: "X (mm)"
            }

            MyComponent {
                id: target2Ty
                labelText: "Y (mm)"
            }

            MyComponent {
                id: target2Tz
                labelText: "Z (mm)"
            }

        }

        Button {
            id: btnleft
            Layout.preferredWidth: 100
            Layout.alignment: Qt.AlignHCenter
            text: "Compute"
            enabled: cbaxis1.currentIndex >= 0 && cbaxis2.currentIndex >= 0
            onClicked: {
                root.compute()
            }
        }

        ColumnLayout {

            SeparatorLabel {
                text: "Coordinate Frame"

            }

            MyComponent {
                id: frameTx
                labelText: "X (mm)"
                editable: false
                value: root.framePosition.x
            }

            MyComponent {
                id: frameTy
                labelText: "Y (mm)"
                editable: false
                value: root.framePosition.y
            }

            MyComponent {
                id: frameTz
                labelText: "Z (mm)"
                editable: false
                value: root.framePosition.z
            }

            MyComponent {
                id: frameRx
                labelText: "RX (deg)"
                editable: false
                value: IrbcamInterfacePublic.radToDeg(frameEulerAngles.x)
            }

            MyComponent {
                id: frameRy
                labelText: "RY (deg)"
                editable: false
                value: IrbcamInterfacePublic.radToDeg(frameEulerAngles.y)
            }

            MyComponent {
                id: frameRz
                labelText: "RZ (deg)"
                editable: false
                value: IrbcamInterfacePublic.radToDeg(frameEulerAngles.z)
            }

        }


    }

    Label {
        id: statusLabel
        Layout.fillWidth: true
        Layout.topMargin: 10
        wrapMode: Text.Wrap
        text: root.isComputed && !root.validFrame ? "Invalid targets" : ""
        color: Colours.red
    }


    RowLayout {
        Layout.topMargin: 10

        Button {
            text: "Close"
            onClicked: pluginWindow.close()
        }

        Item {
            Layout.fillWidth: true
        }

        Label {
            text: "Copy frame to "
        }

        ComboBox {
            id: cbframe
            currentIndex: -1
            Layout.preferredWidth: 250
            textRole: "frame"
            valueRole: "value"
            model: ListModel {
                id: model
                ListElement {
                    frame: "User Frame"
                    value: IrbcamInterfacePublic.UserFrame
                }
                ListElement {
                    frame: "Object Frame"
                    value: IrbcamInterfacePublic.ObjectFrame
                }
                ListElement {
                    frame: "Stationary Tool Base Frame"
                    value: IrbcamInterfacePublic.StationaryToolBaseFrame
                }
            }
        }

        Button {
            text: "Copy"
            destructive: true
            enabled: cbframe.currentIndex >= 0 && root.isComputed && root.validFrame
            ToolTip.visible: hovered && enabled
            ToolTip.text: qsTr("This action will overwrite the corresponding data in the station")
            onClicked: {
                IrbcamInterfacePublic.setCoordinateFrame(cbframe.currentValue, root.framePosition, root.frameRotation)
            }
        }

    }

}
