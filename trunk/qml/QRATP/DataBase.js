var _db;
var qml_i = 0;
var myID = 2;
function openDB() {
    _db = openDatabaseSync("QRATP","1.0","Base de donne sauvegarde",1000000)
    createTable();
}

function clearTable(){
    openDB();
    _db.transaction( function(tx) {
    // Create the database if it doesn't already exist
        tx.executeSql('DROP TABLE IF EXISTS Bus');
           }
    )
}
 WorkerScript.onMessage = function initDB(){
     clearTable();
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

             initTable(jsonModel.model.get(i).type_id,
                          jsonModel.model.get(i).type_name,
                          line,
                          jsonModel.model.get(i).id,
                          URLPic)
         }
     }
     initUI();
 }
function createTable(){
    _db.transaction( function(tx) {
    // Create the database if it doesn't already exist
        tx.executeSql('CREATE TABLE IF NOT EXISTS Bus(id INTEGER PRIMARY KEY, typeName TEXT,line TEXT, typeID NUMERIC, idJSON NUMERIC,picURL TEXT, directionID NUMERIC)');
           }
    )
}
function initTable(idType, typeName, line, id, picUrl){
    openDB();
    _db.transaction( function(tx) {
                        tx.executeSql('INSERT INTO Bus VALUES ((SELECT max(id) FROM Bus)+ 1,?,?,?,?,?,?)', [typeName,line, idType, id, picUrl, "NULL"]);
        }
    )
}
function getTableLength(){
    openDB();
    var r = ""
    _db.transaction( function(tx) {
            var rs = tx.executeSql('SELECT idJSON FROM Bus');
            r = rs.rows.length;
        }
    )
    return r;
}

function addDirection(){
    openDB();
    _db.transaction( function(tx) {
        tx.executeSql('INSERT INTO Bus VALUES ((SELECT max(id) FROM Bus)+ 1,?,?,?,?)', [typeName,line, idType,directionID]);
        }
    )
}
function getByID(id){
    openDB();
    var r = ""
    _db.transaction( function(tx) {
        var rs = tx.executeSql('SELECT * FROM Bus WHERE idJSON ='+id);
            r = rs.rows.length;
        }
    )
    return r;
}

function getTypeID(){
    openDB();
    var r = {};
    _db.transaction( function(tx) {
        var rs = tx.executeSql('SELECT typeID FROM Bus');
        for(var i = 0; i < rs.rows.length; i++) {
            r = rs.rows.item(i).typeID
            }
        }
    )
    return r;
}
function getTypeName(){
    openDB();
    var r = "";
    _db.transaction( function(tx) {
        var rs = tx.executeSql('SELECT typeName FROM Bus');
        for(var i = 0; i < rs.rows.length; i++) {
            r = rs.rows.item(i).typeName
            }
        }
    )
    return r;
}

function getBus(){
    openDB();
    var r_sens = [];

    _db.transaction( function(tx) {
        var rs_sens = tx.executeSql('SELECT * FROM Bus WHERE typeID = ' + 1);
        for(var i = 0; i < rs_sens.rows.length; i++) {
            r_sens.push(rs_sens.rows.item(i));
            }
        }
    )
    return r_sens;
}
function getMetro(){
    openDB();
    var r_sens = [];

    _db.transaction( function(tx) {
        var rs_sens = tx.executeSql('SELECT * FROM Bus WHERE typeID = ' + 2);
        for(var i = 0; i < rs_sens.rows.length; i++) {
            r_sens.push(rs_sens.rows.item(i));
            }
        }
    )
    return r_sens;
}
function getTram(){
    openDB();
    var r_sens = [];

    _db.transaction( function(tx) {
        var rs_sens = tx.executeSql('SELECT * FROM Bus WHERE typeID = ' + 6);
        for(var i = 0; i < rs_sens.rows.length; i++) {
            r_sens.push(rs_sens.rows.item(i));
            }
        }
    )
    return r_sens;
}
function getRER(){
    openDB();
    var r_sens = [];

    _db.transaction( function(tx) {
        var rs_sens = tx.executeSql('SELECT * FROM Bus WHERE typeID = ' + 4);
        for(var i = 0; i < rs_sens.rows.length; i++) {

            if(rs_sens.rows.item(i).idJSON === "356")
                continue;
            else if(rs_sens.rows.item(i).idJSON ==="357")
                continue;
            else if(rs_sens.rows.item(i).idJSON ==="374")
                continue;
            else
                r_sens.push(rs_sens.rows.item(i));

        }
                    }
    )
    return r_sens;
}

function getDirectionByLine(lineID){
    openDB();
    var r_sens = ""
    _db.transaction( function(tx) {
        var rs_sens = tx.executeSql('SELECT * FROM Bus WHERE idJSON = ' + lineID);
        for(var i = 0; i < rs_sens.rows.length; i++) {
            r_sens += rs_sens.rows.item(i).sens
            }
        }
    )
    return r_sens;
}

function add(url,sens){
    openDB();
    _db.transaction( function(tx) {
        tx.executeSql('INSERT INTO Bus VALUES ((SELECT max(id) FROM Bus)+ 1,?,?)', [url,sens]);
        }
    )
}

function get_sens(){
    openDB();
    var r_sens = ""
    _db.transaction( function(tx) {
        var rs_sens = tx.executeSql('SELECT sens FROM Bus');
        for(var i = 0; i < rs_sens.rows.length; i++) {
            r_sens += rs_sens.rows.item(i).sens
            }
        }
    )
    return r_sens;
}
function get_url_length(sens){
    openDB();
    var r = ""
    _db.transaction( function(tx) {
        var rs = tx.executeSql('SELECT url FROM Bus WHERE sens ='+sens);
            r = rs.rows.length;
        }
    )
    return r - 1;
}
function get_url_value(sens){
    openDB();
    var r = ""
    _db.transaction( function(tx) {
        var rs = tx.executeSql('SELECT url FROM Bus WHERE sens ='+sens);
        for(var i = 0; i < rs.rows.length; i++) {
            r = rs.rows.item(i).url+"\n"
            }
        }
    )
    return r;
}
function get_id(){
    openDB();
    var r = {};
    _db.transaction( function(tx) {
        var rs = tx.executeSql('SELECT id FROM Bus');
        for(var i = 0; i < rs.rows.length; i++) {
            r = rs.rows.item(i).id
            }
        }
    )
    return r - 1;
}
function show(){
    openDB();
    _db.transaction( function(tx) {
        var r = ""
        var rs = tx.executeSql('SELECT * FROM Bus');
        for(var i = 0; i < rs.rows.length; i++) {
            r += rs.rows.item(i).typeName + " , " + rs.rows.item(i).line + ", " +rs.rows.item(i).directionID + "\n"
            }
            console.log("Dans la base de donnee : " + r)
        }
    )

}
function start_loading(){
    load_url_finish(qml_i)
}

function load_url_finish(i){                                //Quand le webview a fini le chargement
    openDB();
    console.debug(get_url_length(1) + " ; " + i);

    do{
        load_url(i);                                            //Set l'url dans le webview
    }
    while(get_url_length(1) < i);
}

function getUrl_byID(next){                                        //Recupera l'url de la DB
    openDB();
    console.debug("[DataBase] GetURL_byID: Chargement du " + next  + " elements")
    var r = "";
    _db.transaction(
        function(tx)
        {
            var rs = tx.executeSql('SELECT url FROM Bus WHERE sens = 1');
            r = rs.rows.item(next).url
        }
    )
    return r;
}
function load_aller(i){     //Fait l'insertion dans le tableau
    console.debug("Dans le load aller" + " " + i)
    openDB();
    _db.transaction( function(tx) {
        var rs = tx.executeSql('SELECT id FROM Bus WHERE sens = 1');
            list.insert(i,{"bus":m_downData.getimagelink(),"arret":m_downData.getarret(),"heur":m_downData.getstr_heur(), "prochaine1":m_downData.getstr_temps1(),"prochaine2":m_downData.getstr_temps2(),"direction":m_downData.getdirection()})
        }
    )

}
