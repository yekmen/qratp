// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 2.0
import Sailfish.Silica 1.0

Item{
    id: item1
//    width: 400
//    height: 400
//    state: "show"
    property alias modelList: list.model
    property alias titleName: rectTitle.text
    property alias titleIco: rectImage.source
    function addType(){
        modelList.append({"index": 0,"line": "Bus", "urlType": "http://www.ratp.fr/horaires/images/networks/bus.png"});
        modelList.append({"index": 1,"line": "Métro", "urlType": "http://www.ratp.fr/horaires/images/networks/metro.png"});
        modelList.append({"index": 2,"line": "RER", "urlType": "http://www.ratp.fr/horaires/images/networks/rer.png"});
        modelList.append({"index": 3,"line": "Tram", "urlType": "http://www.ratp.fr/horaires/images/networks/tramway.png"});
    }
    Rectangle{
        id: mainRect
        color: "transparent"
        anchors.fill: parent
        border.color: "red"
        Column{
            anchors.fill: parent
            Row{
                id: topRow
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 50
                Image {
                    id: rectImage
                    fillMode: Image.PreserveAspectFit
                }
                Label{
                    id: rectTitle

                }
            }
            Rectangle{
                id: rectList
                color: "transparent"
                anchors.top: topRow.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                border.color: "yellow"
                SilicaListView{
                    id:list
                    anchors.fill: parent
                    onModelChanged: console.debug("Model changed !" + count);
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
                }
            }
        }


    }
/*
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
*/
}
