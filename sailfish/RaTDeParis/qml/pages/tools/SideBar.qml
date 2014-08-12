import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle {
    property ListModel sideBarModel
    color: Theme.rgba(Theme.highlightDimmerColor, 1)
    signal addClicked;
    PageHeader {
        id: header
        anchors.top: parent.top
        anchors.right: parent.right
        title: qsTr("Vos itinéraires")
    }
    Separator {
        opacity: 0.8
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        width: contentItem.width
        color: Theme.primaryColor
    }

    ListView{
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: btnAdd.top
        model: sideBarModel
        clip: true
        focus: true
        smooth: true
        delegate: ListItem {
            id: listItem
            menu: contextMenuComponent
            function remove() {
                remorseAction("Deleting", function() { listModel.remove(index) })
            }
            ListView.onRemove: animateRemoval()
            Label {
                x: Theme.paddingLarge
                text: (model.index+1) + ". " + line
                anchors.verticalCenter: parent.verticalCenter
                font.capitalization: Font.Capitalize
                color: listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
            }
            Component {
                id: contextMenuComponent
                ContextMenu {
                    MenuItem {
                        text: qsTr("Supprimer")
                        onClicked: remove()
                    }
                }
            }
        }
    }

    Rectangle{
        id: btnAdd
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 100
        color: Theme.rgba(Theme.highlightDimmerColor, 0.5)
        Separator {
            opacity: 0.8
            anchors.top: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: label.top
            width: contentItem.width
            color: Theme.primaryColor
        }
        Label {
            id: label
            text: "+"
            font.pixelSize: 100
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.highlightColor
        }
        MouseArea{
            anchors.fill: parent
            onClicked: addClicked()
        }
    }
}
