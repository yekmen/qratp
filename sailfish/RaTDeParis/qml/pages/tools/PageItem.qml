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
import QtQuick 2.1
import Sailfish.Silica 1.0
import "../delegate"
import Effects 1.0
import "../../js/TabDataBase.js" as TabDB
import "../../js/Offline.js" as Offline

Item{
    id: main
//    property int whoIAm //False = Aller | true = retour
    property string switchTitle
    property bool switchChecked: false
    property string currentItName

    signal headerSwitcherChecked;
    signal sideBarChanged(bool value);
    signal addNewItinerary(bool sens);

    function loadData(){
        listModelSideBar.clear();
        var array = TabDB.getAllItems();
        console.debug("Size : " + array.length);
        for(var i = 0; i < array.length; i++)
        {
            console.debug(array[i].columnName + " " + array[i].sens + " " + whoIAm)
            if(array[i].sens === whoIAm)
                listModelSideBar.append({"line": array[i].columnName, "indexDB": array[i].id})
        }
    }
    function loadItin(value){
        currentItName = value;
        listModel.clear();

        console.debug("Items LOADING " + value)
        listView.headerItem.description = value;
        var array = Offline.getItemsByName(value, whoIAm);
        for(var i = 0; i < array.length; i++)
        {
            listModel.append({"indexDB": array[i].id,
                                "ligneName": array[i].ligneName,
                                "direction": array[i].direction,
                                "stationName":array[i].station,
                                "jsonURL": array[i].url,
                                "urlImage": array[i].urlImage})
        }

        listView.update();
        closeSideBar()
    }
    function removeItin(name, sens){

    }
    function addItin(){
        var dialog = pageStack.push("ItNameInputDialog.qml")
                   dialog.accepted.connect(function()
                   {
                       var nameOfItin;
                       nameOfItin = dialog.name;
                       TabDB.addItinerary(nameOfItin, whoIAm);
                       loadData();  //update
                   })
    }
    function closeSideBar(){
        sideBar.state = "hide"
        listView.headerItem.textswitch.checked = false;
        listMouse.enabled = false;
    }
    function openSideBar(){
        sideBar.state = "show"
        listView.headerItem.textswitch.checked = true;
        listMouse.enabled = true;
    }

    Component.onCompleted: {
        loadData();
    }
    ListModel{
        id:listModel
    }
    ListModel{
        id:listModelSideBar
    }

    SilicaListView {
        id: listView
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        model: listModel
        header:PageHeader {
            property alias textswitch: switcher
            id: pageHeader
            title: pageTitle
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            TextSwitch{
                id: switcher
                checked: switchChecked
                text: switchTitle
                anchors.left: parent.left
                onCheckedChanged: {
                    if(checked)
                        openSideBar();
                    else
                        closeSideBar();

                    sideBarChanged(checked)
                }
            }
        }
        delegate:MainDelegate{

        }

        PullDownMenu {
            id: pullDownMenu
            MenuItem {
                text: "Add Itin"
                onClicked: {
                    var ret = pageStack.push(Qt.resolvedUrl("../SecondPage.qml"), {whereFrom : whoIAm});
                    ret.accepted.connect(function(){
                        console.debug("User accepted : " + dataRequest.scheduleList.length)
//                        dataRequest.addItineraire(dataRequest.scheduleList);
                        Offline.addItinerary(currentItName,ret.ligne, ret.direction, whoIAm, dataRequest.getScheduleURL(), ret.urlLigne, ret.station);
                    })
                    ret.rejected.connect(function(){
                        console.debug("User refected : " + dataRequest.scheduleList.length)
                    })
                }
            }
        }
        VerticalScrollDecorator {}
        MouseArea{
            id: listMouse
            anchors.fill: parent
            enabled: false
            z:2
            onClicked: {
                closeSideBar();
            }
        }
    }
    SideBar{
        id: sideBar
        sideBarModel: listModelSideBar
        width: parent.width/2

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        x: -parent.width/2
        z:100
        //-------------- SLOTS ------------//
        onItemsClicked: loadItin(itemName)
        onAddClicked: addItin()
        onRemoveItem: removeItin(itemName, whoIAm);

        state: "hide"   //default state
        states: [
            State {
                name: "show"
                PropertyChanges {
                    target: sideBar
                    x:0
                    opacity:1
                }
            },
            State {
                name: "hide"
                PropertyChanges {
                    target: sideBar
                    x: -parent.width/2
                    opacity:0
                }
            }
        ]
        transitions: [
            Transition {
                from: "hide"
                to: "show"
                PropertyAnimation { target: sideBar
                                    properties: "x,opacity"
                                    duration: 350
                                    easing.type: Easing.OutQuad}
            },
            Transition {
                from: "show"
                to: "hide"
                PropertyAnimation { target: sideBar
                                    properties: "x,opacity"
                                    duration: 350
                                    easing.type: Easing.InQuad}
            }
        ]
    }

}


