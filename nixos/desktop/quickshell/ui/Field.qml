import QtQuick
import QtQuick.Controls
import ".."

TextField {
    id: root
    color: Theme.fg
    placeholderTextColor: Theme.comment
    font.family: Theme.font
    font.pixelSize: 14
    leftPadding: 10
    rightPadding: 10
    implicitHeight: 36
    echoMode: TextInput.Normal
    background: Rectangle {
        radius: 8
        color: Theme.bgHighlight
        border.width: 1
        border.color: root.activeFocus ? Theme.blue : Theme.black
    }
}
