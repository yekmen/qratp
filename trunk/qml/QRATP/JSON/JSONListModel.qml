/* JSONListModel - a QML ListModel with JSON and JSONPath support
 *
 * Copyright (c) 2012 Romain Pokrzywka (KDAB) (romain@kdab.com)
 * Licensed under the MIT licence (http://opensource.org/licenses/mit-license.php)
 */

import QtQuick 1.1
import "jsonpath.js" as JSONPath

Item {
    property string source: ""
    property string json: ""
    property string query: ""
    property ListModel model : ListModel { id: jsonModel }
    property alias count: jsonModel.count
    property bool finished: false
    property bool schedule: false
    signal loadingFinished();
    onSourceChanged: {
        console.debug("Source changed : " + source)
        finished = false
        var xhr = new XMLHttpRequest;
        xhr.open("GET", source);
        xhr.onreadystatechange = function() {
            if (xhr.readyState == XMLHttpRequest.DONE)
                json = xhr.responseText;
        }
        xhr.send();
    }

    onJsonChanged: updateJSONModel()
    onQueryChanged: updateJSONModel()

    function updateJSONModel() {
        jsonModel.clear();
        finished = false
        if ( json === "" )
            return;

        var objectArray = parseJSONString(json, query);

        for ( var key in objectArray ) {
            var jo = objectArray[key];
            if(schedule){
                var str = '';
                for (var p in jo) {
                    if (jo.hasOwnProperty(p)) {
                        jsonModel.append({"direction": p, "time": jo[p]});
                    }
                }
            }
            else
                jsonModel.append(jo)
        }
        finished = true;
        loadingFinished();
    }

    function parseJSONString(jsonString, jsonPathQuery) {
        var objectArray = JSON.parse(jsonString);
//        console.debug("JSON ! " +jsonString)
        if ( jsonPathQuery !== "" )
            objectArray = JSONPath.jsonPath(objectArray, jsonPathQuery);

        return objectArray;
    }
}
