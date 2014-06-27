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

Item{
    id: item1
    state: "hide"

    property string typeName
    property alias modelList: list.model

    signal sectionClicked;
    signal userClicked(variant _idJson);


    function addType(){
        modelList.append({"idJson": 1,"line": "Bus", "urlLine": "qrc:/logo/bus.png"});
        modelList.append({"idJson": 2,"line": "Métro", "urlLine": "qrc:/logo/metro.png"});
        modelList.append({"idJson": 3,"line": "RER", "urlLine": "qrc:/logo/rer.png"});
        modelList.append({"idJson": 6,"line": "Tram", "urlLine": "qrc:/logo/tramway.png"});
//        stopBusy();
    }
    Rectangle {
        id: rectType
        height: 62
        opacity: 0.7
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#083ec6"
            }

            GradientStop {
                position: 1
                color: "#000000"
            }
        }
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        TextSwitch{
            id: switcher
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: -50
            smooth: true

            z:100
            text: typeName
            state: "hiddenSwitch"
            onClicked: {
                sectionClicked();

                if(item1.state === "hide")
                {
                    item1.state = "selected"
                }
                else if(item1.state === "show")
                    selectedItem.state = "hide"

            }

            states: [
                State {
                    name: "hiddenSwitch"
                    PropertyChanges {
                        target: switcher
                        anchors.horizontalCenterOffset: -50
                        checked: false
                    }
                },
                State {
                    name: "displaySwitch"
                    PropertyChanges {
                        target: switcher
                        anchors.horizontalCenterOffset: 0
                        checked: true
                    }
                }
            ]
            transitions: [
                Transition {
                    from: "*"
                    to: "*"
                    PropertyAnimation{
                        properties: "anchors.horizontalCenterOffset"
                        easing.type:Easing.InCirc
                        duration: 200
                    }
                }
            ]
        }
/*
//        Switch {
//            anchors.fill: parent
//            smooth: true
//            text: typeName
//            onCheckedChanged: { busy = true; textBusyTimer.start() }
//            Timer {
//                id: textBusyTimer
//                interval: 4700
//                onTriggered: parent.busy = false
//            }
//            onClicked: {
//                sectionClicked();
//                if(item1.state === "hide" || item1.state === "selected"){
//                    item1.state = "show"
//                }
//                else if(item1.state === "show"){
//                    selectedItem.state = "hide"
//                }
////                else
////                    item1.state = "hide"
//            }
//        }
*/
        SelectedItem{
            id: selectedItem
            height: 50
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.top: parent.top
            state: "hide"
            states: [
                State {
                    name: "show"
                    PropertyChanges {
                        target: selectedItem
                        anchors.topMargin: rectType.height
                        visible: true;
                    }
                },
                State {
                    name: "hide"
                    PropertyChanges {
                        target: selectedItem
                        visible: false;
                        anchors.topMargin: -rectType.height

                    }
                }
            ]
            Behavior on anchors.topMargin { NumberAnimation { duration: 300 } }
        }
    }
    SilicaListView{
        id: list
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: rectType.bottom
        z:-1
        model: modelList
        delegate:  BackgroundItem {
            id: delegate
            height: 80
            Row{
                anchors.fill: parent
                Image{
                    id: image
                    source: urlLine == "" ? "" : urlLine
                    cache: true
                    asynchronous: true
                    fillMode: Image.PreserveAspectFit
                    anchors.verticalCenter: parent.verticalCenter
                    height: urlLine == "" ? 0 : 75
                    width: urlLine == "" ? 0 : 75
                }
                Label {
                    id: label
                    x: Theme.paddingLarge
                    text: line

//                    font.pixelSize: 20
//                    anchors.top: parent.top
//                    anchors.bottom: parent.bottom
                    anchors.verticalCenter: parent.verticalCenter
                    color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                }

            }
            onClicked: {
                sectionClicked()
                userClicked(idJson);
                console.log("Clicked " +line + " " + idJson);
                selectedItem.line = label.text
                selectedItem.url = image.source
//                selectedItem.state = "show"
            }
        }
    }
    ListModel{
        id: modelList
    }

    states: [
        State {
            name: "show"
            PropertyChanges{
                target: switcher
                state: "displaySwitch"
            }

            PropertyChanges {
                target: item1
                height: 250
            }
            PropertyChanges {
                target: list
                visible: true
            }
            PropertyChanges {
                target: selectedItem
                visible: false
                state: "hide"
            }
        },
        State {
            name: "hide"
            PropertyChanges{
                target: switcher
                state: "hiddenSwitch"
            }

            PropertyChanges {
                target: item1
                height: rectType.height

            }
            PropertyChanges {
                target: list
                visible: false
            }
            PropertyChanges {
                target: selectedItem
                visible: false
                state: "hide"
            }
        },
        State {
            name: "selected"
            PropertyChanges {
                target: item1
                height: rectType.height + 50
            }
            PropertyChanges {
                target: list
                visible: false
            }
            PropertyChanges {
                target: selectedItem
                visible: true
                state: "show"
            }
        }
    ]
    transitions: [
        Transition {
            from: "show"
            to: "hide"
            PropertyAnimation{
                properties: "height"
                duration: 300
                easing.type:Easing.OutCirc
            }
        },
        Transition {
            from: "hide"
            to: "show"
            PropertyAnimation{
                properties: "height"
                duration: 300
                easing.type:Easing.InCirc
            }
        },
        Transition {
            from: "show"
            to: "selected"
            PropertyAnimation{
                properties: "height"
                duration: 300
                easing.type:Easing.InCirc
            }
        },
        Transition {
            from: "selected"
            to: "show"
            PropertyAnimation{
                properties: "height"
                duration: 300
                easing.type:Easing.InCirc
            }
        }
    ]

}

