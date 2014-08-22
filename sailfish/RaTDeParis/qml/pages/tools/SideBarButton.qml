import QtQuick 2.0
import Sailfish.Silica 1.0

MouseArea{
    id: mouse
    width: Theme.itemSizeExtraSmall
    height: Theme.itemSizeSmall

    property bool _showPress

    signal itemClicked;

    onPressed: _showPress = true;
    onReleased: _showPress = false;
    onClicked: {
        itemClicked()
    }

    Item {
        id: item
        anchors.fill: parent
        Column{
            anchors.fill: parent
            GlassItem{
                width: 60
                height: 15
                ratio: 0.0
                falloffRadius: 0.14
                color: _showPress ? Theme.highlightColor : Theme.primaryColor
            }
            GlassItem{
                width: 60
                height: 15
                ratio: 0.0
                falloffRadius: 0.14
                color: _showPress ? Theme.highlightColor : Theme.primaryColor
            }
            GlassItem{
                width: 60
                height: 15
                ratio: 0.0
                color: _showPress ? Theme.highlightColor : Theme.primaryColor
            }
        }
    }
}
