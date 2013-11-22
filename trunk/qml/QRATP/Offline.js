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
        tx.executeSql('CREATE TABLE IF NOT EXISTS QRatp(id INTEGER PRIMARY KEY, columnName TEXT,directionID NUMERIC, url TEXT)');
           }
    )
}
function initTable(idType, typeName, line, id, picUrl){
    openDB();
    _db.transaction( function(tx) {
                        tx.executeSql('INSERT INTO QRatp VALUES ((SELECT max(id) FROM QRatp)+ 1,?,?,?,?,?,?)', [typeName,line, idType, id, picUrl, "NULL"]);
        }
    )
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
