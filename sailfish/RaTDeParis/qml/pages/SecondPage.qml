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

    function _defaultState()
    {
        if(typeChoose.state === "show")
            typeChoose.state = "hide"
        if(lineChoose.state === "show")
            lineChoose.state = "hide"
        if(directionChoose.state === "show")
            directionChoose.state = "hide"
        if(stationChoose.state === "show")
            stationChoose.state = "hide"
        if(result.state === "show")
            result.state = "hide"
    }
    Connections{
        target: dataRequest
        ignoreUnknownSignals: true
        onLinesListChanged:{
            //            lineChoose.modelList.clear();
            _defaultState();
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
        title: "Nested Page"
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
                _defaultState();
                typeID = _idJson;
                console.debug("Type: " + typeID)
                dataRequest.getLines(typeID);
            }
            onSectionClicked: {
                _defaultState();
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
                _defaultState();
                lineID = _idJson;
                dataRequest.getDirections(_idJson)
            }
            onSectionClicked: {
                _defaultState();
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
                _defaultState();
                console.debug("user select direction ")
                directionID = _idJson;
                dataRequest.getStations(lineID, directionID);
            }
            onSectionClicked: {
                _defaultState();
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
                _defaultState();
                stationID = _idJson;
                dataRequest.getSchedule(lineID, directionID, stationID);
            }
            onSectionClicked: {
                _defaultState()
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
