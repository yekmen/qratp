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
                                 jObj.value("station").toString());
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

