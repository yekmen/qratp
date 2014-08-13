/*
    Le RATdeParis
    Copyright (C) 2014  EKMEN Yavuz <yekmen@gmail.com>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
.import QtQuick.LocalStorage 2.0 as Sql
var _db;
function openDB() {
    _db = Sql.LocalStorage.openDatabaseSync("QRatp_tab","1.0","Offline_QRATP",1000000)
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
        tx.executeSql('INSERT INTO QRatp_tab VALUES ((SELECT max(id) FROM QRatp_tab)+ 1,?,?)', [colName,sens]);
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
