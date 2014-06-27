#ifndef JSONDERIALIZER_H
#define JSONDERIALIZER_H

#include <QJsonObject>
#include <QObject>

class JsonDerializer : public QObject
{
    Q_OBJECT
public:
    JsonDerializer(QObject *parent =0):
        QObject(parent)
    {

    }

    virtual void read(const QJsonObject &jsonObj) = 0;
    virtual void clear() = 0;
    QString capitalize(const QString &str)
    {
        QString tmp = str;
        if(!str.isEmpty())
        {
            tmp = tmp.toLower();
            tmp[0] = str[0].toUpper();
        }
        return tmp;
    }
};

#endif // JSONDERIALIZER_H
