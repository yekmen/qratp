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
#include "schedule2.h"
#include <QJsonArray>
#include <QStringList>
#include <QDebug>

Schedule2::Schedule2(QObject *parent):
    JsonDerializer(parent)
{
}
void Schedule2::read(const QJsonObject &jsonObj)
{
    qDebug() << jsonObj.value("schedule").toArray();
    QJsonArray array = jsonObj["schedule"].toArray();
    for(int i = 0; i < array.size(); i++)
    {
        QString key = array.at(i).toObject().keys()[0];
        QString time = array.at(i).toObject()[key].toString();
        QString result = QString("%1 : %2").arg(key).arg(time);

        Schedule* sch = new Schedule(capitalize(result));
        mSchedules.push_back(sch);
    }
    emit scheduleListChanged();
}

QQmlListProperty<Schedule> Schedule2::scheduleList()
{
    return QQmlListProperty<Schedule>(this, mSchedules);

}

void Schedule2::clear()
{
    mSchedules.clear();
}
