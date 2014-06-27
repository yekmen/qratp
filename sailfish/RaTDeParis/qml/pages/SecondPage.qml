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
import "tools"
Page {
    id: page
    property variant typeID
    property variant lineID
    property variant directionID
    property variant stationID
    property alias title: header.title
    Connections{
        target: dataRequest
        ignoreUnknownSignals: true
        onLinesListChanged:{
            lineChoose.state = "show";
        }
        onDirectionsListChanged: {
            directionChoose.state = "show";
        }
        onStationsListChanged: {
            stationChoose.state = "show";
        }
        onSchedulesChanged:{
            result.state = "show";
        }
    }

    PageHeader {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
    }
    Column{
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        Choose{
            id: typeChoose
            typeName: qsTr("Selectionner le type de transport :")
            Component.onCompleted: addType();
            height: 200
            anchors.left: parent.left
            anchors.right: parent.right
            state:"show"
            onUserClicked: {
                lineChoose.busy = true;
                typeID = _idJson;
                console.debug("Type: " + typeID)
                dataRequest.getLines(typeID);
            }
            onSectionClicked: {
                lineChoose.state = "hide"
                directionChoose.state = "hide"
                stationChoose.state = "hide"
                result.state = "hide"
            }
        }
        Choose{
            id: lineChoose
            height: 300
            anchors.left: parent.left
            anchors.right: parent.right
            typeName: qsTr("Selectionner votre ligne :")
            modelList: dataRequest.linesList
            state: "hide"
            onUserClicked: {
                directionChoose.busy = true;
                lineID = _idJson;
                dataRequest.getDirections(_idJson)
            }
            onSectionClicked: {
                directionChoose.state = "hide"
                stationChoose.state = "hide"
                result.state = "hide"
            }
        }
        Choose{
            id: directionChoose
            typeName: qsTr("Selectionner votre direction :")
            anchors.left: parent.left
            anchors.right: parent.right
            modelList: dataRequest.directionsList
            state: "hide"
            height: 300
            onUserClicked: {
                stationChoose.busy = true;
                directionID = _idJson;
                dataRequest.getStations(lineID, directionID);
            }
            onSectionClicked: {
                stationChoose.state = "hide"
                result.state = "hide"
            }
        }
        Choose{
            id: stationChoose
            typeName: qsTr("Selectionner votre station :")
            anchors.left: parent.left
            anchors.right: parent.right
            state: "hide"
            height: 300
            modelList: dataRequest.stationsList
            onUserClicked: {
                result.busy = true;
                stationID = _idJson;
                dataRequest.getSchedule(lineID, directionID, stationID);
            }
            onSectionClicked: {
                result.state = "hide"
            }
        }
        Choose{
            id: result
            typeName: qsTr("Résultat :")
            anchors.left: parent.left
            anchors.right: parent.right
            state: "hide"
            height: 300
            modelList: dataRequest.scheduleList
            onSectionClicked: {
                //                    _defaultState()
            }
        }

    }
}
