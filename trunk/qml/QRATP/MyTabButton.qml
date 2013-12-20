// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id: item
//    width: 100
    height: 70
    state: "default"
    property variant textBtn
    property bool actualiserEnable: false
    signal tabClicked;
    signal holdClicked;
    width: 100
    Rectangle{
        id: rectMain
        anchors.fill: parent
//        border.color: "gray"
//        border.width: 1
        Label{
            id: labelText
            text: textBtn
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.bold: true
            platformStyle: LabelStyle {
                fontFamily: "Nokia Pure Text Light"
                fontPixelSize: 24
            }
        }
        Label{
            id: actualiser
            height: 20
            visible: actualiserEnable
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            text: "Actualiser"
            anchors.horizontalCenter: parent.horizontalCenter
            verticalAlignment: Text.AlignTop
            platformStyle: LabelStyle {
                fontFamily: "Nokia Pure Text Light"
                fontPixelSize: 15
            }
        }

        MouseArea{
            id: mouse
            anchors.fill: parent
            onClicked: {
                tabClicked()
            }
            onPressAndHold: {
                holdClicked();
            }
        }
    }

    states: [
        State {
            name: "clicked"
            PropertyChanges {
                target:rectMain
                color: "blue"
            }
        },
        State{
            name: "default"
            PropertyChanges {
                target: rectMain
                color: "white"
            }
        },
        State {
            name: "Current"
            when: ListView.isCurrentItem
            PropertyChanges { target: btnText; x: 70 ; actualiserEnable: true}
        }
    ]
    transitions: Transition {
        NumberAnimation { properties: "x"; duration: 200 }
    }
//    states: State {
//        name: "Current"
//        when: ListView.isCurrentItem
//        PropertyChanges { target: btnText; x: 70 ; actualiserEnable: true}
//    }
//    transitions: Transition {
//        NumberAnimation { properties: "x"; duration: 200 }
//    }
}
