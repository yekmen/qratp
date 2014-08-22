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
import "../../js/TabDataBase.js" as TabDB
import "../../js/Offline.js" as Offline

Item{
    id: main
//    property int whoIAm //False = Aller | true = retour
    property string switchTitle
    property bool switchChecked: false
    property string currentItName
    property int currentTabID
    property date firstRequest
    property bool autoUpdate: false

    signal headerSwitcherChecked;
//    signal sideBarChanged(bool value);
    signal addNewItinerary(bool sens);


    function updateTab(){
        listModelSideBar.clear();
        var array = TabDB.getAllItems();
        for(var i = 0; i < array.length; i++)
        {
            if(array[i].sens === whoIAm)
                listModelSideBar.append({"line": array[i].columnName, "indexDB": array[i].id})
        }
        updateHolder();
    }
    function loadTab(value, id){
        currentItName = value;
        currentTabID = id;
        listModel.clear();
        listView.headerItem.description = value;
        var array = Offline.getItemsByName(whoIAm, id);
        for(var i = 0; i < array.length; i++)
        {
            listModel.append({"indexDB": array[i].id,
                                "ligneName": array[i].ligneName,
                                "direction": array[i].direction,
                                "stationName":array[i].station,
                                "jsonURL": array[i].url,
                                "urlImage": array[i].urlImage})
        }

        updateHolder();
        listView.update();
        timerLastUpdate.start();
        firstRequest = new Date();
        closeSideBar()
    }
    function removeTab(id, sens){
        TabDB.removeItems(id, sens);
        Offline.removeItems(id, sens)
        listModel.clear();
        listView.headerItem.description = "";
        listView.headerItem.lastUpdateTxt = "";
        timerLastUpdate.stop();
        updateTab();
    }
    function addNewTab(){
        var dialog = pageStack.push("ItNameInputDialog.qml")
                   dialog.accepted.connect(function()
                   {
                       var nameOfItin;
                       nameOfItin = dialog.name;
                       TabDB.addItinerary(nameOfItin, whoIAm);
                       updateTab();  //update
                   })
    }
    function closeSideBar(){
        sideBar.state = "hide"
        opactiyEffect.state = "disable"
//        listView.headerItem.textswitch.checked = false;
//        listMouse.enabled = false;
    }
    function openSideBar(){
        opactiyEffect.state = "enable"
        sideBar.state = "show"
//        listView.headerItem.textswitch.checked = true;
//        listMouse.enabled = true;
    }
    function updateHolder(){
        if(listModelSideBar.count == 0){
            holder.enabled = true;
            holder.text = qsTr("Veuillez créer un onglet")
            listView.headerItem.textswitch.lighter();
//            listView.headerItem.textswitch.busy = true;
            pullDownMenu.visible = false;
        }
        else if(currentItName == "" && listModelSideBar.count > 0){
            holder.enabled = true;
            holder.text = qsTr("Veuillez sélectionner un onglet")
            listView.headerItem.textswitch.lighter();
//            listView.headerItem.textswitch.busy = true;
            pullDownMenu.visible = false;
        }
        else if (currentItName != "" && listModelSideBar.count > 0 && listModel.count == 0){
            holder.enabled = true;
            holder.text = qsTr("Vous n'avez aucun itinéraire de sauvegardé dans cet onglet")
            listView.headerItem.textswitch.stopLigther();
            pullDownMenu.busy = true;
            pullDownMenu.visible = true;
        }
        if(listModel.count > 0){
            holder.enabled = false;
            pullDownMenu.visible = true;
        }
        else
            timer.start();
    }
    function updateTime(){
        var text;
        if(autoUpdate)
        {
            text = qsTr("Auto update 1 mn : ON")
            for(var i = 0; i < listView.count; i++){
                listView.currentIndex = i;
                listView.currentItem.update();
            }
        }
        else
        {
            var lastGettedTime = new Date();
            var ret = lastGettedTime.getMinutes() - firstRequest.getMinutes();
            text = "Dernière MAJ il y a " + ret + " mn";
        }
        listView.headerItem.lastUpdateTxt = text;
    }

    Component.onCompleted: {
        updateTab();
    }

    ListModel{
        id:listModel
    }
    ListModel{
        id:listModelSideBar
    }

    Timer{
        id: timer
        repeat: false
        running: false
        interval: 5000
        onTriggered: {
            if(pullDownMenu.busy)
                pullDownMenu.busy = false;
            if(listView.headerItem.textswitch.busy)
                listView.headerItem.textswitch.busy = false;
        }
    }

    Timer{
        id: timerLastUpdate
        repeat: true
        interval: 60000 //1min
        onTriggered: updateTime()
    }

    SilicaListView {
        id: listView
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        model: listModel
        clip: true
//        focus: true
        smooth: true
        header:PageHeader {
            property alias textswitch: switcher
            property alias lastUpdateTxt : lastUpdateLabel.text
            id: pageHeader
            title: pageTitle

            SideBarButton{
                id: switcher
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 10
                onItemClicked: {
                    openSideBar();
//                    if(checked)
//                    else
//                        closeSideBar();

//                    sideBarChanged(checked)
                }
            }
//            TextSwitch{
//                id: switcher
//                checked: switchChecked
//                text: switchTitle
//                anchors.left: parent.left
//                onCheckedChanged: {
//                    if(checked)
//                        openSideBar();
//                    else
//                        closeSideBar();

//                    sideBarChanged(checked)
//                }

//            }
            Label{
                id: lastUpdateLabel
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.highlightColor
                opacity: 0.6
                horizontalAlignment: Text.AlignLeft
                truncationMode: TruncationMode.Fade
                visible: listModel.count > 0
            }
        }
        delegate:MainDelegateItem{
            ListView.onRemove: animateRemoval()
            menu: contextMenuComponent
            function remove() {
                remorseAction("Suppression", function() {
                    listView.model.remove(index)
                    Offline.removeItem(dbID, whoIAm)
                    updateHolder();
                })
            }
            Component {
                id: contextMenuComponent
                ContextMenu {
                    MenuItem {
                        text: qsTr("Supprimer")
                        onClicked: remove()
                    }
                }
            }
        }
        ViewPlaceholder {
                id: holder
                enabled: false
        }
        PullDownMenu {
            id: pullDownMenu
            MenuItem {
                text: qsTr("À Propos")
                onClicked: {
                    var ret = pageStack.push(Qt.resolvedUrl("../AboutPage.qml"));
                }
            }
            MenuItem {
                text: qsTr("Auto update : 1 mn")
                onClicked: {
                    if(autoUpdate){
                        autoUpdate = false;
                        listView.headerItem.lastUpdateTxt = "";
                    }
                    else
                    {
                        autoUpdate = true;
                        listView.headerItem.lastUpdateTxt = qsTr("Auto update 1 mn : ON");
                    }
                }
            }
            MenuItem {
                text: qsTr("Ajouter un itinéraire")
                onClicked: {
                    var ret = pageStack.push(Qt.resolvedUrl("../SecondPage.qml"), {whereFrom : whoIAm});
                    ret.accepted.connect(function(){
                        Offline.addItinerary(currentItName,ret.ligne, ret.direction, whoIAm, dataRequest.getScheduleURL(), ret.urlLigne, ret.station, currentTabID);
                        loadTab(currentItName, currentTabID);    //Update
                        listView.headerItem.lastUpdateTxt = "";
                    })
//                    ret.rejected.connect(function(){
//                    })
                }
            }
        }
        VerticalScrollDecorator {}

    }
    SideBar{
        id: sideBar
        sideBarModel: listModelSideBar
        width: parent.width/2 +20

        anchors.top: parent.top
        anchors.bottom: parent.bottom
//        x: -parent.width/2 + 20
        x: -width
        z:100
        //-------------- SLOTS ------------//
        onItemsClicked: loadTab(itemName, id)
        onAddClicked: addNewTab()
        onRemoveItem: removeTab(itemID, whoIAm);

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
    OpacityRampEffect {
        id: opactiyEffect
        sourceItem: listView
        direction: OpacityRamp.LeftToRight
        MouseArea{
            id: opactiyMouseArea
            anchors.fill: parent
            onClicked: {
                closeSideBar();
            }
        }
        z:50
        state: "disable"
        states: [
            State {
                name: "enable"
                PropertyChanges {
                    target: opactiyEffect
                    slope: 2.0
//                    offset: 1.0
                }
                PropertyChanges {
                    target: opactiyMouseArea
                    enabled: true
                }
            },
            State {
                name: "disable"
                PropertyChanges {
                    target: opactiyEffect
                    slope: 0.0
//                    offset: 0.0
                }
                PropertyChanges {
                    target: opactiyMouseArea
                    enabled: false
                }
            }
        ]
        transitions: [
            Transition {
                from: "*"
                to: "*"
                PropertyAnimation{
                    properties: "slope, offset"
                    easing.type: Easing.InOutQuad
                    duration: 500
                }
            }
        ]
    }
}


