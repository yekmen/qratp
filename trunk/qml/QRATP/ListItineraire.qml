// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0


Item {
    id: itemListIteneraire
    function clearItem(){
        modelList.clear();
    }

    function addItem(direction, image, urlJSON){
        modelList.append({"imageURL": image, "directionText": direction, "dbURL": urlJSON})

//        modelList.append({"index": i, "type": array[i].type_id, "jsonID": array[i].idJSON, "jsonLINE": array[i].line, "picURL": array[i].picURL});
    }


    ListView{
        anchors.fill: parent
        model: modelList
        delegate: DelegateItineraire{

        }
    }
    ListModel{
        id: modelList
    }
}
