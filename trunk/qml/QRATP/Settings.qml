import QtQuick 1.1
import com.nokia.meego 1.0
import "Offline.js" as OfflineDB
import "DataBase.js" as DataBase
Page {
    id: page
    property string title : "Paramètre"
    property int type: -1
    tools: ToolBarLayout {
        id: toolBarLayout
        ToolIcon {
            iconId: "toolbar-back"
            onClicked: {
                pageStack.pop();
            }
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
    GroupSeparator{
        id: groupSave
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: pageHeader.bottom
        anchors.topMargin: 5
        title: "Bases de données"
    }
    Button{
        id: btnBus
        height: 50
        text: "Supprimer la base de donnée"
        anchors.right: parent.right
        anchors.rightMargin: 30
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.top: groupSave.bottom
        anchors.topMargin: 5
        onClicked: {
            type = 0;
            queryDialog.open()
        }
    }
    Button{
        id: btnOffline
        height: 50
        text: "Supprimer les sauvegardes"
        anchors.right: parent.right
        anchors.rightMargin: 30
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.top: btnBus.bottom
        anchors.topMargin: 5
        onClicked: {
            type = 1;
            queryDialog.open()
        }
    }

    QueryDialog{
        id: queryDialog
        titleText: "Supprimer la base de donnée"
        message: "Confirmer ?"
        acceptButtonText: "Oui"
        rejectButtonText: "Non"
        onAccepted: {
            if(type === 0)
                DataBase.clearTable();
            else if(type === 1)
                OfflineDB.clearTable();
        }
        onRejected: close()
    }
}
