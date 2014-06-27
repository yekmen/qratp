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
#include "directions.h"
#include <QJsonArray>
#include <QDebug>

Directions::Directions(QObject *parent):
    JsonDerializer(parent)
{
}

Directions::~Directions()
{

}

void Directions::read(const QJsonObject &jsonObj)
{
    QJsonArray array = jsonObj["directions"].toArray();
    for(int i = 0; i < array.size(); i++)
    {
        QJsonObject jObj = array.at(i).toObject();
        Direction *d = new Direction(jObj.value("id").toVariant().toInt(),
                                     capitalize(jObj.value("direction").toString()));
        mDirections.push_back(d);
    }
    emit directionsListChanged();
}

void Directions::clear()
{
    mDirections.clear();
}

QQmlListProperty<Direction> Directions::directionsList()
{
    return QQmlListProperty<Direction>(this, mDirections);
}
