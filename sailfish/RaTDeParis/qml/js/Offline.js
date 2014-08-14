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
    _db = Sql.LocalStorage.openDatabaseSync("QRATP_offline","1.0","Offline_QRATP",1000000)
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
        tx.executeSql('CREATE TABLE IF NOT EXISTS QRatp(id INTEGER PRIMARY KEY, columnName TEXT,ligneName TEXT, direction TEXT, sens NUMERIC, url TEXT, urlImage TEXT, station TEXT, parentID NUMERIC)');
           }
    )
}
//-------------- SENS -------- ALLER = 0 ----------- Retour = 1 -----------//
function addItinerary(colName, ligneName, direction, sens, url, urlImage, station, parentID){     //Aller = 0 | Retour = 1
    openDB();
    _db.transaction( function(tx) {
        tx.executeSql('INSERT INTO QRatp VALUES ((SELECT max(id) FROM QRatp)+ 1,?,?,?,?,?,?,?,?)', [colName, ligneName, direction,sens, url, urlImage, station, parentID]);
        }
    )
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

function getItemsByName(sens, id){
    openDB();
    var r = []
    _db.transaction( function(tx) {
            var rs = tx.executeSql('SELECT * FROM QRatp WHERE parentID = "' +id+'" AND sens = "'+sens + '"');
                    for(var i = 0; i < rs.rows.length; i++) {
                            r.push(rs.rows.item(i));
                        }
        }
    )
    console.debug("Get it : " +" sens : " + sens + " size : " + r.length)
    return r;
}

function removeItems(parentID, sens){
    console.debug("Delete : " + parentID + " sens : "+ sens)
    openDB();
    _db.transaction( function(tx) {
    // Create the database if it doesn't already exist
                        tx.executeSql('DELETE FROM QRatp WHERE "parentID" = "'+ parentID+'" AND "sens" = "' + sens + '"');
//                        DELETE FROM QRatp WHERE "columnName" = "toto" AND "sens" = "0"
           }
    )
}
