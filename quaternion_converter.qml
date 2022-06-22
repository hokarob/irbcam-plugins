import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "qrc:/qml/UIstyle"

GridLayout {
    columns: 4
    columnSpacing: 20

    Label {
        Layout.columnSpan: 4
        Layout.bottomMargin: 30
        Layout.alignment: Qt.AlignHCenter

        text: qsTr("Quaternion Converter")
        font.pointSize: 18
        font.family: Constants.fontHeader
    }

    ColumnLayout {
        Repeater {
            id: eulerRots
            model: ["RX (deg)", "RY (deg)", "RZ (deg)"]
            delegate: componentField
        }
    }

    Button {
        text: ">"
        property var q: []

        onClicked: {
            q = api.angles2quat(parseFloat(eulerRots.itemAt(0).text), parseFloat(eulerRots.itemAt(1).text), parseFloat(eulerRots.itemAt(2).text));
            quaternions.itemAt(0).text = q[0].toFixed(9);
            quaternions.itemAt(1).text = q[1].toFixed(9);
            quaternions.itemAt(2).text = q[2].toFixed(9);
            quaternions.itemAt(3).text = q[3].toFixed(9);
        }
    }

    Button {
        text: "<"
        property var eul: []
        onClicked: {
            eul = api.quat2angles(
                        parseFloat(quaternions.itemAt(0).text),
                        parseFloat(quaternions.itemAt(1).text),
                        parseFloat(quaternions.itemAt(2).text),
                        parseFloat(quaternions.itemAt(3).text))

            eulerRots.itemAt(2).text = eul[0].toFixed(3);
            eulerRots.itemAt(1).text = eul[1].toFixed(3);
            eulerRots.itemAt(0).text = eul[2].toFixed(3);
        }
    }

    ColumnLayout {
        Repeater {
            id: quaternions
            model: ["q1", "q2", "q3", "q4"]
            delegate: componentField
        }
    }


    Button {
        Layout.topMargin: 50
        Layout.columnSpan: 4
        Layout.alignment: Qt.AlignRight
        text: qsTr("OK")
        onClicked: root.close()
    }

    Component {
        id: componentField
        RowLayout {
            property alias text: tf.text
            Label {
                text: modelData
                Layout.rightMargin: 7  // Spacing between label and text field
            }
            TextField {
                id: tf
                text: "0.0"
                validator: DoubleValidator{ decimals: 7 }
            }
        }
    }
}
