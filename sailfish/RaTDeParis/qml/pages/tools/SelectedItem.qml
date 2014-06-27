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

Item {
    id: item1
    width: 400
    height: 50

    signal clickedElement(variant _idJSON, int _index, variant _line, int _typeID);
    //idJSON = ID Du transport dans le JSON
    //_index = index dans la Liste
    //_line = Nom de la ligne
    //_typeID = ID donnée par le JSON 1 = bus 2 = metro etc ...

    property int myIndex
    property int idJSON
    property string url
    property string line
    property int typeID

    Image {
        id: image
        width: 50
        fillMode: Image.PreserveAspectFit
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        source: url
        state: "show"
        states: [
            State {
                name: "show"
                PropertyChanges {
                    target: image
                    anchors.leftMargin: 0

                }
            },
            State {
                name: "hide"
                when: url === ""
                PropertyChanges {
                    target: image
                    anchors.leftMargin: -50
                }
            }
        ]
    }
    Label{
        id: type
        text: line
        anchors.left: image.right
        anchors.leftMargin: 20
        anchors.verticalCenter: parent.verticalCenter

    }
    MouseArea{
        id: mouse
        anchors.fill: parent
        onClicked: {
            clickedElement(idJSON, myIndex, line, typeID)
        }
    }
}
