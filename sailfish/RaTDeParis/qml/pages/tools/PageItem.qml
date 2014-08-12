import QtQuick 2.1
import Sailfish.Silica 1.0
import "../delegate"
import Effects 1.0

Item{
    id: main
    property ListModel listModel
    property ListModel listModelSideBar
    property bool whoIAm //False = Aller | true = retour
    property string switchTitle
    property bool switchChecked: false

    signal headerSwitcherChecked;
    signal sideBarChanged(bool value);
    signal addNewItinerary(bool sens);
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
                    if(checked){
                        listMouse.enabled = true;
                        sideBar.state = "show";
                    }
                    else{
                        listMouse.enabled = false;
                        sideBar.state = "hide";
                    }
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
                        dataRequest.addItineraire(dataRequest.scheduleList);
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
                sideBar.state = "hide"
                listView.headerItem.textswitch.checked = false;
                console.debug("CLICKED !!")
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
        onAddClicked: addNewItinerary(whoIAm)
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


