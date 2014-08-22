/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.RaTDeParis.DataRequest 1.0

CoverBackground {
    id: cover
    property string prt

    property string urlType
    property string urlLine
    property string stationName
    property ListModel listModel
    property int _modelIndex: -1

//    onListModelChanged: fitCover()
    function fitCover(){
        console.debug("Index : " + _modelIndex)
        if(listModel.count > 0 && listModel.count > _modelIndex){
            var url = listModel.get(_modelIndex).jsonURL;
            urlType = listModel.get(_modelIndex).urlType;
            urlLine = listModel.get(_modelIndex).urlImage;
            stationName = listModel.get(_modelIndex).stationName;

            console.debug("URL ! " + url + " " + urlLine +" " + urlType + " " + stationName)
            dataRequestCover.getSchedule(url);
        }
    }
    function fillModel(modelList){
        coverList.clear();
        for(var i = 0; i < modelList.length; i++)
        {
            coverList.append(modelList[i]);
        }
    }

    function fitWord(value){
        var ret;    //Returned value

        var station = fitStation(value)
        var time = fitTime(value)

        ret = station +" : "+time;
        return ret;
    }
    function fitStation(value){
        var ret;
        var dpPos = value.substring(0, value.indexOf(":", 0));

        console.debug("ap  " + dpPos.length );
//        if(value.length > 16)
        if(dpPos.length > 10)
        {
            ret = dpPos.substring(0,10) ;
            ret += "...";
        }
        else
             ret = dpPos

        console.debug("Station : " + ret );
        return ret;
    }
    function fitTime(value){
        var time = value.substring(value.indexOf(":", 0)+1, value.length);
        console.debug("Time : " + time);
        return time;
    }
    DataRequest{
        id: dataRequestCover
    }
    Connections{
        target: dataRequestCover
        ignoreUnknownSignals: true
        onSchedulesChanged:{
//            busyIndicator.running = false;
//            busyIndicator.visible = false;
            fillModel(dataRequestCover.scheduleList);
        }
    }
    Label{
        id: labelProTrain
//        text: "Estimation :"
        text: stationName
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin:10
        anchors.right: parent.right
        color: Theme.primaryColor
        font.bold: true
        font.pixelSize: 30
//        visible: list.model.count === 0
    }
    ListModel{
        id: coverList
    }

    ListView{
        id: list
        anchors.top : labelProTrain.bottom
        anchors.topMargin: 30
        model: coverList
        anchors.bottom: labelTime.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        height: 400
        delegate: Label {
            id: label
            height: 20
            anchors.left: parent.left
            anchors.right: parent.right
            text: fitWord(line);
            font.pixelSize: 28
            font.bold: true
            onTextChanged: {
                console.debug("TextCount : " + text.length)
            }
        }

        onModelChanged: {
            time();
        }
    }

    Image {
        id: imgType
        opacity: 0.2
        source: urlType
        width: 200
        height: 200
        anchors.left: parent.left
        anchors.top: parent.top
        fillMode: Image.PreserveAspectFit
    }
    Image {
        id: imgLine
        opacity: 0.2
        source: urlLine
        width: 200
        height: 200
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        fillMode: Image.PreserveAspectFit
    }
    Label{
        id: labelTime
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
    }



    CoverActionList {
        id: coverAction
        enabled: listModel.count > 0
        CoverAction {
            iconSource: "image://theme/icon-cover-next"
            onTriggered: {
                if(listModel.count-1 > _modelIndex)
                    _modelIndex++
                else
                    _modelIndex = 0;

                fitCover();
            }
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-refresh"

            onTriggered: {
                labelTime.text = Qt.formatDateTime("2010-03-17T10:15:16", "dd/MM/yyyy - hh:mm:ss");
            }
        }
    }
}


