#include "offlinedata.h"
#include <QDebug>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>
#include <QFile>
#include <QStringList>

OfflineData::OfflineData(QObject *parent) :
    JsonDerializer(parent)
{

}

OfflineData::~OfflineData()
{

}
void OfflineData::addItineraire(const QString &value)
{
    qDebug() << "Value : " << value;
    write("itinName", value);
}

void OfflineData::read(const QJsonObject &jsonObj)
{
    QFile file("test.json");
    file.open(QIODevice::ReadOnly);

    QJsonDocument jsonDoc;
    jsonDoc.fromJson(file.readAll());
    //Get all itinaires
    QJsonObject currentData = jsonDoc.object();
    QStringList listOfIt = currentData.keys();
    for(int i = 0; i < listOfIt.size(); i++)
    {
        QJsonArray ar = jsonObj["lines"].toArray();
        for(int i = 0; i < ar.size(); i++)
        {
            QJsonObject jObj = ar.at(i).toObject();

//            Data *data = new data(jObj.value("id").toVariant().toInt(),
//                                  jObj.value("type_id").toVariant().toInt(),
//                                  jObj.value("line").toString(),
//                                  jObj.value("type_name").toString());
        }
    }
    file.close();
}

void OfflineData::write(const QString &itname, const QString &url)
{
    QFile file("test.json");
    file.open(QIODevice::ReadWrite);
    //------- GET THE CURRENT JSON ---------//

    QJsonObject jObject;

    QJsonObject itin;
    QJsonArray urls;
    itin.insert("sens", QJsonValue(false)); //False = aller | true = retour
    urls.append(QJsonValue(url));
    itin.insert("url", urls);

    jObject.insert(itname, itin);

    //------WRITE IN FILE------//
    QJsonDocument jsonDoc;
    jsonDoc.setObject(jObject);

    file.write(jsonDoc.toJson());
    file.close();
    //--------------------------//
    QJsonObject ret = jsonDoc.object();
    read(ret);
}
void OfflineData::clear()
{

}

