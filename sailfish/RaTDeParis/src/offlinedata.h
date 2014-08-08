#ifndef OFFLINEDATA_H
#define OFFLINEDATA_H

#include <QObject>
#include "jsonderializer.h"
#include <QList>
#include <QUrl>
#include <QVariant>
#include "schedule2.h"
#include <QQmlListProperty>

class Data : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QUrl url READ getUrl)
    Q_PROPERTY(QString title READ getTitle)
//    Q_PROPERTY(QList urlLine READ getUrlLine)
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

//    QList getList() const
//    {
//        return list;
//    }
//    void setList(const QList &value)
//    {
//        list = value;
//    }

private:
//    QList list;
    QUrl mUrl;
    QString mTitle;
};

class OfflineData : public JsonDerializer
{
    Q_OBJECT

public:
    explicit OfflineData(QObject *parent = 0);
    Q_INVOKABLE void addItineraire(const QList<Schedule*> &value);
    void read(const QJsonObject &jsonObj);
    void write() const;
    void clear();
};

#endif // OFFLINEDATA_H
