import QtQuick 2.0
import Sailfish.Silica 1.0

BackgroundItem {
    id: delegate
    height: 200
    Column{
        Row{
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 60
            Image{
                id: image
                source: urlLine === undefined ? "" : urlLine
                cache: true
                asynchronous: true
                fillMode: Image.PreserveAspectFit
                anchors.verticalCenter: parent.verticalCenter
                height: urlLine === undefined ? 0 : 60
                width: urlLine === undefined ? 0 : 60
            }
            Label {
                id: label
                x: Theme.paddingLarge
                text: line
                anchors.verticalCenter: parent.verticalCenter
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
            }
        }
//        SilicaListView{
//            model: listModel
//        }
    }


}
