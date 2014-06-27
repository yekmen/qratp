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
