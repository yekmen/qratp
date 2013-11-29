import QtQuick 1.1
import com.nokia.meego 1.0
import QtWebKit 1.0
import "Offline.js" as OfflineDB


Page {
    id: page
    tools: ToolBarLayout {
        id: toolBarLayout
        ButtonRow {
            style: TabButtonStyle { }
            TabButton {
                tab: tab_aller; text:"Aller"
                onClicked: {
                    currentSens = 0
                    //                           currentTabName = ""
                    //                           listRetourIteneraire.clearItem();
                    //                           listAllerIteneraire.clearItem();
                }
            }
            TabButton {
                tab: tab_retour;
                text:"Retour";
                onClicked: {
                    currentSens = 1
                    //                           currentTabName = ""
                    //                           listAllerIteneraire.clearItem();
                    //                           listRetourIteneraire.clearItem();
                }
            }
        }
    }
    property string title : "QRATP"
    property string currentTabNameAller
    property string currentTabNameRetour
    property int currentSens: 0
    Component.onCompleted: {
        //Load tab
        autoLoadTab(OfflineDB.getAllItems());
    }
    function autoLoadTab(array) {
        modelRowButtonRetour.clear();
        modelRowButtonAller.clear();
        for(var i = 0; i < array.length; i++){
            if(array[i].sens === '0'){ //Aller
                modelRowButtonAller.append({"btnText": array[i].columnName})
            }
            else if(array[i].sens === '1'){
                modelRowButtonRetour.append({"btnText": array[i].columnName})
            }
        }
    }
    function addItinAller(ligne, direction, url, urlImage){
        listAllerIteneraire.addItem(direction, urlImage, url)
        OfflineDB.addItinaire(currentTabNameAller, ligne, direction, 0, url, urlImage)
    }
    function addItinRetour(ligne, direction, url, urlImage){
        listRetourIteneraire.addItem(direction, urlImage, url)
        OfflineDB.addItinaire(currentTabNameRetour, ligne, direction, 1, url, urlImage)
    }
    function loadItineraire(tabName, array){
        for(var i = 0; i < array.length; i++){
            if(array[i].columnName === tabName)
            {
                if(array[i].sens === '0'){ //Aller
                    listAllerIteneraire.addItem(array[i].direction, array[i].urlImage, array[i].url)
                }
                else if(array[i].sens === '1'){
                    listRetourIteneraire.addItem(array[i].direction, array[i].urlImage, array[i].url)
                }
                else
                    console.debug("Sens inconnu")
            }
        }
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
                z:10
                model:modelRowButtonAller
                delegate:MyTabButton{
                    textBtn: btnText
                    width: 100
                    onTabClicked: {
                        listAllerIteneraire.clearItem();
//                        currentTabName = btnText;
                        currentTabNameAller = btnText;
                        buttonAddAller.text = "Ajouter un itinéraire dans : \n" + currentTabNameAller
                        loadItineraire(btnText, OfflineDB.getAllItems());
                    }
                    onHoldClicked: {
                        currentTabNameAller = btnText;
                        queryDialog.open()
                    }
                }
            }
            ListModel{
                id: modelRowButtonAller
            }
            TabButton {
                id: tabAddAller;
                text:"+";
                anchors.top: pageHeader.bottom; anchors.topMargin: 0; anchors.right: parent.right; anchors.rightMargin: 0; width: 100
                onClicked: {
                    myDialog.sens = 0;
                    myDialog.open();
                }
            }
            Button{
                id: buttonAddAller
                height: 70
                anchors.right: parent.right
                anchors.rightMargin: 50
                anchors.left: parent.left
                anchors.leftMargin: 50
                anchors.top: listRowButtonAller.bottom
                anchors.topMargin: 0
                text: "Ajouter un itinéraire"
                state: "hide"
                z:10
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("AddItineraire.qml"), {
                        sens: 0
                    });
                }
                states: [
                    State {
                        name: "show"
                        when: modelRowButtonAller.count > 0 && currentTabNameAller !== ""
                        PropertyChanges {
                            target: buttonAddAller
                            visible: true
                        }
                    },
                    State {
                        name: "hide"
                        when: currentTabNameAller === ""
                        PropertyChanges {
                            target: buttonAddAller
                            visible: false
                        }
                    }
                ]
            }
            ListItineraire{
                id: listAllerIteneraire
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: buttonAddAller.bottom
                anchors.topMargin: 0
                z:0
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
                delegate:MyTabButton{
                    textBtn: btnText
                    width: 100
                    onTabClicked: {
                        listRetourIteneraire.clearItem();
//                        currentTabName = btnText;
                        currentTabNameRetour = btnText;
                        buttonAddRetour.text = "Ajouter un itinéraire dans : \n" + currentTabNameRetour
                        loadItineraire(btnText, OfflineDB.getAllItems());
                    }
                    onHoldClicked: {
                        currentTabNameRetour = btnText;
                        queryDialog.open()
                    }
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
                height: 70
                anchors.right: parent.right
                anchors.rightMargin: 50
                anchors.left: parent.left
                anchors.leftMargin: 50
                anchors.top: listRowButtonRetour.bottom
                anchors.topMargin: 0
                text: "Ajouter un itinéraire"
                state: "hide"
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("AddItineraire.qml"), {
                        sens: 1
                    });
                }
                states: [
                    State {
                        name: "show"
                        when: modelRowButtonRetour.count > 0 && currentTabNameRetour !== ""
                        PropertyChanges {
                            target: buttonAddRetour
                            visible: true
                        }
                    },
                    State {
                        name: "hide"
                        when: currentTabNameRetour === ""
                        PropertyChanges {
                            target: buttonAddRetour
                            visible: false
                        }
                    }
                ]
            }
            ListItineraire{
                id: listRetourIteneraire
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: buttonAddRetour.bottom
                anchors.topMargin: 0
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
                listAllerIteneraire.clearItem();
                modelRowButtonAller.append({"btnText": textArea.text})
                currentTabNameAller = textArea.text;
                buttonAddAller.text = "Ajouter un itinéraire dans : \n" + currentTabNameAller
            }
            else if(sens === 1){
                listRetourIteneraire.clearItem();
                modelRowButtonRetour.append({"btnText": textArea.text})
                currentTabNameRetour = textArea.text;
                buttonAddRetour.text = "Ajouter un itinéraire dans : \n" + currentTabNameRetour
            }
            textArea.text = ""

        }
    }
    QueryDialog{
        id: queryDialog
        titleText: "Supprimer"
        message: "Supprimer la colonne ?"
        acceptButtonText: "Oui"
        rejectButtonText: "Non"
        onAccepted: {
            if(currentSens === 0)
            {
                modelRowButtonAller.remove(listRowButtonAller.currentIndex)
                listAllerIteneraire.clearItem();
                buttonAddAller.state = "hide"
                OfflineDB.removeItems(currentTabNameAller, currentSens);
            }
            else if(currentSens === 1)
            {
                modelRowButtonRetour.remove(listRowButtonRetour.currentIndex)
                listRetourIteneraire.clearItem();
                buttonAddRetour.state = "hide"
                OfflineDB.removeItems(currentTabNameRetour, currentSens);
            }

        }
        onRejected: close()
    }
}
