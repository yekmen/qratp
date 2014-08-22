import QtQuick 2.0
import Sailfish.Silica 1.0

MouseArea{
    id: mouse
    width: Theme.itemSizeExtraSmall
    height: Theme.itemSizeSmall

    property bool _showPress : false

    signal itemClicked;

    onPressed: _showPress = true;
    onReleased: _showPress = false;
    onClicked: {
        itemClicked()
    }

    function lighter(){
        console.debug("START !")
        mainTimer.start()
        timerGlass.start();
    }
    function stopLigther(){
        mainTimer.stop()
        timerGlass.stop();
    }

    Timer{
        id: mainTimer
        interval: 8000
        repeat: true
        onTriggered: {
            timerGlass.stop()
            glass2.color = Theme.highlightColor;
            glass1.color = Theme.highlightColor;
            glass0.color = Theme.highlightColor;
        }
    }
    Timer{
        id: timerGlass
        repeat: true
        interval: 1000
        property int glassID : -1
        onTriggered: {
            glassID++;

            switch(glassID)
            {
            case 0:
                glass0.color = Theme.primaryColor;
                break;
            case 1:
                glass1.color = Theme.primaryColor;
                break;
            case 2:
                glass2.color = Theme.primaryColor;
                break;
            default:
                glassID = -1;
                glass2.color = Theme.highlightColor;
                glass1.color = Theme.highlightColor;
                glass0.color = Theme.highlightColor;
            }
        }
    }

    Item {
        id: item
        anchors.fill: parent
        Column{
            anchors.fill: parent
            GlassItem{
                id: glass0
                width: 60
                height: 15
                ratio: 0.0
                falloffRadius: _showPress ? 0.23 : 0.14
                color: _showPress ? Theme.primaryColor : Theme.highlightColor
            }
            GlassItem{
                id: glass1
                width: 60
                height: 15
                ratio: 0.0
                falloffRadius: _showPress ? 0.23 : 0.14
                color: _showPress ? Theme.primaryColor : Theme.highlightColor
            }
            GlassItem{
                id: glass2
                width: 60
                height: 15
                ratio: 0.0
                falloffRadius: _showPress ? 0.23 : 0.14
                color: _showPress ? Theme.primaryColor : Theme.highlightColor
            }
        }
    }
}
