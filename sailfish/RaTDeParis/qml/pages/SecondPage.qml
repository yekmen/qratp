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

Dialog  {
    id: page
    property variant typeID
    property variant lineID
    property variant directionID
    property variant stationID

//    property int type: -1   //RER, METRO ...

    property string ligne  //115,metro 3 ...
    property string direction
    property string station
    property string urlType
    property string urlLigne

    property alias title: header.title
    property bool abort: false
    property int whereFrom: -1 //False = Aller | true = retour

    canAccept: false;
    width: app.width
    height: app.height
    Component.onDestruction: console.debug("Destruction")

    DialogHeader{
        id: header
        acceptText: "Ajouter l'itinéraire"
        defaultAcceptText: "Ajouter"
        cancelText: "Retour"
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
    }

    function updateSchedule(){
        dataRequest.getSchedule(lineID, directionID, stationID);
    }
    Connections{
        target: dataRequest
        ignoreUnknownSignals: true
        onLinesListChanged:{
            canAccept = false;
            if(!abort){
                lineChoose.state = "show";
            }
        }
        onDirectionsListChanged: {
            canAccept = false;
            if(!abort)
                directionChoose.state = "show";
        }
        onStationsListChanged: {
            canAccept = false;
            if(!abort)
                stationChoose.state = "show";
        }
        onSchedulesChanged:{
            canAccept = true;
            if(!abort)
                result.state = "show";
        }
    }

    Flickable{
        contentHeight: column.height
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        clip: true
        z:-1
        Column{
            id: column
            anchors.fill: parent
            Choose{
                id: typeChoose
                objectName: "typeChoose"
                typeName: qsTr("Sélectionner le type de transport :")
                Component.onCompleted: addType();
                height: 200
                enableSearch: false
                anchors.left: parent.left
                anchors.right: parent.right
                state:"show"
                onUserClicked: {
                    abort = false;
                    lineChoose.busySwitcher = true;
                    typeID = _idJson;
//                    console.debug("Type: " + typeID + " " + abort)
                    dataRequest.getLines(typeID);
                }
                onSectionClicked: {
                    abort = true;
                    lineChoose.state = "hide"
                    directionChoose.state = "hide"
                    stationChoose.state = "hide"
                    result.state = "hide"

                    if(state === "selected")
                        state = "show";
                }
                //            ListModel{
                //                id: modelType
                //            }
                //            function addType(){
                //                modelType.append({"idJson": 1,"line": "Bus", "urlLine": "qrc:/logo/bus.png"});
                //                modelType.append({"idJson": 2,"line": "Métro", "urlLine": "qrc:/logo/metro.png"});
                //                modelType.append({"idJson": 3,"line": "RER", "urlLine": "qrc:/logo/rer.png"});
                //                modelType.append({"idJson": 6,"line": "Tram", "urlLine": "qrc:/logo/tramway.png"});
                //                typeChoose.modelList = modelType;
                //            }
            }
            Choose{
                id: lineChoose
                objectName : "lineChoose"
                height: 300
                anchors.left: parent.left
                anchors.right: parent.right
                typeName: qsTr("Sélectionner votre ligne :")
                modelList: dataRequest.linesList
                enableSearch: true
                state: "hide"
                function fillLine(array){
                    modelList = array;
                }

                onUserClicked: {
                    abort = false;
                    directionChoose.busySwitcher = true;
                    lineID = _idJson;
                    dataRequest.getDirections(_idJson)

                }
                onSectionClicked: {
                    abort = true;
                    if(typeChoose.state !== "selected" || typeChoose.state !== "show")
                    {
                        directionChoose.state = "hide"
                        stationChoose.state = "hide"
                        result.state = "hide"
                    }
                    if(state === "selected")
                        state = "show";
                }
                onSearch: {

                }
            }
            Choose{
                id: directionChoose
                objectName: "directionChoose"
                typeName: qsTr("Sélectionner votre direction :")
                anchors.left: parent.left
                anchors.right: parent.right
                modelList: dataRequest.directionsList
                enableSearch: false
                state: "hide"
                height: 300
                onUserClicked: {
                    abort = false;
                    stationChoose.busySwitcher = true;
                    directionID = _idJson;
                    dataRequest.getStations(lineID, directionID);
                }
                onSectionClicked: {
                    abort = true;
                    if(lineChoose.state !== "selected" || lineChoose.state !== "show")
                    {
                        stationChoose.state = "hide"
                        result.state = "hide"
                    }
                    if(state === "selected")
                        state = "show";
                }
            }
            Choose{
                id: stationChoose
                objectName: "stationChoose"
                typeName: qsTr("Sélectionner votre station :")
                anchors.left: parent.left
                anchors.right: parent.right
                state: "hide"
                height: 300
                enableSearch: true
                modelList: dataRequest.stationsList
                onSelectedItemIsReady: {
                    urlType = typeChoose.getCurrentImage();
                    urlLigne = lineChoose.getCurrentImage()
                    ligne = lineChoose.getSelectedName();
                    direction = directionChoose.getSelectedName();
                    station = getSelectedName();

//                    console.debug("Ligne : " + ligne)
//                    console.debug("direction : " + direction)
//                    console.debug("station : " + station)
//                    console.debug("urlLigne : " + urlLigne)
                }

                onUserClicked: {
                    abort = false;
                    result.busySwitcher = true;
                    stationID = _idJson;
                    dataRequest.getSchedule(lineID, directionID, stationID);
                }
                onSectionClicked: {
                    abort = true;
                    if(stationChoose.state !== "selected" || stationChoose.state !== "show")
                        result.state = "hide"
                    if(state === "selected")
                        state = "show";
                }
            }
            Choose{
                id: result
                objectName: "result"
                typeName: qsTr("Résultats :")
                anchors.left: parent.left
                anchors.right: parent.right
                state: "hide"
                height: 300
                enableSearch: false
                modelList: dataRequest.scheduleList
                onModelHasChanged: {
                    _urlLine = lineChoose.getCurrentImage();
                    _urlType = typeChoose.getCurrentImage();
                    _sharedModel = result.modelList

                }
                onSectionClicked: {
                    //                abort = true;
                    //                    _defaultState()
                }
            }

        }
    }
}
