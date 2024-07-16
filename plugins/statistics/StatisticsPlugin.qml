/*
    Write a nice description of the plugin here. Explain a bit about what it demonstrates or why it is relevant as an example
*/

import QtQuick
import QtCharts
import QtQuick.Controls
import QtQuick.Layouts

// Import HOKAROB theme
import HokarobQml.Theme
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
    property double minX: 0.0
    property double maxX: 0.0
    property double minY: 0.0
    property double maxY: 0.0
    property double minZ: 0.0
    property double maxZ: 0.0
    property double pathLength: 0.0

    property int countMoveL: 0
    property int countMoveC: 0
    property double minMoveL: 0.0
    property double maxMoveL: 0.0
    property double countFastMove: 0

    property double estimatedTime: 0.0


    RowLayout {

        Label {
            text: "Length of toolpath: "
        }

        Label {
            id: pathlength
            text: qsTr(root.pathLength.toFixed(2)+" mm")
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
            text: qsTr(root.estimatedTime.toFixed(2)+" s")
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
                id: minX
                text: (root.minX.toFixed(2))
                Layout.alignment: Qt.AlignRight
            }

            Label {
                id: maxX
                text: (root.maxX.toFixed(2))
                Layout.alignment: Qt.AlignRight
            }


            Label {
                text: "Y Coordinates"
            }

            Label {
                id: minY
                text: (root.minY.toFixed(2))
                Layout.alignment: Qt.AlignRight
            }

            Label {
                id: maxY
                text: (root.maxY.toFixed(2))
                Layout.alignment: Qt.AlignRight
            }


            Label {
                text: "Z Coordinates"
            }

            Label {
                id: minZ
                text: (root.minZ.toFixed(2))
                Layout.alignment: Qt.AlignRight
            }

            Label {
                id: maxZ
                text: (root.maxZ.toFixed(2))
                Layout.alignment: Qt.AlignRight
            }

            Label {
                text: "MoveL"
            }

            Label {
                id: minMoveL
                text: (root.minMoveL.toFixed(2))
                Layout.alignment: Qt.AlignRight
            }

            Label {
                id: maxMoveL
                text: (root.maxMoveL.toFixed(2))
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
                text: "MoveL";
                Layout.rightMargin: 30
            }

            Label {
                id: moveL
                text: ((root.countMoveL - 1) > 0) ? (root.countMoveL - 1) :  0
                Layout.alignment: Qt.AlignRight
                horizontalAlignment: Text.AlignRight
                Layout.preferredWidth: 50
            }


            Label {
                text: "MoveC"
            }

            Label {
                id: moveC
                text: (root.countMoveC)
                Layout.alignment: Qt.AlignRight
                horizontalAlignment: Text.AlignRight
            }


            Label {
                text: "Fast"
            }

            Label {
                id: fast
                text: ((root.countFastMove - 1) > 0) ? (root.countFastMove - 1) :  0
                Layout.alignment: Qt.AlignRight
                horizontalAlignment: Text.AlignRight
            }


            Label {
                text: "Slow"
            }

            Label {
                id: slow
                text: (root.countMoveC) + (((root.countMoveL - 1) > 0) ? (root.countMoveL - 1) :  0) - (((root.countFastMove - 1) > 0) ? (root.countFastMove - 1) :  0)
                Layout.alignment: Qt.AlignRight
                horizontalAlignment: Text.AlignRight
            }

        }

    }
    RowLayout {
        Layout.topMargin: 10
        Item {
            Layout.fillWidth: true
        }
        Button {
            text: qsTr("Close")
            onClicked: {
                pluginWindow.close()
            }
        }

    }

    Connections {
        target: IrbcamInterfacePublic
        function onCartesianPathChanged() {
            loopOverPose();
        }
    }

    Component.onCompleted: loopOverPose()

    function loopOverPose() {

        let cartesianPath = IrbcamInterfacePublic.cartesianPath;
        let cartesianPose = cartesianPath.targets;
        let indexArr = cartesianPath.velocity.i;
        let valueArr = cartesianPath.velocity.value;
        let totalPose = cartesianPose.pX.length;

        //initialize
        let countMoveL = 0;
        let countMoveC = 0;
        let pathLength = 0.0;
        let estimatedTime = 0.0;
        let countVec = [0, 0, 0, 0, 0, 0, 0];
        let minMoveL = Infinity;
        let maxMoveL = -Infinity;
        let countFastMove = 0;


        let tmpIndex = 0;

        let velocity = 0.0; // mm/s
        let fastMove = false;

        for(var i = 0; i < totalPose; i++ ) {
            if(cartesianPose.type[i] === 0) {
                countMoveL += 1; // substract 1 from the final count during display
            } else {
                countMoveC += 2; // two moveC commands for each arcMidPoint
                countMoveL -= 1;
            }
            if(i === indexArr[tmpIndex]) {
                velocity = valueArr[tmpIndex].value
                if(valueArr[tmpIndex].mode === 1) { //SpeedModeRapid
                    fastMove = true;
                }
                else {
                    fastMove = false;
                }
                tmpIndex += 1;
            }
            if(fastMove) {
                countFastMove += 1;
            }
            if (i < (totalPose-1)) {
                let dis = calcDistance( Qt.vector3d(cartesianPose.pX[i],cartesianPose.pY[i],cartesianPose.pZ[i]), Qt.vector3d(cartesianPose.pX[i+1],cartesianPose.pY[i+1],cartesianPose.pZ[i+1]));
                pathLength += dis;
                if(velocity > 0.0001) { // velocity should be more than threshold = 0.0001 mm/s
                    estimatedTime += dis/velocity;
                }
                if((cartesianPose.type[i] === 0) && (cartesianPose.type[i+1] === 0)){
                    if(dis > maxMoveL) maxMoveL = dis;
                    if(dis < minMoveL) minMoveL= dis;
                }
                switch (true) {
                case dis <= 1.0:
                    countVec[0] += 1;
                    break;
                case dis > 1.0 && dis <= 2.0:
                    countVec[1] += 1;
                    break;
                case dis > 2.0 && dis <= 3.0:
                    countVec[2] += 1;
                    break;
                case dis > 3.0 && dis <= 5.0:
                    countVec[3] += 1;
                    break;
                case dis > 5.0 && dis <= 10.0:
                    countVec[4] += 1;
                    break;
                case dis > 10.0 && dis <= 20.0:
                    countVec[5] += 1;
                    break;
                case dis > 20.0:
                    countVec[6] += 1;
                    break;
                default:
                }
            }
        }
        root.countMoveL = countMoveL;
        root.countMoveC = countMoveC;
        root.pathLength = pathLength;
        root.estimatedTime = estimatedTime;
        root.countVec = countVec;
        root.minMoveL = isFinite(minMoveL) ? minMoveL : 0.0;
        root.maxMoveL = isFinite(maxMoveL) ? maxMoveL : 0.0;
        root.countFastMove = countFastMove;

        root.minX = isFinite(Math.min.apply(null, cartesianPose.pX)) ? Math.min.apply(null, cartesianPose.pX) : 0;
        root.maxX = isFinite(Math.max.apply(null, cartesianPose.pX)) ? Math.max.apply(null, cartesianPose.pX) : 0;
        root.minY = isFinite(Math.min.apply(null, cartesianPose.pY)) ? Math.min.apply(null, cartesianPose.pY) : 0;
        root.maxY = isFinite(Math.max.apply(null, cartesianPose.pY)) ? Math.max.apply(null, cartesianPose.pY) : 0;
        root.minZ = isFinite(Math.min.apply(null, cartesianPose.pZ)) ? Math.min.apply(null, cartesianPose.pZ) : 0;
        root.maxZ = isFinite(Math.max.apply(null, cartesianPose.pZ)) ? Math.max.apply(null, cartesianPose.pZ) : 0;
    }

    // calculate distance between two 3D vectors
    function calcDistance(start, end) {
        var dist = Math.sqrt((end.x - start.x) ** 2 + (end.y - start.y) ** 2 + (end.z - start.z) ** 2);
        return dist;
    }    
}


