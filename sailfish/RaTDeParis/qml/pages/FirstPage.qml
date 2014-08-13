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
        clip: true
        focus: true
        smooth: true

        HorizontalScrollDecorator{}
    }
    VisualDataModel {
        id: dataModel

        model: ListModel{
            ListElement{
                pageTitle: "Aller"
                whoIAm: 0   //Aller
            }
            ListElement{
                pageTitle : "Retour"
                whoIAm: 1 //Retour
            }
        }
        delegate: PageItem{
            width: mainList.width;
            height: mainList.height;
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


