import QtQuick
import Quickshell.Services.SystemTray
import ".."

Row {
    spacing: 4

    Repeater {
        model: SystemTray.items

        MouseArea {
            required property var modelData
            implicitWidth: Theme.iconSize + 8
            implicitHeight: Theme.barHeight - 8
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            cursorShape: Qt.PointingHandCursor
            onClicked: event => {
                if (modelData.hasMenu)
                    TrayMenu.open(modelData, this);
                else if (event.button === Qt.LeftButton)
                    modelData.activate();
            }

            Item {
                anchors.centerIn: parent
                width: Theme.iconSize
                height: Theme.iconSize
                clip: true

                Image {
                    anchors.fill: parent
                    sourceSize.width: Theme.iconSize
                    sourceSize.height: Theme.iconSize
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    mipmap: true
                    cache: false
                    source: modelData.icon
                }
            }
        }
    }
}
