/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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

//    SilicaFlickable{
////        anchors.top: header.bottom
//        anchors.top: parent.top
//        anchors.left: parent.left
//        anchors.right: parent.right
//        anchors.bottom: parent.bottom
        PageHeader {
            id: header
            title: "Nested Page"
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
        }
        PullDownMenu {
            id: pullDownMenu
            MenuItem {
                text: "Reset"
                onClicked: {
                    _defaultState();
                    typeChoose.state = "show";
                }
            }
//            MenuItem {
//                text: "Toggle busy menu"
//                onClicked: pullDownMenu.busy = !pullDownMenu.busy
//            }
            MenuLabel {
                text: "Menu label"
            }
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
//    }
}





