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

import QtQuick.LocalStorage 2.0
import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.DataRequest 1.0
import "tools"
import "../js/Offline.js" as Offline
import "../js/TabDataBase.js" as TabDB

Page {
    id: fpage
    property int currentSens: 0
    ListView{
        id: mainList
        anchors.fill: parent
        orientation: ListView.HorizontalFlick
        snapMode: ListView.SnapOneItem;
        model: dataModel
        flickDeceleration: 0
        HorizontalScrollDecorator{}

        Component.onCompleted: autoLoadTab();
    }
    function autoLoadTab() {
        modelAller.clear();
        modelRetour.clear();
        var array = TabDB.getAllItems();
        console.debug("Size : " + array.length);
        for(var i = 0; i < array.length; i++)
        {
            console.debug(array[i].columnName + " " + array[i].sens)
            if(array[i].sens === 0)
                modelAller.append({"line": array[i].columnName})
            else
                modelRetour.append({"line": array[i].columnName})
        }
    }
    function addItinerary(){
        var tabName = "o yeah";
//        if(currentSens === 0)    //Aller
//        {
//            tabName = currentTabNameAller;
//        }
//        else    //retour
//        {
//            tabName = currentTabNameRetour;
//        }
        TabDB.addItinerary(tabName,currentSens);
        autoLoadTab();
    }

    ListModel{
        id: modelAller
    }
    ListModel{
        id: modelRetour
    }
    VisualDataModel {
        id: dataModel
        model: ListModel{
            ListElement{
                pageTitle: "Aller"
                whoIAm: false   //Aller
//                toto : test
            }
            ListElement{
                pageTitle : "Retour"
                whoIAm: true //Retour
            }
        }
        delegate: PageItem{
            width: mainList.width;
            height: mainList.height;
//            listModel: modelAller
//            listModelSideBar:
            onAddNewItinerary: {
                console.debug("New it : " + sens)
                addItinerary();
            }
        }
    }

/*
        SilicaListView {
            id: listView
            model: dataRequest.linesList
            anchors.fill: parent
            header: PageHeader {
                title: "Nested Page"
            }
            delegate: BackgroundItem {
                id: delegate
                Row{
                    Image{
                        source: urlType
                        cache: true
                    }
                    Image{
                        source: urlLine
                        cache: true
                    }
                    Label {
                        x: Theme.paddingLarge
                        text: line
    //                    anchors.verticalCenter: parent.verticalCenter
                        color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                    }

                }
                onClicked: console.log("Clicked " + idJson + "\n" + typeID +"\n" +typeName + "\n"+urlLine);
            }
        PullDownMenu {
            id: pullDownMenu
            MenuItem {
                text: "Add Itin"
                onClicked: pageStack.push(secondPage);
            }
//            MenuLabel {
//                text: "Menu label"
//            }
        }
        VerticalScrollDecorator {}
    }
    */
}


