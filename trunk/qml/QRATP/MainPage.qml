import QtQuick 1.1
import com.nokia.meego 1.0
import QtWebKit 1.0
import "DataBase.js" as DB


Page {
    id: page
//    onVisibleChanged: list.insert(0,{"bus":m_downData.getimagelink(),"arret":m_downData.getarret(),"heur":m_downData.getstr_heur(), "prochaine1":m_downData.getstr_temps1(),"prochaine2":m_downData.getstr_temps2()})
//    onVisibleChanged: timer.start();
    onVisibleChanged: loadURL();

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
                id:list_aller
                anchors.topMargin: 0
                anchors.fill: parent
                delegate: list_delegate
                focus: true

                model: list
            }

        }

        Page{
            id:tab_retour
            anchors.fill: parent
            //                Text{
            //                    text: "Retour"
            //                    anchors.horizontalCenter: parent.horizontalCenter
            //                    anchors.verticalCenter: parent.verticalCenter
            //                    color : "white"
            //                }
            Column{
                //spacing: repeater.model
                spacing: 100
                Repeater {
                    id: repeater_retour
                    model: 10
                    Rectangle {
                        width: page.width; height: 2; color: "white"

                    }

                }
            }
        }
    }
    WebView {
        id: web_view
        enabled: true
        visible: false
        onLoadFinished: {
            traitementData(web_view.html.toString());
        }
        onLoadStarted: console.debug("[WebView]Start : " + url)
        onUrlChanged: {
            console.debug("[WebView]URL Changed : " + url)
        }
    }
    Connections{
        target: m_downData
        onDataTraiter:{
            console.debug("[MainPage] Signal DataTraiter recu")
            insertData();
        }
    }
    function loadURL(){     //Webview charge la page en HTMl
        console.debug("-------------------------------------------------");
        console.debug("[MainPage]LoadURL: Il y a: "+DB.get_url_length(1)+" elements dans la DB"+"| Qml_i = " + DB.qml_i);

        if(DB.qml_i <= DB.get_url_length(1))
        {
            web_view.url = DB.getUrl_byID(DB.qml_i);     //Recupere les URL de la base de données
            console.debug("[MainPage]LoadURL: chargement URL "+web_view.url+"|Numero: " + DB.qml_i);
        }
        else
        {
            console.debug("[MainPage]LoadURL: Arret ou reafectation des variables qml_i et url_length");
            DB.qml_i = 0;
        }


    }
    function traitementData(data){ //Envoi de la page HTML vers le CPP pour slipter les données
//        console.debug("[MainPage]TraitementData: envoi de la page HTML")
        m_downData.heur_direction(data);
    }

    function insertData(){      //Insertion des ellements dans la listView
        console.debug("[MainPage]Insertion element au "+ DB.qml_i)
//        list.insert(0,{"bus":m_downData.getimagelink(),"arret":m_downData.getarret(),"heur":m_downData.getstr_heur(), "prochaine1":m_downData.getstr_temps1(),"prochaine2":m_downData.getstr_temps2()})
        list.append({"bus":m_downData.getimagelink(),"arret":m_downData.getarret(),"heur":m_downData.getstr_heur(), "prochaine1":m_downData.getstr_temps1(),"prochaine2":m_downData.getstr_temps2()})
        DB.qml_i ++;
        timer.start();
       loadURL();
    }
}
