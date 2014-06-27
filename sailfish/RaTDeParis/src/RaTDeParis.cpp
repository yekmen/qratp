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
#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>
#include "datarequest.h"
//#include <QQmlEngine>
//#include <QtQml/QQmlEngine>

#include <qqml.h>   //qmlRegisterType !

int main(int argc, char *argv[])
{
    // SailfishApp::main() will display "qml/template.qml", if you need more
    // control over initialization, you can use:
    //
    //   - SailfishApp::application(int, char *[]) to get the QGuiApplication *
    //   - SailfishApp::createView() to get a new QQuickView * instance
    //   - SailfishApp::pathTo(QString) to get a QUrl to a resource file
    //
    // To display the view, call "show()" (will show fullscreen on device).
    qmlRegisterType<DataRequest>("harbour.DataRequest",1,0,"DataRequest");
    qmlRegisterType<Line>("harbour.DataRequest",1,0,"Line");
    qmlRegisterType<Lines>("harbour.DataRequest",1,0,"Lines");

    qmlRegisterType<Directions>("harbour.DataRequest",1,0,"Directions");
    qmlRegisterType<Direction>("harbour.DataRequest",1,0,"Direction");

    qmlRegisterType<Stations>("harbour.DataRequest",1,0,"Stations");
    qmlRegisterType<Station>("harbour.DataRequest",1,0,"Station");

    qmlRegisterType<Schedule2>("harbour.DataRequest",1,0,"Schedules");
    qmlRegisterType<Schedule>("harbour.DataRequest",1,0,"Schedule");
    QString value = "AOUITIO";
    qDebug() << value.toCaseFolded();
    return SailfishApp::main(argc, argv);
}

