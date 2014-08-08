#include "offlinedata.h"
#include <QDebug>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>
#include <QFile>

OfflineData::OfflineData(QObject *parent) :
    JsonDerializer(parent)
{

}
void OfflineData::addItineraire(const QList<Schedule*> &value)
{
    qDebug() << "Value : " << value.count();
    write();
}
void OfflineData::read(const QJsonObject &jsonObj)
{

}
void OfflineData::write() const
{
    QFile file("test.json");
    file.open(QIODevice::ReadWrite);

    QJsonObject jObject;
    QJsonArray levelArray;
    QJsonDocument jsonDoc;

    jObject.insert("array", levelArray);
    jObject.insert("test", QJsonValue(QString("TESTT")));


    jsonDoc.setObject(jObject);

    file.write(jsonDoc.toJson());
    file.close();
}
void OfflineData::clear()
{

}
