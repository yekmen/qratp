import QtQuick 1.1
import com.nokia.meego 1.0
import QtWebKit 1.0
import "DataBase.js" as DB
import "JSON"
 import com.nokia.extras 1.1

Page {
    id: page
    property int lineID
    property int directionID
    property int stationID
    property int transportID

    function initUI(){
        choixTransport.addType();
    }
    WorkerScript {
          id: worker
          source: "DataLoader.js"
      }

      Timer {
          id: timer
          interval: 2000; repeat: true
          running: true
          triggeredOnStart: true

          onTriggered: {
              var msg = {'action': 'appendCurrentTime', 'model': listModel};
              worker.sendMessage(msg);
          }
      }
   function initDB(){
        DB.clearTable();
        console.debug("How much found : " + jsonModel.count)
        var length = jsonModel.count;
        for(var i = 0; length; i++)
        {
            if(typeof(jsonModel.model.get(i)) === "undefined")
                break;
            else
            {
                var patt = /^0/;
                var line = jsonModel.model.get(i).line;
                var URLPic;

                switch(jsonModel.model.get(i).type_id){
                case 1:       //Bus
                    if(patt.test(line)){
                        line = line.slice(1);
                        line = line.toLowerCase();
                    }
                    URLPic = "http://wap.ratp.fr/wsiv/static/line/b" + line +".gif"
                    break;
                case 2:       //Metro
                    if(patt.test(line)){
                        line = line.slice(1);
                        line = line.toLowerCase();
                    }
                    URLPic = "http://wap.ratp.fr/wsiv/static/line/m" + line +".gif"
                    break;
                case "3":       //RER
                    if(patt.test(line)){
                        line = line.slice(1);
                        line = line.toLowerCase();
                    }
                    if(line === "a")
                        URLPic = "http://www.ratp.fr/horaires/images/lines/rer/RA.png"
                    else if(line === "b")
                        URLPic = "http://www.ratp.fr/horaires/images/lines/rer/RA.png"
//                    http://www.transilien.com/contents/fr/_Pictos---Logos/Modes-de-transport/RER/C_20x20.gif

                    break;
                case "4":       //RER
                    break;
                case "5":
                    break;
                case "6":
                    break;
                case "7":       //Noctilien
                    break;
                }

                DB.initTable(jsonModel.model.get(i).type_id,
                             jsonModel.model.get(i).type_name,
                             line,
                             jsonModel.model.get(i).id,
                             URLPic)
            }
        }
        initUI();
    }

    function getStationDirection(){
        var idGetted;   //Returned ID by dbb;
        if(jsonModel.count > DB.myID){
            console.debug("------------ START -------------")
            idGetted = DB.getByID(DB.myID)
            console.debug("------------ GET ID -------------")
            jsonModelDirection.source = "http://metro.breizh.im/dev/ratp_api.php?action=getDirectionList&line="+idGetted
            console.debug("------------ SOURCE CHANGED -------------")
        }
        else
            console.debug("------------ FINISHED -------------")
    }

    JSONListModel{
        id: jsonModel
        source: "http://metro.breizh.im/dev/ratp_api.php?action=getLineList"
        query: "lines[*]"
        onLoadingFinished: {
            console.debug("Table Length " + DB.getTableLength())
            if(DB.getTableLength() > 0)
                initUI();
            else
                worker.sendMessage(initDB());
        }

    }
    JSONListModel{
        id: jsonModelDirection
        query: "directions[*]"
        onLoadingFinished: {
            choixDirection.addDirection(jsonModelDirection.model)
            console.debug("------------ FINISHED -------------")
//            http://metro.breizh.im/dev/ratp_api.php?action=getStationList&line=1151&direction=80649
        }
    }
    JSONListModel{
        id: jsonModelStation
        query: "stations[*]"
        onLoadingFinished: {
            choixStation.addStation(jsonModelStation.model)
            console.debug("------------ FINISHED -------------")
        }
    }
    JSONListModel{
        id: jsonModelSchedule
        query: "schedule[*]"
        schedule: true
        onLoadingFinished: {
            afficheData.addSchedule(jsonModelSchedule.model)
            console.debug("------------ FINISHED -------------")
        }
    }
    Choix{
        id: choixTransport
        height: 200
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        typeName: "Choisissez votre mode de transport :"
        z:0
        onSectionClicked: {
            if(choixNumTransport.state === "show")
                choixNumTransport.state = "hide"
        }
        onTypeSelected: {
            console.debug("Type ID = " +_typeID)
            transportID = _typeID;
            switch(_typeID){
            case 1:     //Bus
                choixNumTransport.addtoList(DB.getBus());
                break;
            case 2:     //Metro
                choixNumTransport.addtoList(DB.getMetro());
                break;
            case 3:
                break;
            case 4:     //RER
                break;
            case 5:
                break;
            case 6:     //Tram
                break;
            default:
                console.debug("Inconnu ... : " + _typeID)
                break;
            }
        }

    }

    Choix{
        id: choixNumTransport
        height: 200
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: choixTransport.bottom
        anchors.topMargin: 0
        typeName: "Choisissez votre line: "
        z:-1
        state: "hide"
        onTypeSelected: {
            console.debug("ID : " + _idJSON + " Line : " + _line)
            lineID = _idJSON;
            jsonModelDirection.source = "http://metro.breizh.im/dev/ratp_api.php?action=getDirectionList&line=" + _idJSON
        }
    }

    Choix{
        id: choixDirection
        height: 200
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: choixNumTransport.bottom
        anchors.topMargin: 0
        typeName: "Choisissez votre direction :"
        z:-1
        state: "hide"
        onTypeSelected: {
            console.debug("ID : " + _idJSON + " Line : " + _line)
            directionID = _idJSON;
            jsonModelStation.source = "http://metro.breizh.im/dev/ratp_api.php?action=getStationList&line=" + lineID + "&direction=" + directionID;
        }
    }

    Choix{
        id: choixStation
        height: 200
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: choixDirection.bottom
        anchors.topMargin: 0
        typeName: "Choisissez votre station :"
        z:-1
        state: "hide"
        onTypeSelected: {
            console.debug("ID : " + _idJSON + " Line : " + _line)
            stationID = _idJSON;
            jsonModelSchedule.source = "http://metro.breizh.im/dev/ratp_api.php?action=getSchedule&line=" + lineID + "&direction=" + directionID + "&station=" + stationID;

//            http://metro.breizh.im/dev/ratp_api.php?action=getStationList&line=1151&direction=80649
//            http://metro.breizh.im/dev/ratp_api.php?action=getSchedule&line=1151&direction=80649&station=30783
        }
    }

    Choix{
        id: afficheData
        height: 200
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: choixStation.bottom
        anchors.topMargin: 0
        typeName: "Résultat :"
        z:-1
        state: "hide"
    }
}
