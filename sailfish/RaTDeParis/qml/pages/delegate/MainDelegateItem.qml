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
import "../../js/RequestID.js" as RequestID
import harbour.DataRequest 1.0

ListItem {
    id: delegate
//    height: 220
    contentHeight: 220
    property int dbID: indexDB

    Component.onCompleted: {
        dataRequestDelegate.getSchedule(jsonURL);
    }
    function update(){
        dataRequestDelegate.getSchedule(jsonURL);
        busyIndicator.running = true;
        busyIndicator.visible = true;
    }
    function fillModel(modelList){
        delegateModel.clear();
        for(var i = 0; i < modelList.length; i++)
        {
            delegateModel.append(modelList[i]);
        }
    }

    DataRequest{
        id: dataRequestDelegate
    }
    Connections{
        target: dataRequestDelegate
        ignoreUnknownSignals: true
        onSchedulesChanged:{
            busyIndicator.running = false;
            busyIndicator.visible = false;
            fillModel(dataRequestDelegate.scheduleList);
        }
    }
    Column{
        anchors.fill: parent
        spacing: 1
        Row{
            id: row
            height: 50
            anchors.left: parent.left
            anchors.right: parent.right
            Image{
                id: image
                source: urlImage === undefined ? "" : urlImage
                cache: true
                asynchronous: true
                fillMode: Image.PreserveAspectFit
                anchors.verticalCenter: parent.verticalCenter
                height: 60
                width: 60
                opacity: 0
                onStatusChanged: if (image.status == Image.Ready) opacity = 1
                Behavior on opacity { NumberAnimation{
                        duration: 300
                    }}
            }
            Label {
                id: label
//                x: Theme.paddingLarge
                text: stationName
                anchors.verticalCenter: parent.verticalCenter
                color: Theme.highlightColor
            }
        }
        Separator {
            opacity: 0.8
//            anchors.top: row.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            width: 5
            color: Theme.primaryColor
        }
        ListView{
            id: scheduleList
            anchors.left: parent.left
            anchors.right: parent.right
            height: delegate.height - row.height
//            model: dataRequestDelegate.scheduleList()
            model: ListModel{
                id: delegateModel
            }

            clip: true
            focus: true
            smooth: true
            interactive: false

            onCountChanged: {
                if(count > 4)
                    interactive = true;
            }

            delegate: BackgroundItem {
                id: delegateSchedule
                height: 40
                enabled: false
                z:-1
                Row{
                    anchors.fill: parent
                    Label {
                        x: Theme.paddingLarge
                        text: line
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.secondaryColor
                        opacity: 0.8
                    }
                }
            }
            BusyIndicator{
                id: busyIndicator
                anchors.centerIn: parent
                running: true
            }
        }

    }

}
