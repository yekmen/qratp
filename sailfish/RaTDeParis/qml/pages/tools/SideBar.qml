/*
    Le RATdeParis
    Copyright (C) 2014  EKMEN Yavuz <yekmen@gmail.com>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle {
    property ListModel sideBarModel
    color: Theme.rgba(Theme.highlightDimmerColor, 1)
    signal addClicked;
    signal itemsClicked(string itemName);
    signal removeItem(string itemName, int itemID);
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
                remorseAction("Deleting", function() {
                    listModel.remove(index)
                    removeItem(line, indexDB)
                })
            }
            ListView.onRemove: animateRemoval()
            onClicked: itemsClicked(line);
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
