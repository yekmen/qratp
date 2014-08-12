var _db;
function openDB() {
    _db = openDatabaseSync("QRATP_offline","1.0","Offline_QRATP",1000000)
    createTable();
}

function clearTable(){
    openDB();
    _db.transaction( function(tx) {
        tx.executeSql('DROP TABLE IF EXISTS QRatp');
           }
    )
}
function createTable(){
    _db.transaction( function(tx) {
    // Create the database if it doesn't already exist
        tx.executeSql('CREATE TABLE IF NOT EXISTS QRatp(id INTEGER PRIMARY KEY, columnName TEXT,ligneName TEXT, direction TEXT, sens NUMERIC, url TEXT, urlImage TEXT, station TEXT, parent INTEGER)');
           }
    )
}
function addItinaire(colName, ligneName, direction, sens, url, urlImage, station, parent){     //Aller = 0 | Retour = 1
    openDB();
    _db.transaction( function(tx) {
        tx.executeSql('INSERT INTO QRatp VALUES ((SELECT max(id) FROM QRatp)+ 1,?,?,?,?,?,?,?,?)', [colName, ligneName, direction,sens, url, urlImage, station, parent]);
        }
    )
}

//-------------- SENS -------- ALLER = 0 ----------- Retour = 1 -----------//

function getItemByTabName(tabName){
    openDB();
    var r_sens = [];
    _db.transaction( function(tx) {
        var rs_sens = tx.executeSql('SELECT * FROM QRatp WHERE columnName = ' + tabName);
        for(var i = 0; i < rs_sens.rows.length; i++) {
            r_sens.push(rs_sens.rows.item(i));
            }
        }
    )
    return r_sens;
}
function getAllItems(){
    openDB();
    var r_sens = [];
    var retArray = []
    _db.transaction( function(tx) {
        var rs_sens = tx.executeSql('SELECT * FROM QRatp');
        for(var i = 0; i < rs_sens.rows.length; i++) {
            var currentItem = rs_sens.rows.item(i);
            r_sens.push(rs_sens.rows.item(i));
        }
        }
    )
    return r_sens;
}

function getItemsByName(columnName, sens){
    openDB();
    var r = []
    _db.transaction( function(tx) {
            var rs = tx.executeSql('SELECT * FROM QRatp WHERE columnName = "' +columnName+'" AND sens = "'+sens + '"');
                    for(var i = 0; i < rs.rows.length; i++) {
                            r.push(rs.rows.item(i));
                        }
        }
    )
    return r;
}

function removeItems(tabName, sens){
    console.debug("Delete : " + tabName + " sens : "+ sens)
    openDB();
    _db.transaction( function(tx) {
    // Create the database if it doesn't already exist
                        tx.executeSql('DELETE FROM QRatp WHERE "columnName" = "'+ tabName+'" AND "sens" = "' + sens + '"');
//                        DELETE FROM QRatp WHERE "columnName" = "toto" AND "sens" = "0"
           }
    )
}
