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

Dialog {
    id: aboutPage
    width: app.width
    height: app.height

    DialogHeader{
        id: header
        acceptText: qsTr("Le RAT de Paris")
        defaultAcceptText: qsTr("Fermer")
        cancelText: qsTr("Fermer")
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
    }
    Flickable{
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        clip: true
        contentHeight: column.height
        Column{
            id: column
            anchors.fill: parent
            Image{
                id: icon
                source: "qrc:/logo/RaTDeParis.png"
                height: 100
                width: 100
                cache: true

//                anchors.centerIn: parent
            }
            Label{
                id: labelTitle
                text: "Le RAT de Paris"
                color:Theme.highlightColor
                font.family: Theme.fontFamilyHeading
                font.pixelSize: Theme.fontSizeHuge
                verticalAlignment: Image.AlignHCenter
//                anchors.centerIn: parent
            }
            Label{
                id: labelVersion
                text: "Version : " + appVersion
//                font.family: Theme.fontFamilyHeading
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeMedium
//                anchors.centerIn: parent
            }
            Label{
                id: labelthanks

                text: qsTr("Icon designer & Testeur : L. Cyril")
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeSmall
                verticalAlignment: Image.AlignHCenter
            }
            Label{
                id: labelLink
                text: "https://github.com/yekmen/qratp"
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeSmall
                verticalAlignment: Image.AlignHCenter
            }
            Label{
                id: labelLicense

                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeTiny - 5
                truncationMode: TruncationMode.Elide
                text:"    Le RATdeParis
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
    along with this program.  If not, see <http://www.gnu.org/licenses/>."

            }

        }
    }

}
