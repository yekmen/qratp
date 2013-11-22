// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "JSON"

Item{
    id: item1
    width: 400
    height: 400
    state: "show"
    property string typeName

    signal typeSelected(variant _idJSON, variant _line, variant _typeID)
    signal sectionClicked;

    function addtoList(array) {
        modelList.clear();
        for(var i = 0; i < array.length; i++){
            modelList.append({"index": i, "type": array[i].type_id, "jsonID": array[i].idJSON, "jsonLINE": array[i].line, "picURL": array[i].picURL});
        }
       item1.state = "show"
    }

    function addType(){
        modelList.append({"index": 0, "type": 1,"jsonID": "", "jsonLINE": "Bus", "picURL": "http://www.ratp.fr/horaires/images/networks/bus.png"});
        modelList.append({"index": 1, "type": 2,"jsonID": "", "jsonLINE": "Métro", "picURL": "http://www.ratp.fr/horaires/images/networks/metro.png"});
        modelList.append({"index": 2, "type": 4,"jsonID": "", "jsonLINE": "RER", "picURL": "http://www.ratp.fr/horaires/images/networks/rer.png"});
        modelList.append({"index": 3, "type": 6,"jsonID": "", "jsonLINE": "Tram", "picURL": "http://www.ratp.fr/horaires/images/networks/tramway.png"});
    }
    function addDirection(direction){
        modelList.clear();
        for(var i = 0; i < direction.count; i++){
            modelList.append({"index": i, "type": "", "jsonID": direction.get(i).id, "jsonLINE": direction.get(i).direction, "picURL": ""});
        }
        item1.state = "show"
    }
    function addStation(stations){
        modelList.clear();
        for(var i = 0; i < stations.count; i++){
            modelList.append({"index": i, "type": "", "jsonID": stations.get(i).id, "jsonLINE": stations.get(i).station, "picURL": ""});
        }
        item1.state = "show"
    }
    function addSchedule(schedule){
        modelList.clear();
        for(var i = 0; i < schedule.count; i++){
            modelList.append({"index": i, "type": "", "jsonID": schedule.get(i).id, "jsonLINE": schedule.get(i).direction + ":"+schedule.get(i).time , "picURL": ""});
        }
        item1.state = "show"
    }

    Rectangle {
        id: rectType
        height: 62
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

        Label{
            id: type
            color: "#ffffff"
            text: typeName
            smooth: true
            platformStyle: LabelStyle {
                fontFamily: "Nokia Pure Text Light"
                fontPixelSize: 25
            }
        }
        MouseArea{
            id: mouse
            anchors.fill: parent
            onClicked: {
                sectionClicked();
                if(item1.state === "hide" || item1.state === "selected"){
                    item1.state = "show"
                }
                else if(item1.state === "show"){
                    selectedItem.state = "hide"
                }
//                else
//                    item1.state = "hide"
            }
        }
    }
    ListView{
        id: list
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: rectType.bottom
        anchors.topMargin: 0
        z:-1
        model: modelList
        delegate:  DelegateList{
            id: myDelegate
            onClickedElement: {
                console.debug("Clicked : "+ _idJSON)
                item1.state = "selected"
                typeSelected(_idJSON, _line, _typeID);
                selectedItem.url = modelList.get(_index).picURL
                selectedItem.line = modelList.get(_index).jsonLINE
                selectedItem.state = "show"
            }
        }
    }
    ListModel{
        id: modelList
    }

    states: [
        State {
            name: "show"
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

