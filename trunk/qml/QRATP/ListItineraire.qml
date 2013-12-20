// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0


Item {
    id: itemListIteneraire
    function clearItem(){
        modelList.clear();
    }

    function addItem(direction, image, urlJSON, station){
        console.debug("Add item " + station)
        modelList.append({"imageURL": image, "station": station, "dbURL": urlJSON})
    }

    ScrollDecorator {
        id: scrolldecorator
        flickableItem: listView
    }
    ListView{
        id: listView
        anchors.fill: parent
        model: modelList
        focus: true
        clip: true
        delegate: DelegateItineraire{

        }
    }
    ListModel{
        id: modelList
    }

}
