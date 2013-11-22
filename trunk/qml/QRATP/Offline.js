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
        tx.executeSql('CREATE TABLE IF NOT EXISTS QRatp(id INTEGER PRIMARY KEY, columnName TEXT,ligneName TEXT, direction TEXT, sens NUMERIC, url TEXT)');
           }
    )
}
function addItinaire(colName, ligneName, direction, sens, url){
    openDB();
    _db.transaction( function(tx) {
        tx.executeSql('INSERT INTO QRatp VALUES ((SELECT max(id) FROM QRatp)+ 1,?,?,?,?,?)', [colName, ligneName, direction,sens, url]);
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
