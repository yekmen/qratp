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
//ApplicationWindow
//{
////    initialPage: Component { FirstPage { } }
//    cover: Qt.resolvedUrl("cover/CoverPage.qml")
//    FirstPage{
//        id: firstPage
//    }

//}

ApplicationWindow
{
    id: app
    property string sharedValue: "whatever you want to share to cover"
    initialPage: Component {
//        FirstPage {
        SecondPage{
//            prt: app.sharedValue
            //              torch: app.sharedValue

        }

    }
    cover: Component {
        CoverPage {
            //              torch: app.sharedValue
            prt: app.sharedValue
        }
    }

    DataRequest{
        id: dataRequest

        //        onErrorDownload: console.debug("Error : " + error)
        Component.onCompleted: dataRequest.getLines();
        //          onLinesListChanged: console.debug("OKK !! ");
    }


    SecondPage{
        id: secondPage
    }

}
