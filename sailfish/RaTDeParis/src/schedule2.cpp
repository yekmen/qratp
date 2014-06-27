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

        Schedule* sch = new Schedule(result);
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
