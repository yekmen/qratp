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
        tx.executeSql('CREATE TABLE IF NOT EXISTS QRatp(id INTEGER PRIMARY KEY, columnName TEXT,ligneName TEXT, direction TEXT, sens NUMERIC, url TEXT, urlImage TEXT, station TEXT)');
           }
    )
}
function addItinaire(colName, ligneName, direction, sens, url, urlImage, station){     //Aller = 0 | Retour = 1
    openDB();
    _db.transaction( function(tx) {
        tx.executeSql('INSERT INTO QRatp VALUES ((SELECT max(id) FROM QRatp)+ 1,?,?,?,?,?,?,?)', [colName, ligneName, direction,sens, url, urlImage, station]);
        }
    )
}

//-------------- SENS -------- ALLER = 0 ----------- Retour = 1 -----------//
function getAllAllerItem(){     //Franglais ;D
    openDB();
    var r_sens = [];

    _db.transaction( function(tx) {
        var rs_sens = tx.executeSql('SELECT * FROM QRatp WHERE sens = ' + 0);
        for(var i = 0; i < rs_sens.rows.length; i++) {
            r_sens.push(rs_sens.rows.item(i));
            }
        }
    )
    return r_sens;
}
function getAllRetourItem(){
    openDB();
    var r_sens = [];

    _db.transaction( function(tx) {
        var rs_sens = tx.executeSql('SELECT * FROM QRatp WHERE sens = ' + 1);
        for(var i = 0; i < rs_sens.rows.length; i++) {
            r_sens.push(rs_sens.rows.item(i));
            }
        }
    )
    return r_sens;
}
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
    _db.transaction( function(tx) {
        var rs_sens = tx.executeSql('SELECT * FROM QRatp');
        for(var i = 0; i < rs_sens.rows.length; i++) {
            r_sens.push(rs_sens.rows.item(i));
            }
        }
    )
    return r_sens;
}

function getTableLength(){
    openDB();
    var r = ""
    _db.transaction( function(tx) {
            var rs = tx.executeSql('SELECT id FROM QRatp');
            r = rs.rows.length;
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
