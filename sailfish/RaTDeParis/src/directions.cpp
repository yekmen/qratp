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
                                     jObj.value("direction").toString());
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
