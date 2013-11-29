// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Item {
//    width: 100
    height: 70
    state: "default"
    property variant textBtn

    signal tabClicked;
    signal holdClicked;
    Rectangle{
        id: rectMain
        anchors.fill: parent

        Label{
            id: labelText
            text: textBtn
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
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
        }

    ]

}
