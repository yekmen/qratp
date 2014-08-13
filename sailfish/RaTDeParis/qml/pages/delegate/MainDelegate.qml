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

BackgroundItem {
    id: delegate
    height: 200
    Component.onCompleted: dataRequest.getSchedule(jsonURL);

    Connections{
        target: dataRequest
        ignoreUnknownSignals: true
        onSchedulesChanged:{
            console.debug("Loading ok");
            scheduleList.update();
        }
    }
    Column{
        anchors.fill: parent
        spacing: 2
        Row{
            id: row
            height: 60
            anchors.left: parent.left
            anchors.right: parent.right
            Image{
                id: image
                source: urlImage === undefined ? "" : urlImage
                cache: true
                asynchronous: true
                fillMode: Image.PreserveAspectFit
                anchors.verticalCenter: parent.verticalCenter
                height: urlLine === undefined ? 0 : 60
                width: urlLine === undefined ? 0 : 60
            }
            Label {
                id: label
//                x: Theme.paddingLarge
                text: stationName
                anchors.verticalCenter: parent.verticalCenter
                color: Theme.highlightColor
            }
        }
        ListView{
            id: scheduleList
            anchors.left: parent.left
            anchors.right: parent.right

            height: delegate.height - row.height
            model: dataRequest.scheduleList
            delegate: BackgroundItem {
                id: delegateSchedule
                height: 40
                Row{
                    anchors.fill: parent
                    Label {
                        x: Theme.paddingLarge
                        text: line
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.highlightColor
                    }
                }
            }
        }
    }


}
