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
//    property alias modelList: list.model

    property bool enableSearch: false

    property var modelList : []
    property var lineList: []
    onModelListChanged: reBaseModel()

    property alias busySwitcher : switcher.busy

    signal sectionClicked;
    signal userClicked(variant _idJson);
    signal modelHasChanged;
    signal search(string txt);
    signal selectedItemIsReady;

    function addType(){
        searchModel.append({"idJson": 1,"line": "Bus", "urlLine": "qrc:/logo/bus.png"});
        searchModel.append({"idJson": 2,"line": "Métro", "urlLine": "qrc:/logo/metro.png"});
        searchModel.append({"idJson": 3,"line": "RER", "urlLine": "qrc:/logo/rer.png"});
        searchModel.append({"idJson": 6,"line": "Tram", "urlLine": "qrc:/logo/tramway.png"});

    }

    function getCurrentImage(){
        return selectedItem.url;
    }
    function getSelectedName(){
        return selectedItem.line;
    }

    function reBaseModel(){
        lineList = [];
        searchModel.clear();
        for(var i = 0; i < modelList.length; i++)
        {
            searchModel.append(modelList[i]);
            lineList.push(modelList[i].line);
        }
    }

    Component.onCompleted: {
        searchModel.clear();
        if(enableSearch)
            list.header = cmpHeader;
    }

    ListModel{
        id: searchModel
        function update() {
            clear()
            for (var i=0; i<modelList.length; i++) {
                if (list.headerItem.text == "" || lineList[i].indexOf(list.headerItem.text) >= 0) {
                    append(modelList[i])
                }
            }
        }
    }

    BackgroundItem  {
        id: rectType
        height: 62
        z:1
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        TextSwitch{
            id: switcher
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: -50
            smooth: true
            highlighted: true
            down: true
            z:100
            text: typeName
            state: "hiddenSwitch"
            onClicked: {
                sectionClicked();
                if(state === "displaySwitch")
                    checked = true;
                if(item1.state === "hide")
                    checked = false;
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
                    when: busySwitcher
                    name: "busySwitch"
                    PropertyChanges {
                        target: switcher
                        anchors.horizontalCenterOffset: 0
                        checked: true
                        busy: true
                    }
                },
                State {
                    name: "displaySwitch"
                    PropertyChanges {
                        target: switcher
                        anchors.horizontalCenterOffset: 0
                        checked: true
                        busy: false
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

        SelectedItem{
            id: selectedItem
            height: 50
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: rectType.height
            state: "hide"
            states: [
                State {
                    name: "show"
                    PropertyChanges {
                        target: selectedItem
//                        anchors.leftMargin: 0
                        anchors.leftMargin: 0
                        visible: true;
                    }
                },
                State {
                    name: "hide"
                    PropertyChanges {
                        target: selectedItem
                        visible: true;
                        anchors.leftMargin: -parent.width
                    }
                }
            ]
            onLineChanged: selectedItemIsReady()
            Behavior on anchors.topMargin { NumberAnimation { duration: 500 } }
            Behavior on anchors.leftMargin { NumberAnimation { duration: 500 } }
        }
        Separator {
            opacity: 0.5
            anchors {
                bottom: parent.bottom
            }
            width: contentItem.width
            color: Theme.primaryColor
        }
    }
    Component{
        id: cmpHeader
//        property alias search: searchField
        SearchField{
            id: searchField
            width: parent.width
            placeholderText: qsTr("Rechercher")
            onTextChanged: {
                searchModel.update();
            }

        }
    }

    SilicaListView{
        id: list
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: rectType.bottom
        anchors.topMargin: 5
        snapMode: ListView.SnapToItem
        z:-1
        smooth: true
        clip: true
        focus: true
        model: searchModel
        onModelChanged: modelHasChanged()
        delegate:  BackgroundItem {
            id: delegate
            height: 60
            Row{
                anchors.fill: parent
                Image{
                    id: image
                    source: urlLine === undefined ? "" : urlLine
                    cache: true
                    asynchronous: true
                    fillMode: Image.PreserveAspectFit
                    anchors.verticalCenter: parent.verticalCenter
                    height: urlLine === undefined ? 0 : 60
                    width: urlLine === undefined ? 0 : 60
                    opacity: 0
                    onStatusChanged: if (image.status == Image.Ready) opacity = 1
                    Behavior on opacity { NumberAnimation{
                            duration: 300
                        }}
                }
                Label {
                    id: label
                    x: Theme.paddingLarge
                    text: line
                    anchors.verticalCenter: parent.verticalCenter
                    color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                }
            }
            onClicked: {
                userClicked(idJson);
//                console.log("Clicked " +line + " " + idJson);
                selectedItem.line = label.text
                selectedItem.url = image.source
                item1.state = "selected"
//                search.text = "";
            }
        }
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
                height: 400
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
                onVisibleChanged: scrollToTop();
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
            PropertyChanges{
                target: switcher
                state: "hiddenSwitch"
            }
        }
    ]
    transitions: [
        Transition {
            from: "*"
            to: "*"
            PropertyAnimation{
                properties: "height"
                duration: 300
                easing.type:Easing.InQuart
            }
        }
    ]

}

