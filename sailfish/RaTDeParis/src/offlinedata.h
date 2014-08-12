#ifndef OFFLINEDATA_H
#define OFFLINEDATA_H

#include <QObject>
#include "jsonderializer.h"
#include <QList>
#include <QUrl>
#include <QVariant>
#include "schedule2.h"
#include <QQmlListProperty>
enum Way{
    Aller = 0,
    Retour = 1
};

class Data : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QUrl url READ getUrl)
    Q_PROPERTY(QString title READ getTitle)
//    Q_PROPERTY(bool way READ getUrlLine)
public:
    Data(QObject *parent = 0):QObject(parent){}

    QUrl getUrl() const
    {
        return mUrl;
    }
    void setUrl(const QUrl &value)
    {
        mUrl = value;
    }

    QString getTitle() const
    {
        return mTitle;
    }
    void setTitle(const QString &value)
    {
        mTitle = value;
    }

    Way getSens() const
    {
        return sens;
    }
    void setSens(const Way &value)
    {
        sens = value;
    }

private:
    //    QList list;
    QUrl mUrl;
    QString mTitle;
    Way sens;
};

class OfflineData : public JsonDerializer
{
    Q_OBJECT
public:
    OfflineData(QObject *parent = 0);
    ~OfflineData();

    Q_INVOKABLE void addItineraire(const QString &value);
    void read(const QJsonObject &jsonObj);
//    void read(const QJsonObject &jsonObj);
    void write(const QString &itname, const QString &value);
    void clear();
};

#endif // OFFLINEDATA_H
