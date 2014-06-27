#ifndef DATAREQUEST_H
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
#define DATAREQUEST_H

#include <QObject>
#include "lines.h"
#include "schedule2.h"
#include "directions.h"
#include "stations.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrl>
#include <QUrlQuery>

#include <QJsonValue>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QVector>

class DataRequest : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<Line> linesList READ linesList NOTIFY linesListChanged)
    Q_PROPERTY(QQmlListProperty<Direction> directionsList READ directionsList NOTIFY directionsListChanged)
    Q_PROPERTY(QQmlListProperty<Station> stationsList READ stationsList NOTIFY stationsListChanged)
    Q_PROPERTY(QQmlListProperty<Schedule> scheduleList READ scheduleList NOTIFY schedulesChanged)

public:
    enum TypeData{
        TypeLines,
        TypeDirections,
        TypeStations,
        TypeSchedule
    };

    explicit DataRequest(QObject *parent = 0);
    ~DataRequest();
    Q_INVOKABLE void getLines(int lineTypeToInt);
    Q_INVOKABLE void getDirections(const int &line);
    Q_INVOKABLE void getStations(const int &line, const int &direction);
    Q_INVOKABLE void getSchedule(const int &line, const int &direction, const int &station);

    TypeData getCurrentType() const;
    void setCurrentType(const TypeData &value);
private:
    QNetworkAccessManager *mgr;
    TypeData currentType;
    Lines* mLines;
    Directions* mDirections;
    Stations* mStations;
    Schedule2* mSchedule;
public slots:
    void DownloadFinished(QNetworkReply *aReply);
    QQmlListProperty<Line> linesList();
    QQmlListProperty<Direction> directionsList();
    QQmlListProperty<Station> stationsList();
    QQmlListProperty<Schedule> scheduleList();
signals:
    void errorDownload(QString error);
    void downloaded();
    void linesListChanged();
    void directionsListChanged();
    void stationsListChanged();
    void schedulesChanged();
};

#endif // DATAREQUEST_H
