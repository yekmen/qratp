// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id: item1
    width: 400
    height: 50

    signal clickedElement(variant _idJSON, int _index, variant _line, int _typeID);
    //idJSON = ID Du transport dans le JSON
    //_index = index dans la Liste
    //_line = Nom de la ligne
    //_typeID = ID donnée par le JSON 1 = bus 2 = metro etc ...

    property int myIndex
    property int idJSON
    property string url
    property string line
    property int typeID

    Image {
        id: image
        width: 50
        fillMode: Image.PreserveAspectFit
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        source: url
    }
    Label{
        id: type
        text: line
        anchors.left: image.right
        anchors.leftMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        platformStyle: LabelStyle {
            fontFamily: "Nokia Pure Text Light"
            fontPixelSize: 32
        }
    }
    MouseArea{
        id: mouse
        anchors.fill: parent
        onClicked: {
            clickedElement(idJSON, myIndex, line, typeID)
        }
    }
}
