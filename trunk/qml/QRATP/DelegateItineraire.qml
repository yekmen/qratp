// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "JSON"

Item {
    id: delegateItineraire
//    width: 400
//    height: 200
    width: parent.width
    height: 200
    function addSchedule(schedule){
        modelList.clear();
        for(var i = 0; i < schedule.count; i++){
            modelList.append({"index": i, "type": "", "jsonID": schedule.get(i).id, "jsonLINE": schedule.get(i).direction + ":"+schedule.get(i).time , "picURL": ""});
        }
    }
    function loading(){
        busy.running = true;
        busy.visible = true;
        directionLable.opacity = 0.5;
        imageLigne.opacity = 0.5;
    }
    function finish(){
        busy.running = false;
        busy.visible = false;

        directionLable.opacity = 1;
        imageLigne.opacity = 1;
    }

    JSONListModel{
        id: jsonModelSchedule
        source: dbURL
        query: "schedule[*]"
        schedule: true
        onLoadingFinished: {
            addSchedule(jsonModelSchedule.model)
            console.debug("------------ FINISHED -------------")
            finish();
        }
    }
    Rectangle{
        id: topRect
        height: 40
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0

        Image{
            id: imageLigne
            width: parent.height + 15
            fillMode: Image.PreserveAspectFit
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            source: imageURL
            BusyIndicator{
                id: busy
                Component.onCompleted: {
                    loading();
                }
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        Label{
            id: directionLable
            anchors.left: imageLigne.right
            anchors.leftMargin: 5
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            text: station
            verticalAlignment: Text.AlignVCenter
            font.bold: true
            platformStyle: LabelStyle {
                fontFamily: "Nokia Pure Text Light"
                fontPixelSize: 22

            }
        }
    }
    ListView{
        id: list
        interactive: false
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: topRect.bottom
        anchors.topMargin: 0
        z:-1
        model: modelList
        delegate:  DelegateList{
            id: myDelegate
            resize: true
        }
    }
    ListModel{
        id: modelList
    }
}

