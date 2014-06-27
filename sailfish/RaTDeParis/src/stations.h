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
#ifndef STATIONS_H
#define STATIONS_H

#include "jsonderializer.h"
#include <QObject>
#include <QQmlListProperty>

class Station : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int idJson READ getId NOTIFY idJsonChanged)
    Q_PROPERTY(QString line READ getStation NOTIFY stationChanged)  //line = generic name
public:
    Station(QObject * parent = 0): QObject(parent)
    {

    }
    Station(int _id, QString _station, QObject *parent = 0) : QObject(parent)
    {
        setId(_id);
        setStation(_station);
    }

    QString getStation() const
    {
        return station;
    }
    void setStation(const QString &value)
    {
        station = value;
        emit stationChanged();
    }

    int getId() const
    {
        return id;
    }
    void setId(int value)
    {
        id = value;
        emit idJsonChanged();
    }

private:
    int id;
    QString station;
signals:
    void stationChanged();
    void idJsonChanged();
};

class Stations : public JsonDerializer
{
    Q_OBJECT

    Q_PROPERTY(QQmlListProperty<Station> stationList READ stationList NOTIFY stationListChanged)
public:
    Stations(QObject *parent = 0);
    ~Stations();
    void read(const QJsonObject &jsonObj);
    void clear();
    QQmlListProperty<Station> stationList();
private:
    QList<Station*> mStations;
signals:
    void stationListChanged();

};

#endif // STATIONS_H
