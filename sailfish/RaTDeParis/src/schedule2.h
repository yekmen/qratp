#ifndef SCHEDULES_H
#define SCHEDULES_H

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
private:
    QList<Schedule*> mSchedules;
signals:
    void scheduleListChanged();
};

#endif // SCHEDULES_H
