import QtQuick 1.1
import com.nokia.meego 1.0
import QtWebKit 1.0
import "Offline.js" as OfflineDB


Page {
    id: page
    tools: ToolBarLayout {
        id: toolBarLayout
        ToolIcon { iconId: "toolbar-back"; onClicked: pageStack.pop(); }
               ButtonRow {
                   style: TabButtonStyle { }
                   TabButton { tab: tab_aller; text:"Aller" }
                   TabButton { tab: tab_retour; text:"Retour" }
               }

        ToolIcon {
            platformIconId: "toolbar-refresh"
            onClicked: {
//                list.insert(0,{"direction":m_downData.getdirection(),"bus":m_downData.getimagelink(),"arret":m_downData.getarret(),"heur":m_downData.getstr_heur(), "prochaine1":m_downData.getstr_temps1(),"prochaine2":m_downData.getstr_temps2()})
                list.append({"bus":m_downData.getimagelink(),"arret":m_downData.getarret(),"heur":m_downData.getstr_heur(), "prochaine1":m_downData.getstr_temps1(),"prochaine2":m_downData.getstr_temps2()})

            }
        }

    }
    property string title : "QRATP"
    function addItinAller(ligne, direction, url){
//        OfflineDB.addItinaire(listRowButtonAller.currentItem)
//        console.debug("ALLER = " + ligne + " DIrection = " + direction)
        console.debug("Prt : " + modelRowButtonAller.get(listRowButtonAller.currentIndex).btnText)

    }
    function addItinRetour(ligne, direction, url){
        console.debug("Retour = " + url)
    }
    Timer {
        id: timer
        interval: 6000; running: true; repeat: true
        onTriggered: {
//            loadURL();
        }
    }

    Image {
        id: pageHeader
        anchors {
            top: page.top
            left: page.left
            right: page.right
        }

        height: parent.width < parent.height ? 72 : 46
        width: parent.width
        source: "image://theme/meegotouch-view-header-fixed" + (theme.inverted ? "-inverted" : "")
        z: 1

        Label {
            id: header
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: 16
            }
            platformStyle: LabelStyle {
                fontFamily: "Nokia Pure Text Light"
                fontPixelSize: 32
            }
            text: page.title
        }
    }
    Component{
        id:list_delegate

        Item {
            id: delegateItem
            width: list_aller.width ; height: 50
            clip: true
            Column {

                Rectangle{ width: page.width; height: childrenRect.height;color:"lightsteelblue"
                    Image {
                        source: bus;
                        height: 35; width: 50
                        //                               Text{ id: text_direction;width: page.width; color: "white"; text:direction; horizontalAlignment: Text.AlignRight }
                    }
                }
                Label { color:"black"; text: '<b>Arret:</b> ' + arret}
                Label { color:"black"; text: '<b>Prochain:</b> ' + prochaine1}
                Label { color:"black"; text: '<b>Prochain:</b> ' + prochaine2}
                Label { color:"black"; opacity:0.7 ;horizontalAlignment: Text.AlignRight ; width: page.width; text: '<b>'+heur+'</b> '}
            }

            ListView.onAdd: SequentialAnimation {
                PropertyAction { target: delegateItem; property: "height"; value: 0 }
                NumberAnimation { target: delegateItem; property: "height"; to: 200; duration: 250; easing.type: Easing.InOutQuad }
            }
        }
    }
    ListModel {
        id: list
    }
    TabGroup{
        id: tabGroup
        anchors.top: pageHeader.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.topMargin: 0
        currentTab: tab_aller
        Page{
            id:tab_aller
            anchors.fill: parent
            ListView{
                id: listRowButtonAller
                height: tabAddAller.height
                snapMode: ListView.SnapOneItem
                orientation: ListView.Horizontal
                flickableDirection: Flickable.HorizontalFlick
                anchors.right: tabAddAller.left
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.top: pageHeader.bottom
                anchors.topMargin: 0
                model:modelRowButtonAller
                delegate:TabButton{
        //            anchors.fill: parent
                    text: btnText
                    width: 100
                }
                onCurrentIndexChanged: {
                    console.debug(modelRowButtonAller.get(listRowButtonAller.currentIndex).btnText)
                }
            }
            ListModel{
                id: modelRowButtonAller
            }
            TabButton {
                id: tabAddAller;
                text:"+"; anchors.top: pageHeader.bottom; anchors.topMargin: 0; anchors.right: parent.right; anchors.rightMargin: 0; width: 100
                onClicked: {
                    myDialog.sens = 0;
                    myDialog.open();
                }
            }
            Button{
                id: buttonAddAller
                height: 50
                anchors.right: parent.right
                anchors.rightMargin: 50
                anchors.left: parent.left
                anchors.leftMargin: 50
                anchors.top: listRowButtonAller.bottom
                anchors.topMargin: 0
                text: "Ajouter un itinéraire"
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("AddItineraire.qml"));
                }
            }
        }

        Page{
            id:tab_retour
            anchors.fill: parent
            ListView{
                id: listRowButtonRetour
                height: tabAddRetour.height
                snapMode: ListView.SnapOneItem
                orientation: ListView.Horizontal
                flickableDirection: Flickable.HorizontalFlick
                anchors.right: tabAddRetour.left
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.top: pageHeader.bottom
                anchors.topMargin: 0
                model:modelRowButtonRetour
                delegate:TabButton{
        //            anchors.fill: parent
                    text: btnText
                    width: 100
                }

            }
            ListModel{
                id: modelRowButtonRetour
            }
            TabButton { id: tabAddRetour;
                text:"+"; anchors.top: pageHeader.bottom; anchors.topMargin: 0; anchors.right: parent.right; anchors.rightMargin: 0; width: 100
                onClicked: {
                    myDialog.sens = 1;
                    myDialog.open();
                }
            }
            Button{
                id: buttonAddRetour
                height: 50
                anchors.right: parent.right
                anchors.rightMargin: 50
                anchors.left: parent.left
                anchors.leftMargin: 50
                anchors.top: listRowButtonRetour.bottom
                anchors.topMargin: 0
                text: "Ajouter un itinéraire"
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("AddItineraire.qml"));
                }
            }
        }
    }
    Dialog {
        id: myDialog
        property int sens       //Aller = 0 | Retour = 1;
        title: Column{
            Label{
                id: lblTitle
                text: "Ajouter"
                font.pixelSize: 40
                color: "white"
                opacity: 0.6
            }
        }
        content:Item {
            id: name
            height: 50
            width: parent.width
            TextArea{
                id: textArea
                anchors.centerIn: parent
                placeholderText: "Nom de la colonne"
            }
        }
        buttons: ButtonRow {
            style: ButtonStyle {}
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 10
            Button {text: "Ajouter"; onClicked: myDialog.accept()}
            Button {text: "Annuler"; onClicked: myDialog.reject()}
        }
        onAccepted: {
            if(sens === 0){
                modelRowButtonAller.append({"btnText": textArea.text})
            }
            else{
                modelRowButtonRetour.append({"btnText": textArea.text})
            }
            textArea.text = ""
        }
    }
}
