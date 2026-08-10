/*
    Write a nice description of the plugin here. Explain a bit about what it demonstrates or why it is relevant as an example
*/

import QtQuick
import QtCharts
import QtQuick.Layouts

// Import HOKAROB Controls library
import HokarobQml.Controls

// Import IRBCAM public interface
import IRBCAM.InterfacePublic

/*
    Plugins are loaded within a QML popup. Pack your content into a single component to get proper sizing. 
    See https://doc.qt.io/qt-6/qml-qtquick-controls-popup.html#popup-sizing
*/
ColumnLayout {
    id: root

    property list<int> countVec: [0, 0, 0, 0, 0, 0, 0]
    property vector3d minPos: Qt.vector3d(0.0, 0.0, 0.0)
    property vector3d maxPos: Qt.vector3d(0.0, 0.0, 0.0)
    property double pathLength: 0.0

    property int countTargets: 0
    property int countMoveL: 0
    property int countMoveC: 0
    property double minMoveL: 0.0
    property double maxMoveL: 0.0
    property int countRapidMove: 0
    property int countCuttingMove: 0
    property int countInputMove: 0

    property double estimatedTime: 0.0

    property bool dataOutdated: true

   function convertSeconds(totalSeconds) {
        var hours = Math.floor(totalSeconds / 3600)
        var minutes = Math.floor((totalSeconds % 3600) / 60)
        var seconds = totalSeconds % 60
        return {
            hours: hours,
            minutes: minutes,
            seconds: seconds
        }
    }

    RowLayout {

        Label {
            text: "Length of toolpath: "
        }

        Label {
            id: pathlength
            text: ((root.pathLength)/1000.0).toFixed(3)+" m"
            Layout.alignment: Qt.AlignRight
        }

        Item {
            Layout.fillWidth: true
        }


        Label {
            text: "Estimated Time: "
        }

        Label {
            id: esttime
            property int hours: convertSeconds(root.estimatedTime).hours
            property int minutes: convertSeconds(root.estimatedTime).minutes
            property int seconds: convertSeconds(root.estimatedTime).seconds
            text: (hours > 0 ? (hours + " hr ") : "") +
                (hours > 0 || minutes > 0 ? (minutes + " min ") : "") + 
                seconds +  " sec"
            
            Layout.alignment: Qt.AlignRight
        }


    }

    ChartView {
        id: mychart
        title: "Distance of Moves (mm)"
        legend.alignment: Qt.AlignBottom
        antialiasing: true
        Layout.preferredHeight: 250
        Layout.preferredWidth: 700
        legend.visible: false

        ValuesAxis {
            id: axisY
            min: 0
            max: Math.max.apply(null, root.countVec) + 5 //for better visualization
            labelFormat: "%d"
        }

        BarCategoryAxis {
            id: axisX
            categories: ["0-1", "1-2", "2-3", "3-5", "5-10", "10-20", ">20"]
        }


        BarSeries {
            id: mySeries
            axisX: axisX
            axisY: axisY
            BarSet {
                id: barset
                label: "Distance of Moves (mm)"
                values: root.countVec
            }
        }
    }


    RowLayout {

        GridLayout {
            columns: 3
            columnSpacing: 20


            Item {
                width: 1
            }

            Label {
                text: "Min (mm)"
            }

            Label {
                text: "Max (mm)"
            }

            Item {
                width : 1
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: "red"
                Layout.columnSpan: 2
            }

            Label {
                text: "X Coordinates"
            }
            Label {
                text: root.minPos.x.toFixed(2)
                Layout.alignment: Qt.AlignRight
            }
            Label {
                text: root.maxPos.x.toFixed(2)
                Layout.alignment: Qt.AlignRight
            }


            Label {
                text: "Y Coordinates"
            }
            Label {
                text: root.minPos.y.toFixed(2)
                Layout.alignment: Qt.AlignRight
            }
            Label {
                text: root.maxPos.y.toFixed(2)
                Layout.alignment: Qt.AlignRight
            }


            Label {
                text: "Z Coordinates"
            }
            Label {
                text: root.minPos.z.toFixed(2)
                Layout.alignment: Qt.AlignRight
            }
            Label {
                id: maxZ
                text: root.maxPos.z.toFixed(2)
                Layout.alignment: Qt.AlignRight
            }

            Label {
                text: "MoveL"
            }

            Label {
                id: minMoveL
                text: root.minMoveL.toFixed(2)
                Layout.alignment: Qt.AlignRight
            }

            Label {
                id: maxMoveL
                text: root.maxMoveL.toFixed(2)
                Layout.alignment: Qt.AlignRight
            }

        }

        Item {
            Layout.fillWidth: true
        }

        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: 3
            color: "red"

        }

        Item {
            Layout.fillWidth: true
        }

        GridLayout {
            columns: 2
            columnSpacing: 40

            Item {
//                width: 1
            }

            Label {
                id: cnt
                text: "Counter"
            }


            Item {
//                width: 1
            }

            Rectangle {
                Layout.preferredWidth: cnt.width
                Layout.preferredHeight: 1
                color: "red"
                Layout.columnSpan:1
            }

            Label {
                text: "Targets";
                Layout.rightMargin: 30
            }
            Label {
                text: root.countTargets
                Layout.alignment: Qt.AlignRight
                horizontalAlignment: Text.AlignRight
                Layout.preferredWidth: 50
            }

            Label {
                text: "MoveL";
                Layout.rightMargin: 30
            }
            Label {
                text: Math.max(0, root.countMoveL)
                Layout.alignment: Qt.AlignRight
                horizontalAlignment: Text.AlignRight
                Layout.preferredWidth: 50
            }


            Label {
                text: "MoveC"
            }
            Label {
                id: moveC
                text: Math.max(0, root.countMoveC)
                Layout.alignment: Qt.AlignRight
                horizontalAlignment: Text.AlignRight
            }


            Label {
                text: "Input"
            }
            Label {
                text: Math.max(0, root.countInputMove)
                Layout.alignment: Qt.AlignRight
                horizontalAlignment: Text.AlignRight
            }

            Label {
                text: "Rapid"
            }
            Label {
                text: Math.max(0, root.countRapidMove)
                Layout.alignment: Qt.AlignRight
                horizontalAlignment: Text.AlignRight
            }

            Label {
                text: "Cutting"
            }
            Label {
                text: Math.max(0, root.countCuttingMove)
                Layout.alignment: Qt.AlignRight
                horizontalAlignment: Text.AlignRight
            }
        }

    }
    RowLayout {
        Layout.topMargin: 10

        Button {
            text: "Recalculate"
            onClicked: loopOverPose()
        }

        Label {
            visible: root.dataOutdated
            text: "* Data has changed"
        }

        Item {
            Layout.fillWidth: true
        }

        Button {
            text: "Close"
            onClicked: {
                ApplicationWindow.window.close()
            }
        }

    }

    Connections {
        target: IrbcamInterfacePublic.pathModel
        function onModelReset() {
            root.dataOutdated = true
        }
        function onDataChanged(topLeft, bottomRight, roles) {
            // Avoid notifying that data has changed if the role is not one that we use in calculations
            // No roles means all data has changed
            if (roles.length === 0) {
                root.dataOutdated = true
                return
            }

            // Loop through the list of changed roles
            for (let role of roles) {
                // Get the role name of the role id
                let roleName = IrbcamInterfacePublic.pathModel.roleName(role)
                // Check if the role name corresponds with any of the roles we use
                switch (roleName) {
                case "px":
                case "py":
                case "pz":
                case "motionType":
                case "velocityMode":
                case "velocity":
                    root.dataOutdated = true
                    return
                }
            }
        }
        function onRowsInserted() {
            root.dataOutdated = true
        }
        function onRowsRemoved() {
            root.dataOutdated = true
        }
    }

    Component.onCompleted: loopOverPose()

    function loopOverPose() {
        let path = IrbcamInterfacePublic.pathModel
        let targetCount = path.rowCount()

        //initialize
        let countMoveL = 0
        let countMoveC = 0
        let estimatedTime = 0.0
        let pathLength = 0.0
        let countVec = [0, 0, 0, 0, 0, 0, 0]
        let minMoveL = Infinity
        let maxMoveL = -Infinity
        let minPos = Qt.vector3d(Infinity, Infinity, Infinity)
        let maxPos = Qt.vector3d(-Infinity, -Infinity, -Infinity)
        let countRapidMove = 0
        let countCuttingMove = 0
        let countInputMove = 0

        let prevPos = Qt.vector3d(0.0, 0.0, 0.0)
        let prevSpeed = 0.0
        let prevType = -1

        for (let i = 0; i < targetCount; ++i) {
            let x = path.dataAt(i, "px")
            let y = path.dataAt(i, "py")
            let z = path.dataAt(i, "pz")
            let type = path.dataAt(i, "motionType")
            let speedMode = path.dataAt(i, "velocityMode")
            let speed = path.dataAt(i, "velocity")

            let pos = Qt.vector3d(x, y, z)
            if (i != 0) {
                // The cartesian distance between two vectors is the length of the difference vector between them
                let distance = pos.minus(prevPos).length()
                pathLength += distance
                if (speed > 0) {
                    estimatedTime += distance/prevSpeed
                }

                if (distance <= 1.0)
                    countVec[0] += 1;
                else if (distance <= 2.0)
                    countVec[1] += 1;
                else if (distance <= 3.0)
                    countVec[2] += 1;
                else if (distance <= 5.0)
                    countVec[3] += 1;
                else if (distance <= 10.0)
                    countVec[4] += 1;
                else if (distance <= 20.0)
                    countVec[5] += 1;
                else
                    countVec[6] += 1;

                if (type === IrbcamInterfacePublic.MotionTypeLinear && prevType == IrbcamInterfacePublic.MotionTypeLinear)
                {
                    minMoveL = Math.min(minMoveL, distance)
                    maxMoveL = Math.max(maxMoveL, distance)
                }
            }

            prevPos = pos
            prevSpeed = speed
            prevType = type

            minPos = vMin(minPos, pos)
            maxPos = vMax(maxPos, pos)

            switch (type) {
            case IrbcamInterfacePublic.MotionTypeLinear:
                countMoveL += 1
                break
            case IrbcamInterfacePublic.MotionTypeArcMidpoint:
                // two moveC commands for each arcMidPoint
                countMoveC += 2
                countMoveL -= 1
                break
            case IrbcamInterfacePublic.MotionTypeRotaryLiftPoint:
            case IrbcamInterfacePublic.MotionTypeLinearLiftPoint:
            case IrbcamInterfacePublic.MotionTypeRotaryLiftPoint2:
            case IrbcamInterfacePublic.MotionTypeRotaryLiftPoint3:
                break
            }

            switch (speedMode) {
            case IrbcamInterfacePublic.SpeedModeInput:
                ++countInputMove
                break
            case IrbcamInterfacePublic.SpeedModeRapid:
                ++countRapidMove
                break
            case IrbcamInterfacePublic.SpeedModeCutting:
                ++countCuttingMove
                break
            }
        }

        root.countMoveL = countMoveL
        root.countMoveC = countMoveC
        root.pathLength = pathLength
        root.countInputMove = countInputMove
        root.countCuttingMove = countCuttingMove
        root.countRapidMove = countRapidMove
        root.estimatedTime = estimatedTime
        root.countVec = countVec
        root.countTargets = targetCount
        root.minMoveL = isFinite(minMoveL) ? minMoveL : 0
        root.maxMoveL = isFinite(maxMoveL) ? maxMoveL : 0
        root.minPos = vClean(minPos)
        root.maxPos = vClean(maxPos)

        root.dataOutdated = false
    }

    // Element-wise minimum check for 3d vectors
    function vMin(v1, v2) {
        return Qt.vector3d(Math.min(v1.x, v2.x), Math.min(v1.y, v2.y), Math.min(v1.z, v2.z))
    }

    // Element-wise maximum check for 3d vectors
    function vMax(v1, v2) {
        return Qt.vector3d(Math.max(v1.x, v2.x), Math.max(v1.y, v2.y), Math.max(v1.z, v2.z))
    }

    // Clean vector of non-finite values
    function vClean(v) {
        return Qt.vector3d(isFinite(v.x) ? v.x : 0.0, isFinite(v.y) ? v.y : 0.0, isFinite(v.z) ? v.z : 0.0)
    }
}


