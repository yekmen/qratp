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
#ifndef DIRECTIONS_H
#define DIRECTIONS_H

#include "jsonderializer.h"
#include <QObject>
#include <QQmlListProperty>

class Direction : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString line READ getDirection NOTIFY directionChanged)
    Q_PROPERTY(int idJson READ getId NOTIFY idJsonChanged)
    Q_PROPERTY(QString urlLine READ getUrlLine NOTIFY urlChanged)
    QString getUrlLine() const
    {
        return "";
    }
public:
    Direction(QObject *parent = 0):QObject(parent){}
    Direction(int _id, const QString &_direction, QObject *parent = 0) : QObject(parent)
    {
        setId(_id);
        setDirection(_direction);
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

    QString getDirection() const
    {
        return direction;
    }
    void setDirection(const QString &value)
    {
        direction = value;
        emit directionChanged();
    }


private:
    int id;
    QString direction;
signals:
    void directionChanged();
    void idJsonChanged();
    void urlChanged();
};

class Directions : public JsonDerializer
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<Direction> directionsList READ directionsList NOTIFY directionsListChanged)

public:
    Directions(QObject *parent = 0);
    ~Directions();
    void read(const QJsonObject &jsonObj);
    void clear();
    QQmlListProperty<Direction> directionsList();
private:
    QList<Direction*> mDirections;
signals:
    void directionsListChanged();
};

#endif // DIRECTIONS_H
