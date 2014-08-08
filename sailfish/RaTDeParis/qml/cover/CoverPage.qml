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


CoverBackground {

    property string prt

    property string urlType
    property string urlLine
    property alias modelList: list.model
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

//    function time(){
//        var currentTime;
//        lastGettedTime = Qt.formatDateTime(new Date(), "hh:mm:ss");
//        labelTime.text = "a " + Qt.formatDateTime(lastGettedTime, "hh:mm:ss");
//    }
//    Timer{
//       interval: 60000; //1min
//       repeat: true
//       onTriggered: {
//            time();
//       }
//    }

    Label{
        id: labelProTrain
        text: "Estimation :"
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin:10
        anchors.right: parent.right
        color: Theme.primaryColor
        font.bold: true
        font.pixelSize: 30
        visible: list.model.count === 0
    }

    ListView{
        id: list
        anchors.top : labelProTrain.bottom
        anchors.topMargin: 30

        anchors.bottom: labelTime.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 10
        anchors.rightMargin: 10
//        anchors.verticalCenter: parent.verticalCenter
//        anchors.verticalCenterOffset: 20
        height: 400
        delegate: Label {
            id: label
            height: 20
//            anchors.verticalCenter: parent.verticalCenter

            anchors.left: parent.left
            anchors.right: parent.right
            text: fitWord(line);
            font.pixelSize: 28
//            wrapMode: Text.WordWrap
            font.bold: true
//            horizontalAlignment: Text.AlignHCenter
            onTextChanged: {
                console.debug("TextCount : " + text.length)
            }

//            anchors.centerIn: parent
//            anchors.verticalCenter: parent.verticalCenter
        }
        onModelChanged: {
            time();
        }
    }

    Label{
        id: labelTime
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
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
    CoverActionList {
        id: coverAction
        enabled: list.model.count > 0
//        CoverAction {
//            iconSource: "image://theme/icon-cover-next"
//        }

        CoverAction {
            iconSource: "image://theme/icon-cover-refresh"

            onTriggered: {
                labelTime.text = Qt.formatDateTime("2010-03-17T10:15:16", "dd/MM/yyyy - hh:mm:ss");
            }
        }
    }
}


