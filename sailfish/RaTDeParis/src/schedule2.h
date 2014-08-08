#ifndef SCHEDULES_H
#define SCHEDULES_H
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
#include "jsonderializer.h"
#include <QList>
#include <QString>
#include <QObject>
#include <QQmlListProperty>

class Schedule : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString line READ getResult NOTIFY resultChanged)  //line = generic name

public:
    Schedule(QObject *parent = 0) : QObject(parent)
    {

    }
    Schedule(QString _result, QObject *parent = 0) : QObject(parent)
    {
        setResult(_result);
    }

    QString getResult() const
    {
        return result;
    }

    void setResult(const QString &value)
    {
        result = value;
        emit resultChanged();
    }
private:
    QString result;
signals:
    void resultChanged();
};

class Schedule2 : public JsonDerializer
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<Schedule> scheduleList READ scheduleList NOTIFY scheduleListChanged)
public:
    Schedule2(QObject *parent = 0);
    void read(const QJsonObject &jsonObj);
    QQmlListProperty<Schedule> scheduleList();
    void clear();
    QList<Schedule*> getList() const;
private:
    QList<Schedule*> mSchedules;
signals:
    void scheduleListChanged();
};

#endif // SCHEDULES_H
