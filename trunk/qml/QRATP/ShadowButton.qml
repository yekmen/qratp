// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

ShadowRectangle{
    id: shadowRect
    width: 100
    height: 70
    signal btnClicked;
    property alias text: label.text
    property alias color: shadowRect.color

    Text{
        id: label
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.fill: parent
        color: "white"
        font.pixelSize: 20
    }

    MouseArea{
        id: mouseAddTabAller
        anchors.fill: parent
        onClicked: {
            btnClicked();
        }
    }
}
