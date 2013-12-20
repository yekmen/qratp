import QtQuick 1.1
import Qt 4.7

Item {
    property alias color : rectangle.color
    property alias radius: rectangle.radius

    BorderImage {
        anchors.fill: rectangle
        anchors { leftMargin: -6; topMargin: -6; rightMargin: -8; bottomMargin: -8 }
        border { left: 10; top: 10; right: 10; bottom: 10 }
        source: "shadow.png"; smooth: true
    }

    Rectangle { id: rectangle; anchors.fill: parent }
}
