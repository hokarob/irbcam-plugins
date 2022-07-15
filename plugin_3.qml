import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "qrc:/qml/uiStyle"

ColumnLayout {
    Label {
        Layout.bottomMargin: 30
        Layout.alignment: Qt.AlignHCenter
        text: qsTr("Placeholder Plugin 3")
        font.pointSize: 18
        font.family: Constants.fontHeader
    }

    RowLayout {
        Layout.topMargin: 80
        Item {
            Layout.fillWidth: true
        }

        Button {
            text: qsTr("OK")
            onClicked: {
                root.close()
            }
        }
    }
}
