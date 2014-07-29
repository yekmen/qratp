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
#include "stations.h"
#include <QJsonArray>

Stations::Stations(QObject *parent):
    JsonDerializer(parent)
{
}

Stations::~Stations()
{

}

void Stations::read(const QJsonObject &jsonObj)
{
    QJsonArray array = jsonObj["stations"].toArray();
    for(int i = 0; i < array.size(); i++)
    {
        QJsonObject jObj = array.at(i).toObject();
        Station *s = new Station(jObj.value("id").toVariant().toInt(),
                                 capitalize(jObj.value("station").toString()));
        mStations.push_back(s);
    }
    emit stationListChanged();
}

void Stations::clear()
{
    mStations.clear();
}

QQmlListProperty<Station> Stations::stationList()
{
    return QQmlListProperty<Station>(this, mStations);
}
