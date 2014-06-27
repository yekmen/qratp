// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 2.0
import Sailfish.Silica 1.0

Item{
    id: item1
//    width: 400
//    height: 400
    state: "hide"

    property string typeName
    property alias modelList: list.model
//    property ListModel modelList
//    function startBusy(){
//        busy.running = true;
//        busy.visible = true;
//    }
//    function stopBusy(){
//        busy.running = false;
//        busy.visible = false;
//    }

//    signal typeSelected(variant _idJSON, variant _line, variant _typeID, variant _urlImage)
    signal sectionClicked;
//    signal userClicked(variant _typeID, variant _typeName, variant _idJson);
    signal userClicked(variant _idJson);

    function addTransportType(array) {
        modelList.clear();
        for(var i = 0; i < array.length; i++){
            modelList.append({"index": i, "type": array[i].type_id, "jsonID": array[i].idJSON, "jsonLINE": array[i].line, "picURL": array[i].picURL});
        }
       item1.state = "show"
    }

    function addType(){
        modelList.append({"idJson": 1,"line": "Bus", "urlLine": "qrc:/logo/bus.png"});
        modelList.append({"idJson": 2,"line": "Métro", "urlLine": "qrc:/logo/metro.png"});
        modelList.append({"idJson": 3,"line": "RER", "urlLine": "qrc:/logo/rer.png"});
        modelList.append({"idJson": 6,"line": "Tram", "urlLine": "qrc:/logo/tramway.png"});
//        stopBusy();
    }
    function addDirection(direction){
        modelList.clear();
        for(var i = 0; i < direction.count; i++){
            modelList.append({"index": i, "type": "", "jsonID": direction.get(i).id, "jsonLINE": direction.get(i).direction, "picURL": ""});
        }
        item1.state = "show"
        stopBusy();
    }
    function addStation(stations){
        modelList.clear();
        for(var i = 0; i < stations.count; i++){
            modelList.append({"index": i, "type": "", "jsonID": stations.get(i).id, "jsonLINE": stations.get(i).station, "picURL": ""});
        }
        item1.state = "show"
        stopBusy();
    }
    function addSchedule(schedule){
        modelList.clear();
        for(var i = 0; i < schedule.count; i++){
            modelList.append({"index": i, "type": "", "jsonID": schedule.get(i).id, "jsonLINE": schedule.get(i).direction + ":"+schedule.get(i).time , "picURL": ""});
        }
        item1.state = "show"
        stopBusy();
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
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
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

                if(item1.state === "hide" || item1.state === "selected"){
                    item1.state = "show"
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

        SelectedItem{
            id: selectedItem
            height: 50
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            state: "hide"
            states: [
                State {
                    name: "show"
                    PropertyChanges {
                        target: selectedItem
                        anchors.topMargin: rectType.height
                    }
                },
                State {
                    name: "hide"
                    PropertyChanges {
                        target: selectedItem
                        anchors.topMargin: -rectType.height

                    }
                }
            ]
        }
    }
    SilicaListView{
        id: list
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: rectType.bottom
//        anchors.topMargin: -rectType.height
        z:-1
        model: modelList
        delegate:  BackgroundItem {
            id: delegate
            height: 50
            Row{
//                Image{
//                    source: urlType
//                    cache: true
//                    fillMode: Image.PreserveAspectFit
//                    anchors.top: parent.top
//                    anchors.bottom: parent.bottom
//                }
                Image{
                    source: urlLine/* ? "" : ""*/
                    cache: true
                    fillMode: Image.PreserveAspectFit
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                }
                Label {
                    x: Theme.paddingLarge
                    text: line
//                    anchors.verticalCenter: parent.verticalCenter
                    color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                }

            }
            onClicked: {
                sectionClicked()
//                userClicked(typeID,typeName, idJson);
                userClicked(idJson);
                console.log("Clicked " +line + " " + idJson);
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

