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


import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.DataRequest 1.0

import "pages"
import "cover"

ApplicationWindow
{
    id: app
    property string sharedValue: "Le RATdeParis"
    property string _urlType
    property string _urlLine
    property var _sharedModel
    initialPage: Component {
        FirstPage{
//            title: qsTr("Itinéraire");
        }

    }
    cover: Component {
        CoverPage {
            id: myCover
            prt: app.sharedValue
//            modelList: _sharedModel
            urlLine: _urlLine
            urlType: _urlType
        }
    }
    DataRequest{
        id: dataRequest
        Component.onCompleted: dataRequest.getLines();
    }
    SecondPage{
        id: secondPage
    }

}
