var _db;
function openDB() {
    _db = openDatabaseSync("QRATP_tab","1.0","Offline_QRATP",1000000)
    createTable();
}

function clearTable(){
    openDB();
    _db.transaction( function(tx) {
        tx.executeSql('DROP TABLE IF EXISTS QRatp_tab');
           }
    )
}
function createTable(){
    _db.transaction( function(tx) {
    // Create the database if it doesn't already exist
        tx.executeSql('CREATE TABLE IF NOT EXISTS QRatp_tab(id INTEGER PRIMARY KEY, columnName TEXT, sens INTEGER)');
           }
    )
}
function addItinerary(colName, sens){     //Aller = 0 | Retour = 1
    openDB();
    _db.transaction( function(tx) {
        tx.executeSql('INSERT INTO QRatp_tab VALUES ((SELECT max(id) FROM QRatp)+ 1,?,?)', [colName,sens]);
        }
    )
}
function getAllItems(){
    openDB();
    var r_sens = [];

    _db.transaction( function(tx) {
        var rs_sens = tx.executeSql('SELECT * FROM QRatp_tab');
        for(var i = 0; i < rs_sens.rows.length; i++) {
            r_sens.push(rs_sens.rows.item(i));
            }
        }
    )
    return r_sens;
}
function removeItems(tabName, sens){
    console.debug("Delete : " + tabName + " sens : "+ sens)
    openDB();
    _db.transaction( function(tx) {
            tx.executeSql('DELETE FROM QRATP_tab WHERE "columnName" = "'+ tabName+'" AND "sens" = "' + sens + '"');
           }
    )
}
