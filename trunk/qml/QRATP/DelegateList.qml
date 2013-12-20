// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0


Item {
    id: item1
    width: 400
    height: resize ? 30 : 50
    property bool resize: false
    signal clickedElement(variant _idJSON, int _index, variant _line, int _typeID);

    //idJSON = ID Du transport dans le JSON
    //_index = index dans la Liste
    //_line = Nom de la ligne
    //_typeID = ID donnée par le JSON 1 = bus 2 = metro etc ...


    Image {
        id: image
        width: 50
        anchors.left: parent.left
        anchors.leftMargin: 0
        fillMode: Image.PreserveAspectFit
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        source: picURL
        state: "show"
        states: [
            State {
                name: "show"
                PropertyChanges {
                    target: image
                    anchors.leftMargin: 0

                }
            },
            State {
                name: "hide"
                when: picURL === ""
                PropertyChanges {
                    target: image
                    anchors.leftMargin: -50
                }
            }
        ]
    }
    Label{
        id: labelType
        text: jsonLINE
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.WrapAnywhere
        anchors.left: image.right
        anchors.leftMargin: 0
        anchors.verticalCenter: parent.verticalCenter
        platformStyle: LabelStyle {
            fontFamily: "Nokia Pure Text Light"
            fontPixelSize: resize ? 25 : 30
        }
    }
    MouseArea{
        id: mouse
        anchors.fill: parent
        onClicked: {
            clickedElement(jsonID, index, jsonLINE, type)
        }
    }
}
