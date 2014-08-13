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
    property string name
    PageHeader{
        id: header
        title: qsTr("Nouveau itinéraire")
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
    }

    TextField {
        id: nameField
        width: 480
        placeholderText: qsTr("Entrez le nom de votre itinéraire")
        anchors.top : header.bottom
    }

    onDone: {
        if (result == DialogResult.Accepted) {
            name = nameField.text
        }
    }
}
